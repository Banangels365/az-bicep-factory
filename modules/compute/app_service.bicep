// modules/compute/app_service.bicep
// App Service (Web App) module avec support pour Private Endpoint

@description('Nom du Plan App Service')
param appServicePlanName string

@description('Nom de l\'App Service')
param appServiceName string

@description('Région de déploiement')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('SKU du Plan App Service')
@allowed([
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1v2'
  'P2v2'
  'P3v2'
  'P1v3'
  'P2v3'
  'P3v3'
])
param skuName string = 'P1v3'

@description('Capacité du Plan App Service (nombre d\'instances)')
@minValue(1)
@maxValue(30)
param skuCapacity int = 1

@description('Stack d\'exécution (runtime)')
@allowed([
  'dotnet'
  'dotnetcore'
  'node'
  'python'
  'java'
  'php'
])
param runtimeStack string = 'dotnet'

@description('Version du runtime')
param runtimeVersion string = '8'

@description('Activer Always On (maintenir l\'application active en permanence)')
param alwaysOn bool = true

@description('Forcer HTTPS uniquement')
param httpsOnly bool = true

@description('Version TLS minimale')
@allowed([
  '1.0'
  '1.1'
  '1.2'
])
param minTlsVersion string = '1.2'

@description('Autoriser l\'accès réseau public')
param publicNetworkAccess bool = false

@description('Activer l\'intégration VNet (trafic sortant)')
param enableVNetIntegration bool = true

@description('ID du sous-réseau pour l\'intégration VNet (sortant)')
param vnetIntegrationSubnetId string = ''

@description('Activer le Private Endpoint (trafic entrant)')
param enablePrivateEndpoint bool = true

@description('ID du sous-réseau pour le Private Endpoint')
param privateEndpointSubnetId string = ''

@description('ID de la zone DNS privée pour les App Services (privatelink.azurewebsites.net)')
param privateDnsZoneIdSites string = ''

@description('Clé d\'instrumentation Application Insights')
param appInsightsInstrumentationKey string = ''

@description('Chaîne de connexion Application Insights')
param appInsightsConnectionString string = ''

@description('ID de la Managed Identity à assigner à l\'App Service')
param managedIdentityId string = ''

@description('Paramètres applicatifs personnalisés (app settings)')
param appSettings object = {}

@description('Chaînes de connexion de l\'application')
param connectionStrings array = []

@description('Tags à appliquer aux ressources')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

// Variables
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

var linuxFxVersion = runtimeStack == 'dotnet'
  ? 'DOTNET|${runtimeVersion}'
  : runtimeStack == 'dotnetcore'
      ? 'DOTNETCORE|${runtimeVersion}'
      : runtimeStack == 'node'
          ? 'NODE|${runtimeVersion}'
          : runtimeStack == 'python'
              ? 'PYTHON|${runtimeVersion}'
              : runtimeStack == 'java' ? 'JAVA|${runtimeVersion}' : runtimeStack == 'php' ? 'PHP|${runtimeVersion}' : ''

var baseAppSettings = [
  {
    name: 'WEBSITE_RUN_FROM_PACKAGE'
    value: '1'
  }
]

var appInsightsSettings = !empty(appInsightsInstrumentationKey)
  ? [
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: appInsightsInstrumentationKey
      }
      {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: appInsightsConnectionString
      }
      {
        name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
        value: '~3'
      }
    ]
  : []

var customAppSettings = [
  for setting in items(appSettings): {
    name: setting.key
    value: setting.value
  }
]

var allAppSettings = concat(baseAppSettings, appInsightsSettings, customAppSettings)

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: resolvedLocation
  tags: tags
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// App Service
resource appService 'Microsoft.Web/sites@2023-01-01' = {
  name: appServiceName
  location: resolvedLocation
  tags: tags
  kind: 'app,linux'
  identity: !empty(managedIdentityId)
    ? {
        type: 'UserAssigned'
        userAssignedIdentities: {
          '${managedIdentityId}': {}
        }
      }
    : {
        type: 'SystemAssigned'
      }
  properties: union(
    {
      serverFarmId: appServicePlan.id
      httpsOnly: httpsOnly
      publicNetworkAccess: publicNetworkAccess ? 'Enabled' : 'Disabled'
      siteConfig: {
        linuxFxVersion: linuxFxVersion
        alwaysOn: alwaysOn
        minTlsVersion: minTlsVersion
        ftpsState: 'Disabled'
        http20Enabled: true
        healthCheckPath: '/health'
        appSettings: allAppSettings
        connectionStrings: connectionStrings
      }
    },
    enableVNetIntegration && !empty(vnetIntegrationSubnetId) ? { virtualNetworkSubnetId: vnetIntegrationSubnetId } : {}
  )
}

// Private Endpoint for App Service
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(privateDnsZoneIdSites)) {
  name: '${appServiceName}-pe'
  location: resolvedLocation
  tags: tags
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${appServiceName}-pe-connection'
        properties: {
          privateLinkServiceId: appService.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}

// Private DNS Zone Group
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(privateDnsZoneIdSites)) {
  parent: privateEndpoint
  name: 'sites-dns-zone-group'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'sites-config'
        properties: {
          privateDnsZoneId: privateDnsZoneIdSites
        }
      }
    ]
  }
}

// Diagnostic Settings for App Service
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: appService
  name: '${appServiceName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// Outputs
@description('ID du Plan App Service')
output appServicePlanId string = appServicePlan.id

@description('Nom du Plan App Service')
output appServicePlanName string = appServicePlan.name

@description('ID de l\'App Service')
output appServiceId string = appService.id

@description('Nom de l\'App Service')
output appServiceName string = appService.name

@description('Nom d\'hôte par défaut de l\'App Service')
output appServiceDefaultHostname string = appService.properties.defaultHostName

@description('ID de l\'identité gérée (Managed Identity) de l\'App Service')
output principalId string = !empty(managedIdentityId) ? '' : appService.identity.principalId

@description('Private Endpoint ID')
output privateEndpointId string = (enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(privateDnsZoneIdSites))
  ? privateEndpoint.id
  : ''

@description('Adresse IP du Private Endpoint')
output privateEndpointIpAddress string = (enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(privateDnsZoneIdSites))
  ? privateEndpoint.?properties.customDnsConfigs[0].?ipAddresses[0] ?? ''
  : ''
