// modules/security/rsv/backup_policy.bicep
// Politique de sauvegarde d’un Recovery Services Vault.
// Ce module reste volontairement générique :
// il accepte directement l’objet properties attendu par la ressource enfant,
// ce qui permet de couvrir AzureIaasVM, AzureStorage, AzureWorkload, etc.

targetScope = 'resourceGroup'

@description('Nom du Recovery Services Vault parent.')
param recoveryVaultName string

@description('Nom de la politique de sauvegarde.')
param name string

@description('Propriétés complètes de la politique de sauvegarde.')
param properties object

// récupération du Recovery Services Vault parent
resource recoveryVault 'Microsoft.RecoveryServices/vaults@2025-08-01' existing = {
  name: recoveryVaultName
}

// création de la politique de sauvegarde
resource backupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-08-01' = {
  parent: recoveryVault
  name: name
  properties: properties
}

// outputs
@description('Nom de la politique de sauvegarde.')
output name string = backupPolicy.name

@description('ID de ressource de la politique de sauvegarde.')
output resourceId string = backupPolicy.id

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name
