// modules/monitoring/logging/application_insights.bicep
// Déploie une ressource Application Insights workspace-based.
// Le linked storage account est intégré directement dans ce module afin d'éviter un fichier annexe supplémentaire.

targetScope = 'resourceGroup'

@description('Nom de la ressource Application Insights.')
param name string

@description('Région de déploiement. Par défaut, la région du resource group.')
param location string = resourceGroup().location

@description('Type applicatif principal.')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'

@description('ID du workspace Log Analytics auquel Application Insights sera rattaché.')
param workspaceResourceId string

@description('Kind libre pour personnaliser le comportement ou l\'affichage côté portail. Exemples courants : web, ios, other, java.')
param kind string = 'web'

@description('Désactive le masquage des IP. True signifie que le masquage est désactivé.')
param disableIpMasking bool = true

@description('Désactive l\'authentification locale non AAD.')
param disableLocalAuth bool = false

@description('Force l\'utilisation d\'un compte de stockage client pour Profiler et Debugger.')
param forceCustomerStorageForProfiler bool = false

@description('ID du compte de stockage à lier à Application Insights pour Service Profiler. Laisser vide si non utilisé.')
param linkedStorageAccountResourceId string = ''

@description('Accès réseau public pour l\'ingestion.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Accès réseau public pour les requêtes.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

@description('Rétention des données en jours.')
@allowed([
  30
  60
  90
  120
  180
  270
  365
  550
  730
])
param retentionInDays int = 365

@description('Pourcentage d\'échantillonnage de la télémétrie.')
@minValue(0)
@maxValue(100)
param samplingPercentage int = 100

@description('Flow type utilisé par le service. Laisser vide dans la plupart des cas.')
param flowType string = ''

@description('Request source utilisé par le service. Laisser vide dans la plupart des cas.')
param requestSource string = ''

@description('Mode d\'ingestion. Laisser vide pour le comportement par défaut.')
param ingestionMode string = ''

@description('Supprime immédiatement les données à 30 jours lorsque supporté.')
param immediatePurgeDataOn30Days bool?

@description('Tags à appliquer à la ressource.')
param tags object = {}

// Création des ressources

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: kind
  tags: tags
  properties: {
    Application_Type: applicationType
    WorkspaceResourceId: workspaceResourceId
    DisableIpMasking: disableIpMasking
    DisableLocalAuth: disableLocalAuth
    ForceCustomerStorageForProfiler: forceCustomerStorageForProfiler
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    RetentionInDays: retentionInDays
    SamplingPercentage: samplingPercentage
    Flow_Type: !empty(flowType) ? flowType : null
    Request_Source: !empty(requestSource) ? requestSource : null
    ImmediatePurgeDataOn30Days: immediatePurgeDataOn30Days
    IngestionMode: !empty(ingestionMode) ? ingestionMode : null
  }
}

resource linkedStorageAccount 'Microsoft.Insights/components/linkedStorageAccounts@2020-03-01-preview' = if (!empty(linkedStorageAccountResourceId)) {
  name: 'ServiceProfiler'
  parent: appInsights
  properties: {
    linkedStorageAccount: linkedStorageAccountResourceId
  }
}

// Outputs

@description('Nom de la ressource Application Insights créée.')
output name string = appInsights.name

@description('ID de la ressource Application Insights créée.')
output resourceId string = appInsights.id

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name

@description('Application ID généré par Application Insights.')
output applicationId string = appInsights.properties.AppId

@description('Instrumentation Key générée par Application Insights.')
output instrumentationKey string = appInsights.properties.InstrumentationKey

@description('Connection string générée par Application Insights.')
output connectionString string = appInsights.properties.ConnectionString

@description('Localisation d\'Application Insights.')
output location string = appInsights.location
