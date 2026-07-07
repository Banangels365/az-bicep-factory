// modules/storage/storage_queue.bicep
// Ce module définit une file d'attente dans un compte de stockage Azure.
// La file d'attente permet de stocker et de gérer les messages dans le compte de stockage, en configurant various politiques et options.

targetScope = 'resourceGroup'

param storageAccountName string
param queue object

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' existing = {
  name: storageAccountName

  resource queueService 'queueServices@2025-06-01' existing = {
    name: 'default'
  }
}

resource queueResource 'Microsoft.Storage/storageAccounts/queueServices/queues@2025-06-01' = {
  name: queue.name
  parent: storageAccount::queueService
  properties: {
    metadata: queue.?metadata ?? {}
  }
}

resource queueRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in (queue.?roleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(queueResource.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    scope: queueResource
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

output name string = queueResource.name
output resourceId string = queueResource.id
