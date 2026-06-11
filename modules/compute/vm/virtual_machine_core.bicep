// workload-lz/modules/vm/virtual_machine_core.bicep  
// Ce module déploie une machine virtuelle Azure avec une configuration flexible pour les disques, les identités managées, les interfaces réseau, et d'autres paramètres essentiels. 
// Il prend en charge à la fois les systèmes d'exploitation Windows et Linux, avec des options spécifiques pour chaque type. 
// Les disques de données peuvent être créés ou attachés selon les besoins, et le module gère également les diagnostics de démarrage et les configurations de patching.

targetScope = 'resourceGroup'

@description('Nom de la VM.')
param name string

@description('Nom de l\'ordinateur dans l\'OS.')
param computerName string = name

@description('Taille de la VM.')
param vmSize string

@description('Référence de l\'image OS.')
param imageReference object

@description('Configuration du disque OS.')
param osDisk object

@description('Configuration des disques de données.')
param dataDisks array = []

@description('Nom d\'utilisateur administrateur.')
@secure()
param adminUsername string

@description('Mot de passe admin Windows.')
@secure()
param adminPassword string = ''

@description('Clés publiques SSH Linux.')
param publicKeys array = []

@description('Managed identities à affecter à la VM.')
param managedIdentities object = {
  systemAssigned: true
  userAssignedResourceIds: []
}

@description('Configurations NIC minimales.')
param nicConfigurations array

@description('Région de déploiement.')
param location string = resourceGroup().location

@description('Tags.')
param tags object = {}

@description('Type d\'OS.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Désactive l\'authentification par mot de passe pour Linux.')
param disablePasswordAuthentication bool = false

@description('Provisionne le VM agent.')
param provisionVMAgent bool = true

@description('Active les updates automatiques Windows.')
param enableAutomaticUpdates bool = true

@description('Mode de patching invité.')
param patchMode string = ''

@description('Mode d\'assessment des patchs.')
param patchAssessmentMode string = 'ImageDefault'

@description('Active les opérations d\'extension.')
param allowExtensionOperations bool = true

@description('Active le boot diagnostics.')
param bootDiagnostics bool = true

@description('Nom du storage account pour boot diagnostics.')
param bootDiagnosticStorageAccountName string = ''

@description('URI suffixe du storage account pour boot diagnostics.')
param bootDiagnosticStorageAccountUri string = '.blob.${environment().suffixes.storage}/'

@description('Availability zone, -1 si non utilisée.')
@allowed([
  -1
  1
  2
  3
])
param availabilityZone int = -1

@description('ID de l\'availability set.')
param availabilitySetResourceId string = ''

var isLinux = osType == 'Linux'

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

