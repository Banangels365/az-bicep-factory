// connectivity-lz/modules/application_gateway.bicep
// Application Gateway module for Layer 7 load balancing

@description('Application Gateway name')
param applicationGatewayName string

@description('Location for the application gateway')
param location string = resourceGroup().location

@description('Application Gateway SKU')
@allowed([
  'Standard_v2'
  'WAF_v2'
])
param skuName string = 'Standard_v2'

@description('Application Gateway tier')
@allowed([
  'Standard_v2'
  'WAF_v2'
])
param tier string = 'Standard_v2'

@description('Capacity (instance count)')
@minValue(1)
@maxValue(125)
param capacity int = 2

@description('Enable autoscaling')
param enableAutoscaling bool = true

@description('Minimum autoscale capacity')
@minValue(0)
@maxValue(100)
param minCapacity int = 2

@description('Maximum autoscale capacity')
@minValue(2)
@maxValue(125)
param maxCapacity int = 10

@description('Subnet ID for the application gateway')
param subnetId string

@description('Public IP Address resource ID')
param publicIpAddressId string

@description('Backend address pools')
param backendAddressPools array

@description('Backend HTTP settings')
param backendHttpSettingsCollection array

@description('HTTP listeners')
param httpListeners array

@description('Request routing rules')
param requestRoutingRules array

@description('Frontend ports')
param frontendPorts array = [
  {
    name: 'port_80'
    port: 80
  }
  {
    name: 'port_443'
    port: 443
  }
]

@description('SSL certificates')
param sslCertificates array = []

@description('WAF configuration (for WAF_v2 SKU)')
param wafConfiguration object = {}

@description('Availability zones')
param zones array = []

@description('Tags to apply to the application gateway')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID for diagnostics')
param logAnalyticsWorkspaceId string = ''

// Application Gateway Resource
resource applicationGateway 'Microsoft.Network/applicationGateways@2023-09-01' = {
  name: applicationGatewayName
  location: location
  tags: tags
  zones: !empty(zones) ? zones : null
  properties: {
    sku: {
      name: skuName
      tier: tier
      capacity: enableAutoscaling ? null : capacity
    }
    autoscaleConfiguration: enableAutoscaling
      ? {
          minCapacity: minCapacity
          maxCapacity: maxCapacity
        }
      : null
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          publicIPAddress: {
            id: publicIpAddressId
          }
        }
      }
    ]
    frontendPorts: frontendPorts
    backendAddressPools: backendAddressPools
    backendHttpSettingsCollection: backendHttpSettingsCollection
    httpListeners: httpListeners
    requestRoutingRules: requestRoutingRules
    sslCertificates: sslCertificates
    webApplicationFirewallConfiguration: tier == 'WAF_v2' && !empty(wafConfiguration) ? wafConfiguration : null
    enableHttp2: true
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: applicationGateway
  name: '${applicationGatewayName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'ApplicationGatewayAccessLog'
        enabled: true
      }
      {
        category: 'ApplicationGatewayPerformanceLog'
        enabled: true
      }
      {
        category: 'ApplicationGatewayFirewallLog'
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
@description('Application Gateway resource ID')
output applicationGatewayId string = applicationGateway.id

@description('Application Gateway name')
output applicationGatewayName string = applicationGateway.name

@description('Backend address pool IDs')
output backendAddressPoolIds array = [
  for (pool, i) in backendAddressPools: '${applicationGateway.id}/backendAddressPools/${pool.name}'
]
