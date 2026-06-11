// connectivity-lz/modules/application_gateway.bicep
// Application Gateway module for Layer 7 load balancing

@description('Nom de l\'Application Gateway')
param applicationGatewayName string

@description('Région pour le Application Gateway')
param location string

@description('SKU du Application Gateway')
@allowed([
  'Standard_v2'
  'WAF_v2'
])
param skuName string = 'Standard_v2'

@description('Tier de l\'Application Gateway')
@allowed([
  'Standard_v2'
  'WAF_v2'
])
param tier string = 'Standard_v2'

@description('Capacité de l\'Application Gateway (pour les SKU Standard_v2, 1-125 unités)')
@minValue(1)
@maxValue(125)
param capacity int = 2

@description('Activer l\'autoscaling (pour les SKU Standard_v2)')
param enableAutoscaling bool = true

@description('Capacité minimale pour l\'autoscaling (pour les SKU Standard_v2, 0 ou 2-125 unités)')
@minValue(0)
@maxValue(100)
param minCapacity int = 2

@description('Capacité maximale pour l\'autoscaling (pour les SKU Standard_v2, 2-125 unités)')
@minValue(2)
@maxValue(125)
param maxCapacity int = 10

@description('ID du sous-réseau pour le Application Gateway (AzureSubnet)')
param subnetId string

@description('ID de ressource d\'adresse IP publique pour le Application Gateway')
param publicIpAddressId string

@description('Pools d\'adresses backend')
param backendAddressPools array

@description('Paramètres HTTP backend')
param backendHttpSettingsCollection array

@description('Ecouteurs HTTP')
param httpListeners array

@description('Règles de routage des requêtes')
param requestRoutingRules array

@description('Ports frontend')
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

@description('Certificats SSL (pour les règles HTTPS)')
param sslCertificates array = []

@description('Configuration du Web Application Firewall (WAF) pour le SKU WAF_v2')
param wafConfiguration object = {}

@description('Availability zones')
param zones array = []

@description('Tags à appliquer au Application Gateway')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// Application Gateway Resource
resource applicationGateway 'Microsoft.Network/applicationGateways@2023-09-01' = {
  name: applicationGatewayName
  location: resolvedLocation
  tags: tags
  zones: !empty(zones) ? zones : null
  properties: {
    sku: union(
      {
        name: skuName
        tier: tier
      },
      !enableAutoscaling ? { capacity: capacity } : {} // propriété omise si autoscaling actif
    )
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
    logs: concat(
      [
        {
          category: 'ApplicationGatewayAccessLog'
          enabled: true
        }
        {
          category: 'ApplicationGatewayPerformanceLog'
          enabled: true
        }
      ],
      tier == 'WAF_v2'
        ? [
            {
              category: 'ApplicationGatewayFirewallLog'
              enabled: true
            }
          ]
        : []
    )
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// Outputs
@description('ID du Application Gateway')
output applicationGatewayId string = applicationGateway.id

@description('Nom du Application Gateway')
output applicationGatewayName string = applicationGateway.name

@description('IDs des pools d\'adresses backend')
output backendAddressPoolIds array = [
  for (pool, i) in backendAddressPools: '${applicationGateway.id}/backendAddressPools/${pool.name}'
]
