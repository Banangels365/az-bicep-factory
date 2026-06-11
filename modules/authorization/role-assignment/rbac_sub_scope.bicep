// modules/authorization/role-assingment/rbac_sub_scope.bicep
// RBAC Role Assignment at Subscription scope

targetScope = 'subscription'

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

var builtInRoleNames = {
  Owner: '8e3af657-a8ff-42a0-ab88-20f7382dd24c'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: 'acdd72a7-4e5e-48ef-bd42-f606fba81ae7'
  'Backup Contributor': '5e467623-bb1f-42f4-a55d-6e525e11384b'
  'Backup Operator': '00c29273-979b-4161-815c-10b084fb9324'
  'Backup Reader': 'a795c7a0-d4a2-40c1-ae25-d81f01202912'
  'Cost Management Contributor': '434105ed-43f6-45c7-a02f-909b2ba83430'
  'Cost Management Reader': '72fafb9e-0641-4937-9268-a91bfd8191a3'
  'Monitoring Contributor': '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  'Monitoring Reader': '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  'Monitoring Metrics Publisher': '3913510d-42f4-56c9-9e15-8e25fbd76d3e'
  'Network Contributor': '4d97b98b-1d4f-4787-a291-c67834d212e7'
  'Security Admin': 'fb1c8493-542b-48eb-b624-b4c8fea62acd'
  'Security Reader': '39bc4728-0917-49c7-9d2c-d95423bc2eb4'
  'User Access Administrator': '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
}

var roleDefinitionId = contains(builtInRoleNames, roleDefinitionIdOrName)
  ? subscriptionResourceId('Microsoft.Authorization/roleDefinitions', builtInRoleNames[roleDefinitionIdOrName])
  : (startsWith(roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
      ? roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionIdOrName))

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(principalId, roleDefinitionId, subscription().id)
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

@description('ID de l\'affectation de rôle.')
output roleAssignmentId string = roleAssignment.id

@description('Nom de l\'affectation de rôle (GUID).')
output roleAssignmentName string = roleAssignment.name

@description('ID du principal.')
output principalId string = roleAssignment.properties.principalId

@description('ID de la définition de rôle.')
output roleDefinitionId string = roleAssignment.properties.roleDefinitionId

@description('Scope effectif de l\'affectation de rôle.')
output scope string = subscription().id
