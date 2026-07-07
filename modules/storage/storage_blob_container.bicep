// modules/storage/storage_blob_container.bicep
// Ce module définit un conteneur de blob dans un compte de stockage Azure. 
// Le conteneur de blob permet de stocker et de gérer les blobs dans le compte de stockage, en configurant various politiques et options.

targetScope = 'resourceGroup'

param storageAccountName string
param container object

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName

  resource blobService 'blobServices@2025-01-01' existing = {
    name: 'default'
  }
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' = {
  name: container.name
  parent: storageAccount::blobService
  properties: {
    defaultEncryptionScope: container.?defaultEncryptionScope
    denyEncryptionScopeOverride: container.?denyEncryptionScopeOverride
    enableNfsV3AllSquash: container.?enableNfsV3AllSquash ?? false
    enableNfsV3RootSquash: container.?enableNfsV3RootSquash ?? false
    immutableStorageWithVersioning: {
      enabled: container.?immutableStorageWithVersioningEnabled ?? false
    }
    metadata: container.?metadata ?? {}
    publicAccess: container.?publicAccess ?? 'None'
  }
}

resource containerRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in (container.?roleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(blobContainer.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    scope: blobContainer
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

module immutability './storage_blob_container_immutability_policy.bicep' = if (container.?immutabilityPolicy != null) {
  name: '${deployment().name}-immutability-${container.name}'
  params: {
    storageAccountName: storageAccount.name
    containerName: blobContainer.name
    policy: container.immutabilityPolicy
  }
}

output name string = blobContainer.name
output resourceId string = blobContainer.id
