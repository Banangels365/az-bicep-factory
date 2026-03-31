// identity-lz/modules/custom_role_definition.bicep
// Custom RBAC Role Definition module

targetScope = 'subscription'

@description('Custom role name')
param roleName string

@description('Description of the custom role')
param description string

@description('Actions allowed by this role')
param actions array

@description('Actions not allowed by this role')
param notActions array = []

@description('Data actions allowed by this role')
param dataActions array = []

@description('Data actions not allowed by this role')
param notDataActions array = []

@description('Assignable scopes for this role')
param assignableScopes array = [
  subscription().id
]

// Custom Role Definition Resource
resource customRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(subscription().id, roleName)
  properties: {
    roleName: roleName
    description: description
    type: 'CustomRole'
    permissions: [
      {
        actions: actions
        notActions: notActions
        dataActions: dataActions
        notDataActions: notDataActions
      }
    ]
    assignableScopes: assignableScopes
  }
}

// Outputs
@description('Custom role definition ID')
output roleDefinitionId string = customRole.id

@description('Custom role definition name (GUID)')
output roleDefinitionName string = customRole.name

@description('Custom role display name')
output roleName string = customRole.properties.roleName
