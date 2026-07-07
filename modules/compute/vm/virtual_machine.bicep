// modules/compute/vm/virtual-machine.bicep
// Module de déploiement d'une machine virtuelle Azure avec des configurations flexibles pour les systèmes Linux et Windows, incluant la gestion des disques, des extensions et des options de sécurité.
// Ce module intègre les meilleures pratiques pour la configuration des machines virtuelles, telles que l'utilisation d'identités managées, l'activation des diagnostics et la configuration de la mise à jour automatique des correctifs.  

targetScope = 'resourceGroup'

@description('Nom de la machine virtuelle')
param vmName string

@description('Région de déploiement')
param location string = resourceGroup().location

@description('Taille de la machine virtuelle')
param vmSize string

@description('Nom d\'utilisateur administrateur')
@secure()
param adminUsername string

@description('Mot de passe administrateur (Windows) ou clé publique SSH (Linux)')
@secure()
param adminPasswordOrKey string

@description('Type d\'OS')
@allowed([
  'Windows'
  'Linux'
])
param osType string = 'Windows'

@description('Éditeur de l\'image OS')
param imagePublisher string = 'MicrosoftWindowsServer'

@description('Offre de l\'image OS')
param imageOffer string = 'WindowsServer'

@description('SKU de l\'image OS')
param imageSku string

@description('Version de l\'image OS')
param imageVersion string = 'latest'

@description('Taille du disque OS en GB')
@minValue(128)
@maxValue(1024)
param osDiskSizeGb int = 128

@description('Type de stockage du disque OS')
param osDiskType string

@description('ID du sous-réseau pour la carte réseau')
param subnetId string

@description('Activer l\'adresse IP publique sur la carte réseau')
param enablePublicIp bool = false

@description('Activer l\'accélération réseau')
param enableAcceleratedNetworking bool = true

@description('Zones de disponibilité')
param availabilityZones array = []

@description('ID du groupe à haute disponibilité')
param availabilitySetId string = ''

@description('ID de la Managed Identity à assigner à la VM')
param managedIdentityId string = ''

@description('Activer l\'agent Azure Monitor (AMA)')
param enableAzureMonitorAgent bool = true

@description('Activer l\'extension Dependency Agent')
param enableDependencyAgent bool = false

@description('Activer l\'extension Azure AD Login (SSO)')
param enableAzureAdLogin bool = false

@description('Activer l\'extension Anti-Malware (Windows uniquement)')
param enableAntiMalware bool = false

@description('Activer la mise à jour automatique des correctifs')
param enableAutomaticPatching bool = true

@description('Disques de données à attacher')
param dataDisks array = []

@description('Tags à appliquer aux ressources')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

@description('Activer l\'inscription au backup Recovery Services Vault')
param enableBackup bool = false

@description('Nom du Recovery Services Vault')
param backupVaultName string = ''

@description('Nom du Resource Group du Recovery Services Vault')
param backupVaultResourceGroup string = resourceGroup().name

@description('Nom de la policy de backup')
param backupPolicyName string = 'DefaultPolicy'

// Variables
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

var isLinux = osType == 'Linux'

var nicName = '${vmName}-nic'

var publicIpName = '${vmName}-pip'

var osDiskName = '${vmName}-osdisk'

var availabilityZone = empty(availabilityZones) ? -1 : int(first(availabilityZones))

var nicConfigurations = [
  {
    name: nicName
    nicSuffix: '-nic'
    enableAcceleratedNetworking: enableAcceleratedNetworking
    ipConfigurations: [
      {
        name: 'ipconfig1'
        subnetResourceId: subnetId
        privateIPAllocationMethod: 'Dynamic'
        pipConfiguration: enablePublicIp
          ? {
              name: publicIpName
              publicIpNameSuffix: '-pip'
              publicIPAllocationMethod: 'Static'
              skuName: 'Standard'
              availabilityZones: empty(availabilityZones) ? null : availabilityZones
            }
          : null
      }
    ]
    diagnosticSettings: (enableDiagnostics && !empty(logAnalyticsWorkspaceId))
      ? [
          {
            name: '${nicName}-diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            metrics: [
              {
                category: 'AllMetrics'
                enabled: true
              }
            ]
          }
        ]
      : []
  }
]

var imageReference = {
  publisher: imagePublisher
  offer: imageOffer
  sku: imageSku
  version: imageVersion
}

var osDisk = {
  name: osDiskName
  createOption: 'FromImage'
  diskSizeGB: osDiskSizeGb
  caching: isLinux ? 'ReadOnly' : 'ReadWrite'
  managedDisk: {
    storageAccountType: osDiskType
  }
}

var mappedDataDisks = [
  for (disk, i) in dataDisks: {
    lun: i
    name: disk.?name ?? '${vmName}-datadisk-${i}'
    createOption: disk.?createOption ?? 'Empty'
    diskSizeGB: disk.sizeGb
    managedDisk: {
      storageAccountType: disk.?storageType ?? 'Premium_LRS'
    }
    caching: disk.?caching ?? 'None'
  }
]

var managedIdentities = empty(managedIdentityId)
  ? {
      systemAssigned: true
      userAssignedResourceIds: []
    }
  : {
      systemAssigned: false
      userAssignedResourceIds: [managedIdentityId]
    }

