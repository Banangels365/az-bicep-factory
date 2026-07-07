// modules/storage/storage_queue_service.bicep
// Ce module définit le service de files d'attente pour un compte de stockage Azure.
// Le service de files d'attente permet de gérer les files d'attente dans le compte de stockage, en configurant various politiques et options.

targetScope = 'resourceGroup'

param storageAccountName string
param service object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' existing = {
  name: storageAccountName
}

resource queueService 'Microsoft.Storage/storageAccounts/queueServices@2025-06-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    cors: !empty(service.?corsRules ?? [])
      ? {
          corsRules: service.corsRules
        }
      : null
  }
}

module queues './storage_queue.bicep' = [
  for (queue, i) in (service.?queues ?? []): {
    name: '${deployment().name}-queue-${i}'
    params: {
      storageAccountName: storageAccount.name
      queue: queue
    }
  }
]

output name string = queueService.name
output resourceId string = queueService.id
