// modules/storage/storage_blob_service.bicep
// Ce module définit le service blob pour un compte de stockage Azure. 
// Le service blob permet de gérer les conteneurs et les blobs dans le compte de stockage, en configurant various politiques et options.

targetScope = 'resourceGroup'

param storageAccountName string
param service object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    automaticSnapshotPolicyEnabled: service.?automaticSnapshotPolicyEnabled ?? false
    changeFeed: {
      enabled: service.?changeFeedEnabled ?? false
      retentionInDays: service.?changeFeedRetentionInDays
    }
    containerDeleteRetentionPolicy: {
      enabled: service.?containerDeleteRetentionPolicyEnabled ?? true
      days: service.?containerDeleteRetentionPolicyDays
      allowPermanentDelete: service.?containerDeleteRetentionPolicyAllowPermanentDelete ?? false
    }
    cors: !empty(service.?corsRules ?? [])
      ? {
          corsRules: service.corsRules
        }
      : null
    defaultServiceVersion: service.?defaultServiceVersion
    deleteRetentionPolicy: {
      enabled: service.?deleteRetentionPolicyEnabled ?? true
      days: service.?deleteRetentionPolicyDays ?? 7
      allowPermanentDelete: service.?deleteRetentionPolicyAllowPermanentDelete ?? false
    }
    isVersioningEnabled: service.?isVersioningEnabled ?? false
    lastAccessTimeTrackingPolicy: {
      enable: service.?lastAccessTimeTrackingPolicyEnabled ?? false
    }
    restorePolicy: (service.?restorePolicyEnabled ?? false)
      ? {
          enabled: true
          days: service.?restorePolicyDays ?? 7
        }
      : null
  }
}

module containers './storage_blob_container.bicep' = [
  for (container, i) in (service.?containers ?? []): {
    name: '${deployment().name}-blob-container-${i}'
    params: {
      storageAccountName: storageAccount.name
      container: container
    }
  }
]

output name string = blobService.name
output resourceId string = blobService.id
