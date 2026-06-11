// connectivity-lz/modules/network_security_group.bicep
// Network Security Group module with security rules

@description('Nom du Network Security Group')
param nsgName string

@description('Région pour le NSG')
param location string

@description('Nom du Network Watcher optionnel à utiliser pour les logs de flux. Si vide, le module utilisera "NetworkWatcher_<location>"')
param networkWatcherName string = ''

@description('Règles de sécurité du NSG')
param securityRules array = []

@description('Tags à appliquer au NSG')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

@description('ID du compte de stockage pour les logs de flux NSG')
param flowLogsStorageAccountId string = ''

@description('Activer les flow logs NSG')
param enableFlowLogs bool = false

@description('Rétention des flow logs NSG en jours (7-365)')
param flowLogsRetentionDays int = 7

@description('Groupe de ressources du Network Watcher (pour les flow logs)')
param networkWatcherRg string = 'NetworkWatcherRG'

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// Variable pour le Network Watcher (requis pour les flow logs)
// Nom effectif du Network Watcher: prioriser le param `networkWatcherName` s'il est fourni.
var effectiveNetworkWatcherName = empty(networkWatcherName) ? 'NetworkWatcher_${resolvedLocation}' : networkWatcherName

// Network Security Group Resource
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: nsgName
  location: resolvedLocation
  tags: tags
  properties: {
    securityRules: [
      for rule in securityRules: {
        name: rule.name
        properties: union(
          // Propriétés obligatoires
          {
            description: rule.?description ?? ''
            protocol: rule.protocol
            access: rule.access
            priority: rule.priority
            direction: rule.direction
          },
          // Propriétés optionnelles — omises si absentes
          !empty(rule.?sourcePortRange ?? '') ? { sourcePortRange: rule.sourcePortRange } : {},
          !empty(rule.?sourcePortRanges ?? []) ? { sourcePortRanges: rule.sourcePortRanges } : {},
          !empty(rule.?destinationPortRange ?? '') ? { destinationPortRange: rule.destinationPortRange } : {},
          !empty(rule.?destinationPortRanges ?? []) ? { destinationPortRanges: rule.destinationPortRanges } : {},
          !empty(rule.?sourceAddressPrefix ?? '') ? { sourceAddressPrefix: rule.sourceAddressPrefix } : {},
          !empty(rule.?sourceAddressPrefixes ?? []) ? { sourceAddressPrefixes: rule.sourceAddressPrefixes } : {},
          !empty(rule.?destinationAddressPrefix ?? '')
            ? { destinationAddressPrefix: rule.destinationAddressPrefix }
            : {},
          !empty(rule.?destinationAddressPrefixes ?? [])
            ? { destinationAddressPrefixes: rule.destinationAddressPrefixes }
            : {}
        )
      }
    ]
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: networkSecurityGroup
  name: '${nsgName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
  }
}

// Network Watcher (reference to existing)
resource networkWatcher 'Microsoft.Network/networkWatchers@2023-09-01' existing = if (enableFlowLogs) {
  scope: resourceGroup(networkWatcherRg)
  name: effectiveNetworkWatcherName
}

// NSG Flow Logs
module flowLogsModule './network_watcher_flowlogs.bicep' = if (enableFlowLogs && !empty(flowLogsStorageAccountId)) {
  name: 'deploy-flowlogs-${nsgName}'

  scope: resourceGroup(networkWatcherRg)

  params: {
    networkWatcherName: effectiveNetworkWatcherName
    nsgId: networkSecurityGroup.id
    flowLogsStorageAccountId: flowLogsStorageAccountId
    location: resolvedLocation
    tags: tags
    flowLogsRetentionDays: flowLogsRetentionDays
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    flowLogName: '${nsgName}-flowlogs'
  }
  dependsOn: [
    networkWatcher
  ]
}

// Outputs
@description('ID du Network Security Group')
output nsgId string = networkSecurityGroup.id

@description('Nom du Network Security Group')
output nsgName string = networkSecurityGroup.name

@description('Règles de sécurité du NSG')
output securityRules array = networkSecurityGroup.properties.securityRules
