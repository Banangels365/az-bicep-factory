// modules/compute/des/key_vault_permissions.bicep
// Attribution des permissions minimales nécessaires à une identité user-assigned
// pour utiliser une clé Key Vault avec un Disk Encryption Set.
//
// Comportement :
// - si le Key Vault est en mode RBAC : création d'un role assignment sur la clé,
// - sinon : ajout d'une access policy sur le Key Vault.

targetScope = 'resourceGroup'

@description('Indique si le Key Vault utilise le modèle d\'autorisation RBAC.')
param rbacAuthorizationEnabled bool

@description('ID de ressource de l\'identité user-assigned à autoriser.')
param userAssignedIdentityResourceId string

@description('Région de déploiement. Utilisée uniquement pour stabiliser certains noms.')
param location string = resourceGroup().location

@description('ID de ressource du Key Vault contenant la clé.')
param keyVaultResourceId string

@description('Nom de la clé à autoriser.')
param keyName string

// Variables

var keyVaultName = last(split(keyVaultResourceId, '/'))

var uamiSubscriptionId = split(userAssignedIdentityResourceId, '/')[2]

var uamiResourceGroupName = split(userAssignedIdentityResourceId, '/')[4]

var uamiName = last(split(userAssignedIdentityResourceId, '/'))

// Création des ressources

resource keyVault 'Microsoft.KeyVault/vaults@2025-05-01' existing = {
  name: keyVaultName
}

resource key 'Microsoft.KeyVault/vaults/keys@2025-05-01' existing = {
  parent: keyVault
  name: keyName
}

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: uamiName
  scope: resourceGroup(uamiSubscriptionId, uamiResourceGroupName)
}

// Cas RBAC : attribution du rôle Key Vault Crypto Service Encryption User au scope de la clé.
resource keyVaultKeyRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (rbacAuthorizationEnabled) {
  name: guid('des-kv-key-rbac', key.id, userAssignedIdentityResourceId, location)
  scope: key
  properties: {
    principalId: userAssignedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    )
    principalType: 'ServicePrincipal'
    description: 'Autorise l\'identité user-assigned à utiliser la clé pour le Disk Encryption Set.'
  }
}

// Cas Access Policy : attribution des permissions minimales sur les clés.
resource keyVaultAccessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2025-05-01' = if (!rbacAuthorizationEnabled) {
  name: 'add'
  parent: keyVault
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: userAssignedIdentity.properties.principalId
        permissions: {
          keys: [
            'get'
            'wrapKey'
            'unwrapKey'
          ]
        }
      }
    ]
  }
}

// Outputs

@description('Nom de la ressource de permission créée.')
output name string = rbacAuthorizationEnabled ? keyVaultKeyRoleAssignment.name : keyVaultAccessPolicies.name

@description('ID de la ressource de permission créée.')
output resourceId string = rbacAuthorizationEnabled ? keyVaultKeyRoleAssignment.id : keyVaultAccessPolicies.id

@description('Nom du Key Vault ciblé.')
output keyVaultName string = keyVaultName

@description('Nom du resource group de déploiement de la permission.')
output resourceGroupName string = resourceGroup().name
