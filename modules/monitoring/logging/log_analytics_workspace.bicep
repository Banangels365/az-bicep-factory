// modules/monitoring/logging/log_analytics_workspace.bicep
// Déploie un workspace Log Analytics et, en option, Sentinel et d'autres solutions OMS.

targetScope = 'resourceGroup'

@description('Nom du workspace Log Analytics.')
@minLength(4)
@maxLength(63)
param workspaceName string

@description('Région de déploiement. Par défaut, la région du resource group.')
param location string = resourceGroup().location

@description('SKU du workspace.')
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

@description('Durée de rétention des données en jours.')
@minValue(30)
@maxValue(730)
param retentionInDays int = 90

@description('Quota journalier en Go. Utiliser -1 pour illimité.')
@minValue(-1)
param dailyQuotaGb int = -1

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

@description('Active l\'usage des permissions Azure RBAC sur les ressources plutôt que les permissions workspace héritées.')
param enableLogAccessUsingOnlyResourcePermissions bool = true

@description('Tags à appliquer au workspace.')
param tags object = {}

@description('Déploie Microsoft Sentinel sur ce workspace.')
param enableSentinel bool = false

@description('Liste additionnelle de solutions OMS à déployer, par exemple AzureActivity ou Security.')
param solutions array = []

// Création des ressources

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
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
      enableLogAccessUsingOnlyResourcePermissions: enableLogAccessUsingOnlyResourcePermissions
    }
  }
}

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
    workspaceResourceId: workspace.id
  }
}

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
      workspaceResourceId: workspace.id
    }
  }
]

// Outputs

@description('ID du workspace Log Analytics créé.')
output workspaceId string = workspace.id

@description('Nom du workspace Log Analytics créé.')
output workspaceName string = workspace.name

@description('Customer ID du workspace Log Analytics.')
output customerId string = workspace.properties.customerId

@description('Localisation du workspace Log Analytics.')
output location string = workspace.location
