// workload-lz/modules/vm/virtual_machine_backup.bicep
// Ce module déploie une configuration de backup pour une machine virtuelle Azure, en associant la VM à une policy de backup définie dans un Recovery Services Vault.
// Il prend en charge la création d'un protected item dans le vault, qui représente la VM à protéger, et permet de spécifier les paramètres essentiels tels que le type de protected item, 
// l'ID de la policy de backup, et l'ID de la ressource source à protéger.  

targetScope = 'resourceGroup'

@description('Nom de la ressource protected item.')
param name string

@description('Nom du container de protection.')
param protectionContainerName string

@description('Nom du Recovery Services Vault.')
param recoveryVaultName string

@description('Localisation.')
param location string = resourceGroup().location

@description('ID de la policy de backup.')
param policyId string

@description('ID de la ressource source à protéger.')
param sourceResourceId string

resource protectedItem 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2025-02-01' = {
  name: '${recoveryVaultName}/Azure/${protectionContainerName}/${name}'
  location: location
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: policyId
    sourceResourceId: sourceResourceId
  }
}

@description('Nom du protected item.')
output name string = protectedItem.name

@description('ID du protected item.')
output resourceId string = protectedItem.id
