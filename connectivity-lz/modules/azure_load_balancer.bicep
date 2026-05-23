// connectivity-lz/modules/azure_load_balancer.bicep
// Azure Load Balancer module with frontend and backend configuration

@description('Load Balancer name')
param loadBalancerName string

@description('Location for the load balancer')
param location string

@description('Load Balancer SKU')
@allowed([
  'Basic'
  'Standard'
  'Gateway'
])
param sku string = 'Standard'

@description('Load Balancer type (Public or Internal)')
@allowed([
  'Public'
  'Internal'
])
param type string = 'Public'

@description('Public IP Address resource ID (for public load balancer)')
param publicIpAddressId string = ''

@description('Subnet ID (for internal load balancer)')
param subnetId string = ''

@description('Private IP address (for internal load balancer)')
param privateIpAddress string = ''

@description('Private IP allocation method')
@allowed([
  'Dynamic'
  'Static'
])
param privateIpAllocationMethod string = 'Dynamic'

@description('Availability zones')
param zones array = []

@description('Frontend IP configurations')
param frontendIpConfigurations array = []

@description('Backend address pools')
param backendAddressPools array = []

@description('Load balancing rules')
param loadBalancingRules array = []

@description('Health probes')
param probes array = []

@description('Inbound NAT rules')
param inboundNatRules array = []

@description('Outbound rules')
param outboundRules array = []

@description('Tags to apply to the load balancer')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID for diagnostics')
param logAnalyticsWorkspaceId string = ''

// Load Balancer Resource
resource loadBalancer 'Microsoft.Network/loadBalancers@2023-09-01' = {
  name: loadBalancerName
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
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
            zones: !empty(zones) ? zones : null
            properties: type == 'Public'
              ? {
                  publicIPAddress: {
                    id: publicIpAddressId
                  }
                }
              : {
                  subnet: {
                    id: subnetId
                  }
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
        category: 'LoadBalancerAlertEvent'
        enabled: true
      }
      {
        category: 'LoadBalancerProbeHealthStatus'
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
@description('Load Balancer resource ID')
output loadBalancerId string = loadBalancer.id

@description('Load Balancer name')
output loadBalancerName string = loadBalancer.name

@description('Frontend IP configuration IDs')
output frontendIpConfigurationIds array = [
  for (config, i) in frontendIpConfigurations: '${loadBalancer.id}/frontendIPConfigurations/${config.name}'
]

@description('Backend address pool IDs')
output backendAddressPoolIds array = [
  for (pool, i) in backendAddressPools: '${loadBalancer.id}/backendAddressPools/${pool.name}'
]

@description('Frontend private IP address (for internal LB)')
output privateIpAddress string = type == 'Internal'
  ? loadBalancer.properties.frontendIPConfigurations[0].properties.privateIPAddress
  : ''