var publicKeys = isLinux
  ? [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  : []

var patchMode = isLinux
  ? (enableAutomaticPatching ? 'AutomaticByPlatform' : 'ImageDefault')
  : (enableAutomaticPatching ? 'AutomaticByPlatform' : 'Manual')

//==================================================================
// Création de la machine virtuelle et de ses ressources associées
//==================================================================

module vmNic './virtual_machine_nic_configuration.bicep' = {
  name: '${uniqueString(deployment().name, vmName, resolvedLocation)}-nic'
  params: {
    networkInterfaceName: nicName
    virtualMachineName: vmName
    ipConfigurations: nicConfigurations[0].ipConfigurations
    location: resolvedLocation
    tags: tags
    enableIPForwarding: false
    enableAcceleratedNetworking: enableAcceleratedNetworking
    dnsServers: []
    networkSecurityGroupResourceId: ''
    diagnosticSettings: nicConfigurations[0].diagnosticSettings
  }
}

module vmCore './virtual_machine_core.bicep' = {
  name: '${uniqueString(deployment().name, vmName, resolvedLocation)}-vm'
  params: {
    name: vmName
    computerName: vmName
    vmSize: vmSize
    imageReference: imageReference
    osDisk: osDisk
    dataDisks: mappedDataDisks
    adminUsername: adminUsername
    adminPassword: isLinux ? '' : adminPasswordOrKey
    publicKeys: publicKeys
    managedIdentities: managedIdentities
    nicConfigurations: [
      {
        name: nicName
        nicSuffix: '-nic'
        deleteOption: 'Delete'
      }
    ]
    location: resolvedLocation
    tags: tags
    osType: osType
    patchMode: patchMode
    patchAssessmentMode: 'AutomaticByPlatform'
    enableAutomaticUpdates: enableAutomaticPatching
    disablePasswordAuthentication: isLinux
    availabilityZone: availabilityZone
    availabilitySetResourceId: empty(availabilityZones) ? availabilitySetId : ''
    allowExtensionOperations: true
    bootDiagnostics: true
  }
}

module amaExtension './virtual_machine_extension.bicep' = if (enableAzureMonitorAgent && !empty(logAnalyticsWorkspaceId)) {
  name: '${uniqueString(deployment().name, vmName)}-ama'
  params: {
    virtualMachineName: vmName
    name: isLinux ? 'AzureMonitorLinuxAgent' : 'AzureMonitorWindowsAgent'
    location: resolvedLocation
    publisher: 'Microsoft.Azure.Monitor'
    type: isLinux ? 'AzureMonitorLinuxAgent' : 'AzureMonitorWindowsAgent'
    typeHandlerVersion: isLinux ? '1.0' : '1.1'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
    settings: {}
    tags: tags
  }
}

module dependencyAgentExtension './virtual_machine_extension.bicep' = if (enableDependencyAgent) {
  name: '${uniqueString(deployment().name, vmName)}-dependency'
  params: {
    virtualMachineName: vmName
    name: isLinux ? 'DependencyAgentLinux' : 'DependencyAgentWindows'
    location: resolvedLocation
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: isLinux ? 'DependencyAgentLinux' : 'DependencyAgentWindows'
    typeHandlerVersion: '9.10'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
    settings: {
      enableAMA: true
    }
    provisionAfterExtensions: [
      isLinux ? 'AzureMonitorLinuxAgent' : 'AzureMonitorWindowsAgent'
    ]
    tags: tags
  }
}

module aadLoginExtension './virtual_machine_extension.bicep' = if (enableAzureAdLogin) {
  name: '${uniqueString(deployment().name, vmName)}-aad'
  params: {
    virtualMachineName: vmName
    name: isLinux ? 'AADSSHLoginForLinux' : 'AADLoginForWindows'
    location: resolvedLocation
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: isLinux ? 'AADSSHLoginForLinux' : 'AADLoginForWindows'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: false
    settings: {}
    tags: tags
  }
}

module antiMalwareExtension './virtual_machine_extension.bicep' = if (enableAntiMalware && !isLinux) {
  name: '${uniqueString(deployment().name, vmName)}-antimalware'
  params: {
    virtualMachineName: vmName
    name: 'IaaSAntimalware'
    location: resolvedLocation
    publisher: 'Microsoft.Azure.Security'
    type: 'IaaSAntimalware'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: false
    settings: {
      AntimalwareEnabled: true
      RealtimeProtectionEnabled: true
      ScheduledScanSettings: {
        isEnabled: true
        day: '1'
        time: '120'
        scanType: 'Quick'
      }
    }
    tags: tags
  }
}

module backupProtectedItem './virtual_machine_backup.bicep' = if (enableBackup && !empty(backupVaultName)) {
  name: '${uniqueString(deployment().name, vmName)}-backup'
  scope: resourceGroup(subscription().subscriptionId, backupVaultResourceGroup)
  params: {
    recoveryVaultName: backupVaultName
    protectionContainerName: 'IaasVMContainer;iaasvmcontainerv2;${resourceGroup().name};${vmName}'
    name: 'VM;iaasvmcontainerv2;${resourceGroup().name};${vmName}'
    policyId: resourceId(
      backupVaultResourceGroup,
      'Microsoft.RecoveryServices/vaults/backupPolicies',
      backupVaultName,
      backupPolicyName
    )
    sourceResourceId: vmCore.outputs.vmId
    location: resolvedLocation
  }
}

// Outputs
@description('ID de la machine virtuelle')
output vmId string = vmCore.outputs.vmId

@description('Nom de la machine virtuelle')
output vmName string = vmCore.outputs.vmName

@description('ID de la carte réseau')
output nicId string = vmNic.outputs.resourceId

@description('Adresse IP privée de la VM')
output privateIpAddress string = vmNic.outputs.privateIpAddress

@description('ID de l\'identité managée de la VM (System-Assigned si aucune identité utilisateur n\'est fournie)')
output principalId string = empty(managedIdentityId) ? vmCore.outputs.principalId : ''

@description('ID de l\'adresse IP publique (si activée)')
output publicIpId string = enablePublicIp ? vmNic.outputs.publicIpId : ''
