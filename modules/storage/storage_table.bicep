// modules/storage/storage_table.bicep
// Ce module définit une table dans un compte de stockage Azure.
// La table permet de stocker et de gérer les données structurées dans le compte de stockage, en configurant various politiques et options.

targetScope = 'resourceGroup'

param storageAccountName string
param table object

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' existing = {
  name: storageAccountName

  resource tableService 'tableServices@2025-06-01' existing = {
    name: 'default'
  }
}

resource tableResource 'Microsoft.Storage/storageAccounts/tableServices/tables@2025-06-01' = {
  name: table.name
  parent: storageAccount::tableService
}

resource tableRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in (table.?roleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(tableResource.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    scope: tableResource
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      principalType: roleAssignment.?principalType
      description: roleAssignment.?description
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
  }
]

output name string = tableResource.name
output resourceId string = tableResource.id
