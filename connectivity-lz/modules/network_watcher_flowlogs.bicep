// connectivity-lz/modules/network_watcher_flowlogs.bicep
// This module deploys NSG Flow Logs for a given NSG and Network Watcher, with optional integration to Log Analytics for Traffic Analytics.

@description('Name of the Network Watcher to associate with Flow Logs')
param networkWatcherName string

@description('Name of the NSG to enable Flow Logs on')
param nsgId string

@description('Storage Account ID for NSG Flow Logs')
param flowLogsStorageAccountId string

@description('Location for the Flow Logs resource')
param location string

@description('Tags to apply to the Flow Logs resource')
param tags object

@description('Flow logs retention in days')
param flowLogsRetentionDays int

@description('Log Analytics Workspace ID for Traffic Analytics (optional)')
param logAnalyticsWorkspaceId string

@description('Name of the Flow Logs resource')
param flowLogName string

resource networkWatcher 'Microsoft.Network/networkWatchers@2023-09-01' existing = {
  name: networkWatcherName
}

resource flowLogs 'Microsoft.Network/networkWatchers/flowLogs@2023-09-01' = {
  parent: networkWatcher
  name: flowLogName
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
  tags: tags
  properties: {
    targetResourceId: nsgId
    storageId: flowLogsStorageAccountId
    enabled: true

    retentionPolicy: {
      enabled: flowLogsRetentionDays > 0
      days: flowLogsRetentionDays
    }

    format: {
      type: 'JSON'
      version: 2
    }

    ...(empty(logAnalyticsWorkspaceId)
      ? {}
      : {
          flowAnalyticsConfiguration: {
            networkWatcherFlowAnalyticsConfiguration: {
              enabled: true
              workspaceResourceId: logAnalyticsWorkspaceId
              trafficAnalyticsInterval: 10
            }
          }
        })
  }
}
