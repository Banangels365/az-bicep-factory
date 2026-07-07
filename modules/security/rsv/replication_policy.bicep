// modules/security/rsv/replication_policy.bicep
// Politique de réplication Site Recovery d’un Recovery Services Vault.

targetScope = 'resourceGroup'

@description('Nom du Recovery Services Vault parent.')
param recoveryVaultName string

@description('Nom de la politique de réplication.')
param name string

@description('Fréquence des snapshots app-consistent en minutes.')
param appConsistentFrequencyInMinutes int = 60

@description('Fréquence des snapshots crash-consistent en minutes.')
param crashConsistentFrequencyInMinutes int = 5

@description('Active ou désactive la synchronisation multi-VM.')
@allowed([
  'Enable'
  'Disable'
])
param multiVmSyncStatus string = 'Enable'

@description('Durée de conservation des points de récupération en minutes.')
param recoveryPointHistory int = 1440

// Création de la politique de réplication
resource replicationPolicy 'Microsoft.RecoveryServices/vaults/replicationPolicies@2025-08-01' = {
  name: '${recoveryVaultName}/${name}'
  properties: {
    providerSpecificInput: {
      instanceType: 'A2A'
      appConsistentFrequencyInMinutes: appConsistentFrequencyInMinutes
      crashConsistentFrequencyInMinutes: crashConsistentFrequencyInMinutes
      multiVmSyncStatus: multiVmSyncStatus
      recoveryPointHistory: recoveryPointHistory
    }
  }
}

// outputs
@description('Nom de la politique de réplication.')
output name string = replicationPolicy.name

@description('ID de ressource de la politique de réplication.')
output resourceId string = replicationPolicy.id

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name
