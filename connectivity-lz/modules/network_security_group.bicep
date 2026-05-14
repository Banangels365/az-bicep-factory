// connectivity-lz/modules/network_security_group.bicep
// Network Security Group module with security rules

@description('Network Security Group name')
param nsgName string

@description('Location for the NSG')
param location string = resourceGroup().location

@description('Security rules for the NSG')
param securityRules array = []

@description('Tags to apply to the NSG')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID for diagnostics')
param logAnalyticsWorkspaceId string = ''

@description('Storage Account ID for NSG flow logs')
param flowLogsStorageAccountId string = ''

@description('Enable NSG flow logs')
param enableFlowLogs bool = false

@description('Flow logs retention in days')
param flowLogsRetentionDays int = 7

@description('Network Watcher resource group name')
param networkWatcherRg string = 'NetworkWatcherRG'

@description('Network Watcher name')
param networkWatcherName string = 'NetworkWatcher_${location}'

// Network Security Group Resource
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: nsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      for rule in securityRules: {
        name: rule.name
        properties: {
          description: rule.?description ?? ''
          protocol: rule.protocol
          access: rule.access
          priority: rule.priority
          direction: rule.direction

          ...(rule.?sourcePortRange != null
            ? {
                sourcePortRange: rule.sourcePortRange
              }
            : {})

          ...(rule.?destinationPortRange != null
            ? {
                destinationPortRange: rule.destinationPortRange
              }
            : {})

          ...(rule.?destinationPortRanges != null
            ? {
                destinationPortRanges: rule.destinationPortRanges
              }
            : {})

          ...(rule.?sourceAddressPrefix != null
            ? {
                sourceAddressPrefix: rule.sourceAddressPrefix
              }
            : {})

          ...(rule.?sourceAddressPrefixes != null
            ? {
                sourceAddressPrefixes: rule.sourceAddressPrefixes
              }
            : {})

          ...(rule.?destinationAddressPrefix != null
            ? {
                destinationAddressPrefix: rule.destinationAddressPrefix
              }
            : {})

          ...(rule.?destinationAddressPrefixes != null
            ? {
                destinationAddressPrefixes: rule.destinationAddressPrefixes
              }
            : {})
        }
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
        category: 'NetworkSecurityGroupEvent'
        enabled: true
      }
      {
        category: 'NetworkSecurityGroupRuleCounter'
        enabled: true
      }
    ]
  }
}

// Network Watcher (reference to existing)
resource networkWatcher 'Microsoft.Network/networkWatchers@2023-09-01' existing = if (enableFlowLogs) {
  scope: resourceGroup(networkWatcherRg)
  name: networkWatcherName
}

// NSG Flow Logs
module flowLogsModule './network_watcher_flowlogs.bicep' = if (enableFlowLogs && !empty(flowLogsStorageAccountId)) {
  name: 'deploy-flowlogs-${nsgName}'

  scope: resourceGroup(networkWatcherRg)

  params: {
    networkWatcherName: networkWatcherName
    nsgId: networkSecurityGroup.id
    flowLogsStorageAccountId: flowLogsStorageAccountId
    location: location
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
@description('Network Security Group resource ID')
output nsgId string = networkSecurityGroup.id

@description('Network Security Group name')
output nsgName string = networkSecurityGroup.name

@description('Security rules')
output securityRules array = networkSecurityGroup.properties.securityRules
