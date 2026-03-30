// platform-lz/log-analytics-workspace/main.bicep
// Log Analytics Workspace module for centralized logging

@description('Log Analytics Workspace name')
@minLength(4)
@maxLength(63)
param workspaceName string

@description('Location for the workspace')
param location string = resourceGroup().location

@description('Workspace SKU')
@allowed([
  'Free'
  'Standard'
  'Premium'
  'PerNode'
  'PerGB2018'
  'Standalone'
  'CapacityReservation'
])
param sku string = 'PerGB2018'

@description('Data retention in days (30-730 days)')
@minValue(30)
@maxValue(730)
param retentionInDays int = 90

@description('Daily ingestion limit in GB (0 means no limit)')
@minValue(0)
param dailyQuotaGb int = 0

@description('Enable public network access')
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Enable public network access for query')
param publicNetworkAccessForQuery string = 'Enabled'

@description('Tags to apply to the workspace')
param tags object = {}

@description('Enable Sentinel on this workspace')
param enableSentinel bool = false

@description('Solutions to deploy (e.g., SecurityInsights, Updates, ChangeTracking)')
param solutions array = []

// Log Analytics Workspace Resource
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: retentionInDays
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

// Sentinel Solution (if enabled)
resource sentinelSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = if (enableSentinel) {
  name: 'SecurityInsights(${workspaceName})'
  location: location
  tags: tags
  plan: {
    name: 'SecurityInsights(${workspaceName})'
    publisher: 'Microsoft'
    product: 'OMSGallery/SecurityInsights'
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
}

// Additional Solutions
resource additionalSolutions 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [
  for solution in solutions: {
    name: '${solution}(${workspaceName})'
    location: location
    tags: tags
    plan: {
      name: '${solution}(${workspaceName})'
      publisher: 'Microsoft'
      product: 'OMSGallery/${solution}'
      promotionCode: ''
    }
    properties: {
      workspaceResourceId: logAnalyticsWorkspace.id
    }
  }
]

// Outputs
@description('Log Analytics Workspace resource ID')
output workspaceId string = logAnalyticsWorkspace.id

@description('Log Analytics Workspace name')
output workspaceName string = logAnalyticsWorkspace.name

@description('Log Analytics Workspace customer ID')
output customerId string = logAnalyticsWorkspace.properties.customerId
