// modules/security/key-vault/key_vault_secret.bicep
// Ce module permet de créer un secret dans un Key Vault existant, 
// avec des options de configuration pour les attributs du secret, les tags, et les role assignments associés.

targetScope = 'resourceGroup'

@description('Nom du Key Vault parent.')
param keyVaultName string

@description('Nom du secret.')
@minLength(1)
@maxLength(127)
param name string

@description('Tags à appliquer.')
param tags object = {}

@description('Indique si le secret est activé.')
param attributesEnabled bool = true

@description('Date d\'expiration en secondes depuis le 1er janvier 1970 à 00:00:00Z.')
// Pour des raisons de sécurité, il est recommandé de définir une date d'expiration dans la mesure du possible.
param attributesExp int?

@description('Date minimale d\'expiration en secondes depuis le 1er janvier 1970 à 00:00:00Z.')
param attributesNbf int?

@description('Content type du secret.')
@secure()
param contentType string?

@description('Valeur du secret.')
@secure()
param value string

@description('Role assignments au scope du secret.')
param roleAssignments array = []

// Récupération du Key Vault existant
resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: keyVaultName
}

// Création du secret dans le Key Vault
resource secret 'Microsoft.KeyVault/vaults/secrets@2024-11-01' = {
  name: name
  parent: keyVault
  tags: tags
  properties: {
    contentType: contentType
    attributes: {
      enabled: attributesEnabled
      exp: attributesExp
      nbf: attributesNbf
    }
    value: value
  }
}

resource secretRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in roleAssignments: {
    name: roleAssignment.?name ?? guid(secret.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: secret
  }
]

// Outputs
@description('Nom du secret.')
output secretName string = secret.name

@description('ID du secret.')
output resourceId string = secret.id

@description('URI du secret.')
output secretUri string = secret.properties.secretUri

@description('URI versionnée du secret.')
output secretUriWithVersion string = secret.properties.secretUriWithVersion

@description('Nom du resource group.')
output resourceGroupName string = resourceGroup().name
