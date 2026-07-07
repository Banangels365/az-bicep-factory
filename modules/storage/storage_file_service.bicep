// modules/storage/storage_file_service.bicep
// Ce module définit le service de fichiers dans un compte de stockage Azure.
// Le service de fichiers permet de stocker et de gérer les partages de fichiers dans le compte de stockage, en configurant diverses politiques et options.

targetScope = 'resourceGroup'

param storageAccountName string
param service object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName
}

var defaultShareAccessTier = storageAccount.kind == 'FileStorage'
  ? (startsWith(storageAccount.sku.name, 'PremiumV2_') ? null : 'Premium')
  : 'TransactionOptimized'

resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2025-01-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    cors: !empty(service.?corsRules ?? [])
      ? {
          corsRules: service.corsRules
        }
      : null
    protocolSettings: service.?protocolSettings ?? {}
    shareDeleteRetentionPolicy: service.?shareDeleteRetentionPolicy ?? {
      enabled: true
      days: 7
    }
  }
}

module shares './storage_file_share.bicep' = [
  for (share, i) in (service.?shares ?? []): {
    name: '${deployment().name}-file-share-${i}'
    params: {
      storageAccountName: storageAccount.name
      share: union(share, {
        accessTier: share.?accessTier ?? defaultShareAccessTier
      })
    }
  }
]

output name string = fileService.name
output resourceId string = fileService.id
