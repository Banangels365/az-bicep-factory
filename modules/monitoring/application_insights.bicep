// modules/monitoring/application_insights.bicep
// Module Application Insights pour la surveillance des applications

@description('Nom de l\'Application Insights')
param appInsightsName string

@description('Région de déploiement')
param location string = resourceGroup().location

@description('Type d\'application')
@allowed([
  'web'
  'other'
  'java'
  'Node.JS'
  'python'
])
param applicationType string = 'web'

@description('ID du Log Analytics Workspace')
param workspaceResourceId string

@description('Rétention des données en jours')
@minValue(30)
@maxValue(730)
param retentionInDays int = 90

@description('Désactiver l\'accès au réseau public pour l\'ingestion')
param disablePublicNetworkAccessForIngestion bool = false

@description('Désactiver l\'accès au réseau public pour la requête')
param disablePublicNetworkAccessForQuery bool = false

@description('Pourcentage d\'échantillonnage des données (0-100)')
@minValue(0)
@maxValue(100)
param samplingPercentage int = 100

@description('Tags à appliquer à Application Insights')
param tags object = {}

// Application Insights Resource
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: applicationType
  properties: {
    Application_Type: applicationType
    WorkspaceResourceId: workspaceResourceId
    RetentionInDays: retentionInDays
    SamplingPercentage: samplingPercentage
    publicNetworkAccessForIngestion: disablePublicNetworkAccessForIngestion ? 'Disabled' : 'Enabled'
    publicNetworkAccessForQuery: disablePublicNetworkAccessForQuery ? 'Disabled' : 'Enabled'
    DisableIpMasking: false
  }
}

// Outputs
@description('ID de l\'Application Insights')
output appInsightsId string = applicationInsights.id

@description('Nom de l\'Application Insights')
output appInsightsName string = applicationInsights.name

@description('Chaîne de connexion de l\'Application Insights (Privilégier ceci à la clé d\'instrumentation)')
output connectionString string = applicationInsights.properties.ConnectionString

@description('ID de l\'Application')
output applicationId string = applicationInsights.properties.AppId
