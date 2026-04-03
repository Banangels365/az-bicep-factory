// modules/compute/app-service/main.bicep
// App Service (Web App) module with Private Endpoint support

@description('App Service Plan name')
param appServicePlanName string

@description('App Service name')
param appServiceName string

@description('Location for the resources')
param location string = resourceGroup().location

@description('App Service Plan SKU')
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

@description('App Service Plan capacity (instance count)')
@minValue(1)
@maxValue(30)
param skuCapacity int = 1

@description('Runtime stack')
@allowed([
  'dotnet'
  'dotnetcore'
  'node'
  'python'
  'java'
  'php'
])
param runtimeStack string = 'dotnet'

@description('Runtime version')
param runtimeVersion string = '8'

@description('Enable Always On')
param alwaysOn bool = true

@description('Enable HTTPS only')
param httpsOnly bool = true

@description('Minimum TLS version')
@allowed([
  '1.0'
  '1.1'
  '1.2'
])
param minTlsVersion string = '1.2'

@description('Enable public network access')
param publicNetworkAccess bool = false

@description('Enable VNet integration')
param enableVNetIntegration bool = true

@description('Subnet ID for VNet integration (outbound)')
param vnetIntegrationSubnetId string = ''

@description('Enable Private Endpoint')
param enablePrivateEndpoint bool = true

@description('Subnet ID for Private Endpoint')
param privateEndpointSubnetId string = ''

@description('Private DNS Zone ID for sites')
param privateDnsZoneIdSites string = ''

@description('Application Insights instrumentation key')
param appInsightsInstrumentationKey string = ''

@description('Application Insights connection string')
param appInsightsConnectionString string = ''

@description('Managed Identity ID to assign to App Service')
param managedIdentityId string = ''

@description('Key Vault reference for app settings')
param keyVaultName string = ''

@description('Custom app settings')
param appSettings object = {}

@description('Connection strings')
param connectionStrings array = []

@description('Tags to apply to resources')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID')
param logAnalyticsWorkspaceId string = ''

// Variables
var linuxFxVersion = runtimeStack == 'dotnetcore' ? 'DOTNETCORE|${runtimeVersion}' : 
                     runtimeStack == 'node' ? 'NODE|${runtimeVersion}' :
                     runtimeStack == 'python' ? 'PYTHON|${runtimeVersion}' :
                     runtimeStack == 'java' ? 'JAVA|${runtimeVersion}' : ''

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
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
  location: location
  tags: tags
  kind: 'app,linux'
  identity: !empty(managedIdentityId) ? {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  } : {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: httpsOnly
    publicNetworkAccess: publicNetworkAccess ? 'Enabled' : 'Disabled'
    virtualNetworkSubnetId: enableVNetIntegration ? vnetIntegrationSubnetId : null
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      alwaysOn: alwaysOn
      minTlsVersion: minTlsVersion
      ftpsState: 'Disabled'
      http20Enabled: true
      healthCheckPath: '/health'
      appSettings: union(
        [
          {
            name: 'WEBSITE_RUN_FROM_PACKAGE'
            value: '1'
          }
        ],
        !empty(appInsightsInstrumentationKey) ? [
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
        ] : [],
        [for setting in items(appSettings): {
          name: setting.key
          value: setting.value
        }]
      )
      connectionStrings: connectionStrings
    }
  }
}

// Private Endpoint for App Service
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId)) {
  name: '${appServiceName}-pe'
  location: location
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
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = if (enablePrivateEndpoint && !empty(privateDnsZoneIdSites)) {
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
        category: 'AppServiceHTTPLogs'
        enabled: true
      }
      {
        category: 'AppServiceConsoleLogs'
        enabled: true
      }
      {
        category: 'AppServiceAppLogs'
        enabled: true
      }
      {
        category: 'AppServiceAuditLogs'
        enabled: true
      }
      {
        category: 'AppServiceIPSecAuditLogs'
        enabled: true
      }
      {
        category: 'AppServicePlatformLogs'
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
@description('App Service Plan resource ID')
output appServicePlanId string = appServicePlan.id

@description('App Service Plan name')
output appServicePlanName string = appServicePlan.name

@description('App Service resource ID')
output appServiceId string = appService.id

@description('App Service name')
output appServiceName string = appService.name

@description('App Service default hostname')
output appServiceDefaultHostname string = appService.properties.defaultHostName

@description('App Service principal ID (System-Assigned MI)')
output principalId string = !empty(managedIdentityId) ? '' : appService.identity.principalId

@description('Private Endpoint ID')
output privateEndpointId string = enablePrivateEndpoint ? privateEndpoint.id : ''

@description('Private Endpoint private IP address')
output privateEndpointIpAddress string = enablePrivateEndpoint ? privateEndpoint.properties.customDnsConfigs[0].ipAddresses[0] : ''