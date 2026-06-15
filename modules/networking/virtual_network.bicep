// modules/networking/virtual_network.bicep
// Virtual Network module with advanced configuration

@description('Nom du VNet')
@minLength(2)
@maxLength(64)
param vnetName string

@description('Région pour le VNet')
param location string

@description('Nom du Network Watcher optionnel à utiliser pour les logs de flux. Si vide, le module utilisera "NetworkWatcher_<location>"')
param networkWatcherName string = ''

@description('Préfixes d\'adresse du VNet (CIDR)')
param addressPrefixes array

@description('Tableau de sous-réseaux à créer dans le VNet.')
param subnets array = []

@description('Activer la protection DDoS pour le VNet')
param enableDdosProtection bool = false

@description('DDoS Protection Plan resource ID')
param ddosProtectionPlanId string = ''

@description('Activer la protection des VM')
param enableVmProtection bool = false

@description('Serveurs DNS pour le VNet (laissez vide pour utiliser les serveurs DNS par défaut d\'Azure)')
param dnsServers array = []

@description('Tags à appliquer au VNet')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Log Analytics Workspace')
param logAnalyticsWorkspaceId string = ''

@description('Activer les flow logs pour le Network Watcher')
param enableFlowLogs bool = false

@description('ID du compte de stockage pour les flow logs')
param flowLogsStorageAccountId string = ''

@description('Activer l\'analyse de trafic (Network Watcher flow analytics)')
param enableTrafficAnalytics bool = false

@description('ID du Log Analytics Workspace pour l\'analyse de trafic')
param trafficAnalyticsWorkspaceId string = ''

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = toLower(location) == 'caea' ? 'canadaeast' : location

// Variable pour le Network Watcher (requis pour les flow logs)
// Nom effectif du Network Watcher: prioriser le param `networkWatcherName` s'il est fourni.
var effectiveNetworkWatcherName = empty(networkWatcherName) ? 'NetworkWatcher_${resolvedLocation}' : networkWatcherName

// Préparer les propriétés des sous-réseaux en fonction des paramètres d'entrée
var subnetProperties = [
  for subnet in subnets: union(
    {
      addressPrefix: subnet.addressPrefix
      serviceEndpoints: subnet.?serviceEndpoints ?? []
      delegations: subnet.?delegations ?? []
      privateEndpointNetworkPolicies: subnet.?privateEndpointNetworkPolicies ?? 'Disabled'
      privateLinkServiceNetworkPolicies: subnet.?privateLinkServiceNetworkPolicies ?? 'Enabled'
    },
    contains(subnet, 'networkSecurityGroupId') ? { networkSecurityGroup: { id: subnet.networkSecurityGroupId } } : {},
    contains(subnet, 'routeTableId') ? { routeTable: { id: subnet.routeTableId } } : {},
    contains(subnet, 'natGatewayId') ? { natGateway: { id: subnet.natGatewayId } } : {}
  )
]

// Virtual Network Resource
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: resolvedLocation
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
      for (subnet, i) in subnets: {
        name: subnet.name
        properties: subnetProperties[i]
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

// Flow Logs pour le Network Watcher
resource flowLogs 'Microsoft.Network/networkWatchers/flowLogs@2023-09-01' = if (enableFlowLogs && !empty(flowLogsStorageAccountId)) {
  name: '${effectiveNetworkWatcherName}/flowLogs-${vnetName}'
  location: resolvedLocation
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
        enabled: enableTrafficAnalytics && (!empty(trafficAnalyticsWorkspaceId) || !empty(logAnalyticsWorkspaceId))
        workspaceId: !empty(trafficAnalyticsWorkspaceId) ? trafficAnalyticsWorkspaceId : logAnalyticsWorkspaceId
        trafficAnalyticsInterval: 60
      }
    }
  }
}

// Outputs
@description('ID du VNet')
output vnetId string = virtualNetwork.id

@description('Nom du VNet')
output vnetName string = virtualNetwork.name

@description('Préfixes d\'adresses du VNet')
output addressPrefixes array = virtualNetwork.properties.addressSpace.addressPrefixes

@description('IDs des ressources de sous-réseaux')
output subnetIds array = [for (subnet, i) in subnets: virtualNetwork.properties.subnets[i].id]

@description('Détails des sous-réseaux')
output subnetDetails array = [
  for (subnet, i) in subnets: {
    name: virtualNetwork.properties.subnets[i].name
    id: virtualNetwork.properties.subnets[i].id
    addressPrefix: virtualNetwork.properties.subnets[i].properties.addressPrefix
  }
]