var identity = {
  type: managedIdentities.systemAssigned
    ? (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
    : (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
}

var linuxSshPublicKeys = [
  for publicKey in publicKeys: {
    path: publicKey.path
    keyData: publicKey.keyData
  }
]

var linuxConfiguration = {
  disablePasswordAuthentication: disablePasswordAuthentication
  ssh: {
    publicKeys: linuxSshPublicKeys
  }
  provisionVMAgent: provisionVMAgent
  patchSettings: !empty(patchMode)
    ? {
        patchMode: patchMode
        assessmentMode: patchAssessmentMode
      }
    : null
}

var windowsConfiguration = {
  provisionVMAgent: provisionVMAgent
  enableAutomaticUpdates: enableAutomaticUpdates
  patchSettings: !empty(patchMode)
    ? {
        patchMode: patchMode
        assessmentMode: patchAssessmentMode
      }
    : null
}

module managedDataDisks './virtual_machine_disk.bicep' = [
  for (dataDisk, index) in dataDisks: if (empty(dataDisk.?managedDisk.?resourceId) && ((dataDisk.?createOption ?? 'Empty') != 'FromImage')) {
    name: '${uniqueString(deployment().name, name, string(index))}-disk-${index}'
    params: {
      name: dataDisk.?name ?? '${name}-disk-data-${padLeft(string(index + 1), 2, '0')}'
      location: location
      sku: dataDisk.managedDisk.storageAccountType
      createOption: dataDisk.?createOption ?? 'Empty'
      diskSizeGB: dataDisk.?diskSizeGB
      diskEncryptionSetResourceId: dataDisk.managedDisk.?diskEncryptionSetResourceId ?? ''
      diskIOPSReadWrite: dataDisk.?diskIOPSReadWrite ?? 0
      diskMBpsReadWrite: dataDisk.?diskMBpsReadWrite ?? 0
      availabilityZone: availabilityZone != -1 && !contains(dataDisk.managedDisk.?storageAccountType ?? '', 'ZRS')
        ? availabilityZone
        : -1
      tags: dataDisk.?tags ?? tags
    }
  }
]

resource vm 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: name
  location: location
  identity: identity.?type == null ? null : identity
  tags: tags
  zones: availabilityZone != -1 ? [string(availabilityZone)] : null
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: imageReference
      osDisk: {
        name: osDisk.?name ?? '${name}-disk-os-01'
        createOption: osDisk.?createOption ?? 'FromImage'
        osType: osType
        deleteOption: osDisk.?deleteOption ?? 'Delete'
        diskSizeGB: osDisk.?diskSizeGB
        caching: osDisk.?caching ?? (isLinux ? 'ReadOnly' : 'ReadWrite')
        managedDisk: {
          storageAccountType: osDisk.managedDisk.storageAccountType
          id: osDisk.managedDisk.?resourceId
        }
      }
      dataDisks: [
        for (dataDisk, index) in dataDisks: {
          lun: dataDisk.?lun ?? index
          name: !empty(dataDisk.?managedDisk.?resourceId)
            ? last(split(dataDisk.managedDisk.resourceId, '/'))
            : dataDisk.?name ?? '${name}-disk-data-${padLeft(string(index + 1), 2, '0')}'
          createOption: !empty(dataDisk.?managedDisk.?resourceId) || (!empty(managedDataDisks[index].?outputs.resourceId))
            ? 'Attach'
            : (dataDisk.?createOption ?? 'Empty')
          deleteOption: !empty(dataDisk.?managedDisk.?resourceId) ? 'Detach' : (dataDisk.?deleteOption ?? 'Delete')
          caching: !empty(dataDisk.?managedDisk.?resourceId) ? 'None' : (dataDisk.?caching ?? 'ReadOnly')
          diskSizeGB: (dataDisk.?createOption ?? 'Empty') == 'FromImage' ? null : dataDisk.?diskSizeGB
          managedDisk: {
            storageAccountType: dataDisk.managedDisk.?storageAccountType
            id: dataDisk.managedDisk.?resourceId ?? managedDataDisks[index].?outputs.resourceId
          }
        }
      ]
    }
    osProfile: {
      computerName: computerName
      adminUsername: adminUsername
      adminPassword: isLinux ? null : adminPassword
      linuxConfiguration: isLinux ? linuxConfiguration : null
      windowsConfiguration: !isLinux ? windowsConfiguration : null
      allowExtensionOperations: allowExtensionOperations
    }
    networkProfile: {
      networkInterfaces: [
        for (nicConfiguration, index) in nicConfigurations: {
          properties: {
            deleteOption: nicConfiguration.?deleteOption ?? 'Delete'
            primary: index == 0
          }
          id: resourceId('Microsoft.Network/networkInterfaces', nicConfiguration.name)
        }
      ]
    }
    diagnosticsProfile: bootDiagnostics
      ? {
          bootDiagnostics: {
            enabled: true
            storageUri: !empty(bootDiagnosticStorageAccountName)
              ? 'https://${bootDiagnosticStorageAccountName}${bootDiagnosticStorageAccountUri}'
              : null
          }
        }
      : null
    availabilitySet: !empty(availabilitySetResourceId) && availabilityZone == -1
      ? {
          id: availabilitySetResourceId
        }
      : null
  }
}

@description('ID de la VM.')
output vmId string = vm.id

@description('Nom de la VM.')
output vmName string = vm.name

@description('Principal ID de la managed identity system-assigned.')
output principalId string = vm.identity.principalId

@description('Resource group de la VM.')
output resourceGroupName string = resourceGroup().name
