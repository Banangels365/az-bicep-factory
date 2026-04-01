// identity-lz/modules/rbac_assignment.bicep
// RBAC Role Assignment module

targetScope = 'resourceGroup'

@description('Principal ID (Object ID) to assign the role to')
param principalId string

@description('Role definition ID or name')
param roleDefinitionIdOrName string

@description('Principal type')
@allowed([
  'User'
  'Group'
  'ServicePrincipal'
  'ForeignGroup'
])
param principalType string = 'ServicePrincipal'

@description('Description for the role assignment')
param roleAssignmentDescription string = ''

@description('Condition for the role assignment (ABAC)')
param condition string = ''

@description('Condition version')
param conditionVersion string = '2.0'

@description('Delegated managed identity resource ID')
param delegatedManagedIdentityResourceId string = ''

// Built-in role definitions mapping
var builtInRoleNames = {
  Owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'User Access Administrator': '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  'Key Vault Administrator': '00482a5a-887f-4fb3-b755-3011c0c68c3f'
  'Key Vault Secrets User': '4633458b-17de-408a-b874-0445c86b69e6'
  'Storage Blob Data Contributor': 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  'Storage Blob Data Reader': '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  'Storage Queue Data Contributor': '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
  'Monitoring Contributor': '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  'Monitoring Reader': '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  'Network Contributor': '4d97b98b-1d4f-4787-a291-c67834d212e7'
  'Security Admin': 'fb1c8493-542b-48eb-b624-b4c8fea62acd'
  'Security Reader': '39bc4728-0917-49c7-9d2c-d95423bc2eb4'
  'SQL DB Contributor': '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec'
  'SQL Security Manager': '056cd41c-7e88-42e1-933e-88ba6a50c9c3'
  'Virtual Machine Contributor': '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  'Website Contributor': 'de139f84-1756-47ae-9be6-808fbbe84772'
  //'AcrPull': '7f951dda-4ed3-4680-a7ca-43fe172d538d'
  //'AcrPush': '8311e382-0749-4cb8-b61a-304f252e45ec'
  'Kubernetes Cluster Admin': '0ab0b1a8-8aac-4efd-b8c2-3ee1fb270be8'
  'Azure Kubernetes Service RBAC Admin': '3498e952-d568-435e-9b2c-8d77e338d7f7'
  'Cosmos DB Account Reader Role': 'fbdf93bf-df7d-467e-a4d2-9458aa1360c8'
  'DocumentDB Account Contributor': '5bd9cd88-fe45-4216-938b-f97437e15450'
}

// Determine if role is built-in or custom
var roleDefinitionId = contains(builtInRoleNames, roleDefinitionIdOrName)
  ? subscriptionResourceId('Microsoft.Authorization/roleDefinitions', builtInRoleNames[roleDefinitionIdOrName])
  : (startsWith(roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
      ? roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionIdOrName))

// Role Assignment Resource
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(principalId, roleDefinitionId, resourceGroup().id)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: principalType
    description: !empty(roleAssignmentDescription) ? roleAssignmentDescription : null
    condition: !empty(condition) ? condition : null
    conditionVersion: !empty(condition) ? conditionVersion : null
    delegatedManagedIdentityResourceId: !empty(delegatedManagedIdentityResourceId)
      ? delegatedManagedIdentityResourceId
      : null
  }
}

// Outputs
@description('Role Assignment resource ID')
output roleAssignmentId string = roleAssignment.id

@description('Role Assignment name (GUID)')
output roleAssignmentName string = roleAssignment.name

@description('Principal ID')
output principalId string = roleAssignment.properties.principalId

@description('Role Definition ID')
output roleDefinitionId string = roleAssignment.properties.roleDefinitionId
