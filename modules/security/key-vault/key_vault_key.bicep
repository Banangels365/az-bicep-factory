// modules/security/key-vault/key_vault_key.bicep
// Ce module permet de créer une clé dans un Key Vault existant,  
// avec des options de configuration pour les attributs de la clé, les tags, les policies de release et de rotation, 
// et les role assignments associés.

targetScope = 'resourceGroup'

@description('Nom du Key Vault parent.')
param keyVaultName string

@description('Nom de la clé.')
param name string

@description('Tags à appliquer.')
param tags object = {}

@description('Indique si la clé est activée.')
param attributesEnabled bool = true

@description('Date d\'expiration en secondes depuis le 1er janvier 1970 à 00:00:00Z.')
// Pour des raisons de sécurité, il est recommandé de définir une date d'expiration dans la mesure du possible.
param attributesExp int?

@description('Date minimale d\'expiration en secondes depuis le 1er janvier 1970 à 00:00:00Z.')
param attributesNbf int?

@description('Nom de la courbe elliptique.')
@allowed([
  'P-256'
  'P-256K'
  'P-384'
  'P-521'
])
param curveName string = 'P-256'

@description('Opérations autorisées sur la clé.')
param keyOps array = []

@description('Taille de la clé en bits.')
param keySize int?

@description('Type de clé.')
@allowed([
  'EC'
  'EC-HSM'
  'RSA'
  'RSA-HSM'
])
param kty string = 'EC'

@description('Release policy.')
param releasePolicy object = {}

@description('Rotation policy.')
param rotationPolicy object?

@description('Role assignments au scope de la clé.')
param roleAssignments array = []

// Récupération du Key Vault existant
resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: keyVaultName
}

// Création de la clé dans le Key Vault
resource key 'Microsoft.KeyVault/vaults/keys@2024-11-01' = {
  name: name
  parent: keyVault
  tags: tags
  properties: {
    attributes: {
      enabled: attributesEnabled
      exp: attributesExp
      nbf: attributesNbf
    }
    curveName: curveName
    keyOps: !empty(keyOps) ? keyOps : null
    keySize: keySize
    kty: kty
    release_policy: releasePolicy
    ...(!empty(rotationPolicy ?? {}) ? { rotationPolicy: rotationPolicy } : {})
  }
}

resource keyRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in roleAssignments: {
    name: roleAssignment.?name ?? guid(key.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: key
  }
]

// Outputs
@description('URI de la clé.')
output keyUri string = key.properties.keyUri

@description('URI versionnée de la clé.')
output keyUriWithVersion string = key.properties.keyUriWithVersion

@description('Nom de la clé.')
output keyName string = key.name

@description('ID de la clé.')
output resourceId string = key.id

@description('Nom du resource group.')
output resourceGroupName string = resourceGroup().name
