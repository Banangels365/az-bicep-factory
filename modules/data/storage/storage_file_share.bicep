// workload-lz/modules/storage/storage_file_share.bicep
// Ce module définit un partage de fichiers dans un compte de stockage Azure.
// Le partage de fichiers permet de stocker et de gérer les fichiers dans le compte de stockage, en configurant various politiques et options.

targetScope = 'resourceGroup'

param storageAccountName string
param share object

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName

  resource fileService 'fileServices@2025-01-01' existing = {
    name: 'default'
  }
}

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2025-01-01' = {
  name: share.name
  parent: storageAccount::fileService
  properties: {
    accessTier: share.?accessTier
    shareQuota: share.?shareQuota ?? 5120
    enabledProtocols: share.?enabledProtocols ?? 'SMB'
    rootSquash: (share.?enabledProtocols ?? 'SMB') == 'NFS' ? (share.?rootSquash ?? 'NoRootSquash') : null
    provisionedBandwidthMibps: storageAccount.kind == 'FileStorage' ? share.?provisionedBandwidthMibps : null
    provisionedIops: storageAccount.kind == 'FileStorage' ? share.?provisionedIops : null
  }
}

// Conserver ce workaround pour Azure Files
module fileShareRoleAssignments './nested_inner_roleAssignment.json' = [
  for (roleAssignment, i) in (share.?roleAssignments ?? []): {
    name: '${uniqueString(deployment().name)}-file-share-rbac-${i}'
    params: {
      scope: replace(fileShare.id, '/shares/', '/fileshares/')
      name: roleAssignment.?name ?? guid(fileShare.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
      description: roleAssignment.?description
    }
  }
]

output name string = fileShare.name
output resourceId string = fileShare.id
