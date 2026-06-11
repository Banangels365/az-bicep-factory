// workload-lz/modules/storage/storage_table_service.bicep
// Ce module définit le service de table dans un compte de stockage Azure.
// Le service de table permet de stocker et de gérer les tables dans le compte de stockage, en configurant various politiques et options.

targetScope = 'resourceGroup'

param storageAccountName string
param service object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' existing = {
  name: storageAccountName
}

resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2025-06-01' = {
  name: 'default'
  parent: storageAccount
}

module tables './storage_table.bicep' = [
  for (table, i) in (service.?tables ?? []): {
    name: '${deployment().name}-table-${i}'
    params: {
      storageAccountName: storageAccount.name
      table: table
    }
  }
]

output name string = tableService.name
output resourceId string = tableService.id
