// modules/security/key-vault/key_vault_access_policy.bicep

targetScope = 'resourceGroup'

@description('Nom du Key Vault parent.')
param keyVaultName string

@description('Liste des access policies à ajouter.')
param accessPolicies array = []

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: keyVaultName
}

resource policies 'Microsoft.KeyVault/vaults/accessPolicies@2024-11-01' = {
  name: 'add'
  parent: keyVault
  properties: {
    accessPolicies: [
      for accessPolicy in accessPolicies: {
        applicationId: accessPolicy.?applicationId ?? ''
        objectId: accessPolicy.objectId
        permissions: accessPolicy.permissions
        tenantId: accessPolicy.?tenantId ?? tenant().tenantId
      }
    ]
  }
}

@description('Nom du resource group.')
output resourceGroupName string = resourceGroup().name

@description('Nom de l\'assignation.')
output name string = policies.name

@description('ID de la ressource.')
output resourceId string = policies.id
