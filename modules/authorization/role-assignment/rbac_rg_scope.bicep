// modules/authorization/role-assignment/rbac_rg_scope.bicep
// RBAC Role Assignment module at Resource Group scope

targetScope = 'resourceGroup'

@description('ID du principal (utilisateur, groupe, service principal, managed identity ou groupe externe) auquel le rôle sera assigné.')
param principalId string

@description('ID ou nom de la définition de rôle.')
param roleDefinitionIdOrName string

@description('Type du principal.')
@allowed([
  'User'
  'Group'
  'ServicePrincipal'
  'ForeignGroup'
  'Device'
])
param principalType string = 'ServicePrincipal'

@description('Description de l\'affectation de rôle.')
param roleAssignmentDescription string = ''

@description('Condition pour l\'affectation de rôle.')
param condition string = ''

@description('Version de la condition pour l\'affectation de rôle.')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

@description('ID de la ressource d\'identité managée déléguée pour les affectations de rôle nécessitant une identité managée.')
param delegatedManagedIdentityResourceId string = ''

// Variables

// Mapping des noms de rôles intégrés aux GUID correspondants
// La résolution accepte :
// - un nom de rôle intégré présent dans cette table,
// - un ID complet de roleDefinition,
// - un GUID de roleDefinition à résoudre au niveau subscription.
var builtInRoleNames = {
  Owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: 'acdd72a7-4e5e-48ef-bd42-f606fba81ae7'
  AcrPull: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
  AcrPush: '8311e382-0749-4cb8-b61a-304f252e45ec'
  'Azure Kubernetes Service RBAC Admin': '3498e952-d568-435e-9b2c-8d77e338d7f7'
  'Backup Contributor': '5e467623-bb1f-42f4-a55d-6e525e11384b'
  'Backup Operator': '00c29273-979b-4161-815c-10b084fb9324'
  'Backup Reader': 'a795c7a0-d4a2-40c1-ae25-d81f01202912'
  'Cosmos DB Account Reader Role': 'fbdf93bf-df7d-467e-a4d2-9458aa1360c8'
  'Cost Management Contributor': '434105ed-43f6-45c7-a02f-909b2ba83430'
  'Cost Management Reader': '72fafb9e-0641-4937-9268-a91bfd8191a3'
  'DocumentDB Account Contributor': '5bd9cd88-fe45-4216-938b-f97437e15450'
  'Key Vault Administrator': '00482a5a-887f-4fb3-b755-3011c0c68c3f'
  'Key Vault Secrets User': '4633458b-17de-408a-b874-0445c86b69e6'
  'Kubernetes Cluster Admin': '0ab0b1a8-8aac-4efd-b8c2-3ee1fb270be8'
  'Monitoring Contributor': '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  'Monitoring Reader': '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  'Network Contributor': '4d97b98b-1d4f-4787-a291-c67834d212e7'
  'Security Admin': 'fb1c8493-542b-48eb-b624-b4c8fea62acd'
  'Security Reader': '39bc4728-0917-49c7-9d2c-d95423bc2eb4'
  'Storage Blob Data Contributor': 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  'Storage Blob Data Reader': '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  'Storage Queue Data Contributor': '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
  'SQL DB Contributor': '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec'
  'SQL Security Manager': '056cd41c-7e88-42e1-933e-88ba6a50c9c3'
  'User Access Administrator': '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  'Virtual Machine Contributor': '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  'Website Contributor': 'de139f84-1756-47ae-9be6-808fbbe84772'
}

var roleDefinitionId = contains(builtInRoleNames, roleDefinitionIdOrName)
  ? subscriptionResourceId('Microsoft.Authorization/roleDefinitions', builtInRoleNames[roleDefinitionIdOrName])
  : (startsWith(roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
      ? roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionIdOrName))

// Création de la ressource d'affectation de rôle
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(principalId, roleDefinitionId, resourceGroup().id)
  properties: union(
    {
      roleDefinitionId: roleDefinitionId
      principalId: principalId
      principalType: principalType
    },
    !empty(roleAssignmentDescription) ? { description: roleAssignmentDescription } : {},
    !empty(condition) ? { condition: condition } : {},
    !empty(condition) ? { conditionVersion: conditionVersion } : {},
    !empty(delegatedManagedIdentityResourceId)
      ? { delegatedManagedIdentityResourceId: delegatedManagedIdentityResourceId }
      : {}
  )
}

// Outputs

@description('ID de l\'affectation de rôle.')
output roleAssignmentId string = roleAssignment.id

@description('Nom de l\'affectation de rôle (GUID).')
output roleAssignmentName string = roleAssignment.name

@description('ID du principal auquel le rôle est assigné.')
output principalId string = roleAssignment.properties.principalId

@description('ID de la définition de rôle utilisée.')
output roleDefinitionId string = roleAssignment.properties.roleDefinitionId

@description('Scope effectif de l\'affectation de rôle.')
output scope string = resourceGroup().id
