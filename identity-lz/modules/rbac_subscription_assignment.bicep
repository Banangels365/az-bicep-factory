// identity-lz/modules/rbac_subscription_assignment.bicep
// RBAC Role Assignment at Subscription scope

targetScope = 'subscription'

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

// Built-in role definitions mapping
var builtInRoleNames = {
  Owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'User Access Administrator': '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  'Security Admin': 'fb1c8493-542b-48eb-b624-b4c8fea62acd'
  'Security Reader': '39bc4728-0917-49c7-9d2c-d95423bc2eb4'
  'Monitoring Contributor': '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  'Network Contributor': '4d97b98b-1d4f-4787-a291-c67834d212e7'
  'Cost Management Contributor': '434105ed-43f6-45c7-a02f-909b2ba83430'
  'Cost Management Reader': '72fafb9e-0641-4937-9268-a91bfd8191a3'
}

// Determine if role is built-in or custom
var roleDefinitionId = contains(builtInRoleNames, roleDefinitionIdOrName)
  ? subscriptionResourceId('Microsoft.Authorization/roleDefinitions', builtInRoleNames[roleDefinitionIdOrName])
  : (startsWith(roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
      ? roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionIdOrName))

// Role Assignment Resource
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(principalId, roleDefinitionId, subscription().id)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: principalType
    description: !empty(roleAssignmentDescription) ? roleAssignmentDescription : null
    condition: !empty(condition) ? condition : null
    conditionVersion: !empty(condition) ? conditionVersion : null
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
