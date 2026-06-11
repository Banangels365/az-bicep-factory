// modules/authorization/role-assingment/rbac_mg_scope.bicep
// RBAC Role Assignment at Management Group scope

targetScope = 'managementGroup'

@description('ID du principal (utilisateur, groupe, service principal, managed identity ou groupe externe) auquel le rôle sera assigné.')
param principalId string

@description('ID du management group cible. Si vide, le scope courant du déploiement est utilisé.')
param managementGroupId string = managementGroup().name

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
  'Resource Policy Contributor': '36243c78-bf99-498c-9df9-86d9f8d28608'
  'Role Based Access Control Administrator': 'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  'User Access Administrator': '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  'Management Group Reader': 'ac63b705-f282-497d-ac71-919bf39d939d'
}

var roleDefinitionId = contains(builtInRoleNames, roleDefinitionIdOrName)
  ? managementGroupResourceId('Microsoft.Authorization/roleDefinitions', builtInRoleNames[roleDefinitionIdOrName])
  : (startsWith(roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
      ? roleDefinitionIdOrName
      : managementGroupResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionIdOrName))

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managementGroupId, roleDefinitionId, principalId)
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

@description('ID du principal auquel le rôle est assigné.')
output principalId string = roleAssignment.properties.principalId

@description('ID de la définition de rôle utilisée.')
output roleDefinitionId string = roleAssignment.properties.roleDefinitionId

@description('Scope effectif de l\'affectation de rôle.')
output scope string = tenantResourceId('Microsoft.Management/managementGroups', managementGroupId)
