// connectivity-lz/modules/virtual_network.bicep
// Virtual Network module with advanced configuration

@description('Virtual Network name')
@minLength(2)
@maxLength(64)
param vnetName string

@description('Location for the virtual network')
param location string

@description('Address space prefixes for the virtual network')
param addressPrefixes array

@description('Array of subnets to create')
param subnets array = []

@description('Enable DDoS Protection')
param enableDdosProtection bool = false

@description('DDoS Protection Plan resource ID')
param ddosProtectionPlanId string = ''

@description('Enable VM Protection')
param enableVmProtection bool = false

@description('DNS servers for the virtual network')
param dnsServers array = []

@description('Tags to apply to the virtual network')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID for diagnostics')
param logAnalyticsWorkspaceId string = ''

@description('Enable flow logs')
param enableFlowLogs bool = false

@description('Storage Account ID for flow logs')
param flowLogsStorageAccountId string = ''

// Virtual Network Resource
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    dhcpOptions: !empty(dnsServers)
      ? {
          dnsServers: dnsServers
        }
      : null
    enableDdosProtection: enableDdosProtection
    ddosProtectionPlan: enableDdosProtection && !empty(ddosProtectionPlanId)
      ? {
          id: ddosProtectionPlanId
        }
      : null
    enableVmProtection: enableVmProtection
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          networkSecurityGroup: contains(subnet, 'networkSecurityGroupId')
            ? {
                id: subnet.networkSecurityGroupId
              }
            : null
          routeTable: contains(subnet, 'routeTableId')
            ? {
                id: subnet.routeTableId
              }
            : null
          serviceEndpoints: subnet.?serviceEndpoints ?? []
          delegations: subnet.?delegations ?? []
          privateEndpointNetworkPolicies: subnet.?privateEndpointNetworkPolicies ?? 'Disabled'
          privateLinkServiceNetworkPolicies: subnet.?privateLinkServiceNetworkPolicies ?? 'Enabled'
          natGateway: contains(subnet, 'natGatewayId')
            ? {
                id: subnet.natGatewayId
              }
            : null
        }
      }
    ]
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: virtualNetwork
  name: '${vnetName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'VMProtectionAlerts'
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

// Variable pour le Network Watcher (requis pour les flow logs)
var networkWatcherName = 'NetworkWatcher_${location}'

// Flow Logs Resource
resource flowLogs 'Microsoft.Network/networkWatchers/flowLogs@2023-09-01' = if (enableFlowLogs && !empty(flowLogsStorageAccountId)) {
  name: '${networkWatcherName}/flowLogs-${vnetName}'
  properties: {
    targetResourceId: virtualNetwork.id
    storageId: flowLogsStorageAccountId
    enabled: true
    format: {
      type: 'JSON'
      version: 2
    }
    flowAnalyticsConfiguration: {
      networkWatcherFlowAnalyticsConfiguration: {
        enabled: false // Peut être activé si vous utilisez Traffic Analytics
        workspaceId: '' // ID de l'espace de travail Log Analytics si nécessaire
        trafficAnalyticsInterval: 60
      }
    }
  }
}

// Outputs
@description('Virtual Network resource ID')
output vnetId string = virtualNetwork.id

@description('Virtual Network name')
output vnetName string = virtualNetwork.name

@description('Virtual Network address prefixes')
output addressPrefixes array = virtualNetwork.properties.addressSpace.addressPrefixes

@description('Subnet resource IDs')
output subnetIds array = [for (subnet, i) in subnets: virtualNetwork.properties.subnets[i].id]

@description('Subnet details')
output subnets array = [
  for (subnet, i) in subnets: {
    name: virtualNetwork.properties.subnets[i].name
    id: virtualNetwork.properties.subnets[i].id
    addressPrefix: virtualNetwork.properties.subnets[i].properties.addressPrefix
  }
]
