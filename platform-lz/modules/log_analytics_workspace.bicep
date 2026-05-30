// platform-lz/modules/log_analytics_workspace.bicep
// Log Analytics Workspace module for centralized logging

@description('Nom du workspace Log Analytics')
@minLength(4)
@maxLength(63)
param workspaceName string

@description('Emplacement du workspace. Valeurs possibles : cace (canadacentral), caea (canadaeast)')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('SKU du workspace')
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

@description('Rétention des données en jours (30-730)')
@minValue(30)
@maxValue(730)
param retentionInDays int = 90

@description('Limite quotidienne de données en GB (-1 pour illimité)')
@minValue(-1)
param dailyQuotaGb int = -1

@description('Activer l\'accès au réseau public pour l\'ingestion')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Activer l\'accès au réseau public pour les requêtes')
param publicNetworkAccessForQuery string = 'Enabled'

@description('Tags pour le workspace')
param tags object = {}

@description('Activer la solution Sentinel pour ce workspace')
param enableSentinel bool = false

@description('Solutions à déployer dans le workspace (ex: Security, AzureActivity, etc.)')
param solutions array = []

// Log Analytics Workspace Resource
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
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
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
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
    location: location == 'caea' ? 'canadaeast' : 'canadacentral'
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
@description('ID du workspace Log Analytics')
output workspaceId string = logAnalyticsWorkspace.id

@description('Nom du workspace Log Analytics')
output workspaceName string = logAnalyticsWorkspace.name

@description('ID du client du workspace Log Analytics')
output customerId string = logAnalyticsWorkspace.properties.customerId
