// workload-lz/modules/storage/storage_blob_container_immutability_policy.bicep
// Ce module définit la politique d'immuabilité pour un conteneur de blob dans un compte de stockage Azure. 
// La politique d'immuabilité permet de protéger les données contre la suppression ou la modification pendant une période spécifiée, assurant ainsi la conformité et la sécurité des données sensibles. 
// Les paramètres de la politique incluent la durée de l'immuabilité, ainsi que les options pour autoriser ou interdire les écritures protégées en mode append. 

targetScope = 'resourceGroup'

param storageAccountName string
param containerName string
param policy object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName

  resource blobServices 'blobServices@2025-01-01' existing = {
    name: 'default'

    resource container 'containers@2025-01-01' existing = {
      name: containerName
    }
  }
}

resource immutabilityPolicy 'Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2025-01-01' = {
  name: 'default'
  parent: storageAccount::blobServices::container
  properties: {
    immutabilityPeriodSinceCreationInDays: policy.?immutabilityPeriodSinceCreationInDays ?? 365
    allowProtectedAppendWrites: policy.?allowProtectedAppendWrites ?? false
    allowProtectedAppendWritesAll: policy.?allowProtectedAppendWritesAll ?? false
  }
}

output name string = immutabilityPolicy.name
output resourceId string = immutabilityPolicy.id
