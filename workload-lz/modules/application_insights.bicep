// modules/monitoring/application-insights/main.bicep
// Application Insights module for application monitoring

@description('Application Insights name')
param appInsightsName string

@description('Location for Application Insights')
param location string = resourceGroup().location

@description('Application type')
@allowed([
  'web'
  'other'
  'java'
  'Node.JS'
  'python'
])
param applicationType string = 'web'

@description('Log Analytics Workspace ID')
param workspaceResourceId string

@description('Retention in days')
@minValue(30)
@maxValue(730)
param retentionInDays int = 90

@description('Disable public network access for ingestion')
param disablePublicNetworkAccessForIngestion bool = false

@description('Disable public network access for query')
param disablePublicNetworkAccessForQuery bool = false

@description('Sampling percentage')
@minValue(0)
@maxValue(100)
param samplingPercentage int = 100

@description('Tags to apply to Application Insights')
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
@description('Application Insights resource ID')
output appInsightsId string = applicationInsights.id

@description('Application Insights name')
output appInsightsName string = applicationInsights.name

@description('Application Insights instrumentation key')
output instrumentationKey string = applicationInsights.properties.InstrumentationKey

@description('Application Insights connection string')
output connectionString string = applicationInsights.properties.ConnectionString

@description('Application ID')
output applicationId string = applicationInsights.properties.AppId