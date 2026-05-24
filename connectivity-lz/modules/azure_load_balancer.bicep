// connectivity-lz/modules/azure_load_balancer.bicep
// Azure Load Balancer module with frontend and backend configuration

@description('Nom du Load Balancer')
param loadBalancerName string

@description('Région pour le load balancer')
param location string

@description('SKU du Load Balancer')
@allowed([
  'Basic'
  'Standard'
  'Gateway'
])
param sku string = 'Standard'

@description('Type de Load Balancer (Public ou Internal)')
@allowed([
  'Public'
  'Internal'
])
param type string = 'Public'

@description('ID de ressource d\'adresse IP publique pour le load balancer (pour LB public)')
param publicIpAddressId string = ''

@description('ID du sous-réseau pour le load balancer (pour LB interne)')
param subnetId string = ''

@description('Adresse IP privée (pour le load balancer interne)')
param privateIpAddress string = ''

@description('Method de allocation d\'adresse IP privée')
@allowed([
  'Dynamic'
  'Static'
])
param privateIpAllocationMethod string = 'Dynamic'

@description('Configuration des frontend IP')
param frontendIpConfigurations array = []

@description('Pools d\'adresses backend')
param backendAddressPools array = []

@description('Règles de load balancing')
param loadBalancingRules array = []

@description('Health probes pour le load balancer')
param probes array = []

@description('Règles NAT entrantes (inbound NAT rules)')
param inboundNatRules array = []

@description('Règles sortantes (outbound rules)')
param outboundRules array = []

@description('Tags à appliquer au load balancer')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// Load Balancer Resource
resource loadBalancer 'Microsoft.Network/loadBalancers@2023-09-01' = {
  name: loadBalancerName
  location: resolvedLocation
  tags: tags
  sku: {
    name: sku
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: !empty(frontendIpConfigurations)
      ? frontendIpConfigurations
      : [
          {
            name: 'frontendIpConfig'
            properties: type == 'Public'
              ? { publicIPAddress: { id: publicIpAddressId } }
              : {
                  subnet: { id: subnetId }
                  privateIPAddress: !empty(privateIpAddress) ? privateIpAddress : null
                  privateIPAllocationMethod: privateIpAllocationMethod
                }
          }
        ]
    backendAddressPools: !empty(backendAddressPools)
      ? backendAddressPools
      : [
          {
            name: 'backendPool'
          }
        ]
    loadBalancingRules: loadBalancingRules
    probes: probes
    inboundNatRules: inboundNatRules
    outboundRules: outboundRules
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: loadBalancer
  name: '${loadBalancerName}-diagnostics'
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
@description('ID du Load Balancer')
output loadBalancerId string = loadBalancer.id

@description('Nom du Load Balancer')
output loadBalancerName string = loadBalancer.name

@description('IDs des configurations frontend IP')
output frontendIpConfigurationIds array = [
  for (config, i) in frontendIpConfigurations: '${loadBalancer.id}/frontendIPConfigurations/${config.name}'
]

@description('IDs des pools d\'adresses backend')
output backendAddressPoolIds array = [
  for (pool, i) in backendAddressPools: '${loadBalancer.id}/backendAddressPools/${pool.name}'
]

@description('Adresse IP privée frontend (pour le load balancer interne)')
output privateIpAddress string = (type == 'Internal' && !empty(loadBalancer.properties.frontendIPConfigurations))
  ? loadBalancer.properties.frontendIPConfigurations[0].properties.privateIPAddress ?? ''
  : ''
