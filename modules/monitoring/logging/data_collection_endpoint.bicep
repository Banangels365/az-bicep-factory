// modules/monitoring/logging/data_collection_endpoint.bicep
// Déploie un Data Collection Endpoint (DCE) utilisé notamment par Azure Monitor Agent.

targetScope = 'resourceGroup'

@description('Nom du Data Collection Endpoint.')
param name string

@description('Description du Data Collection Endpoint.')
param dataCollectionEndpointDescription string = ''

@description('Type du Data Collection Endpoint.')
@allowed([
  'Linux'
  'Windows'
])
param kind string = 'Linux'

@description('Région de déploiement. Par défaut, la région du resource group.')
param location string = resourceGroup().location

@description('Contrôle l\'accès réseau public aux endpoints.')
@allowed([
  'Enabled'
  'Disabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = 'Disabled'

@description('Tags à appliquer à la ressource.')
param tags object = {}

@description('Paramètres de verrouillage de la ressource.')
param lock object = {}

// Création des ressources

resource dataCollectionEndpoint 'Microsoft.Insights/dataCollectionEndpoints@2023-03-11' = {
  name: name
  location: location
  kind: kind
  tags: tags
  properties: {
    description: !empty(dataCollectionEndpointDescription) ? dataCollectionEndpointDescription : null
    networkAcls: {
      publicNetworkAccess: publicNetworkAccess
    }
  }
}

resource dataCollectionEndpointLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock) && lock.?kind != 'None') {
  name: lock.?name ?? '${name}-lock'
  scope: dataCollectionEndpoint
  properties: {
    level: lock.kind
    notes: lock.?notes ?? (lock.kind == 'CanNotDelete'
      ? 'Cannot delete the resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

// Outputs

@description('Nom du Data Collection Endpoint créé.')
output name string = dataCollectionEndpoint.name

@description('ID du Data Collection Endpoint créé.')
output resourceId string = dataCollectionEndpoint.id

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name

@description('Localisation du Data Collection Endpoint.')
output location string = dataCollectionEndpoint.location
