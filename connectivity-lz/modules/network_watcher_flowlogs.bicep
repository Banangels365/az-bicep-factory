// connectivity-lz/modules/network_watcher_flowlogs.bicep
// This module deploys NSG Flow Logs for a given NSG and Network Watcher, with optional integration to Log Analytics for Traffic Analytics.

@description('Nom du Network Watcher')
param networkWatcherName string

@description('Nom du Network Security Group pour lequel activer les Flow Logs')
param nsgId string

@description('ID du compte de stockage pour les Flow Logs du NSG')
param flowLogsStorageAccountId string

@description('Région pour les Flow Logs (doit correspondre à celle du Network Watcher)')
param location string

@description('Tags à appliquer au Flow Logs')
param tags object

@description('Rétention des Flow Logs en jours (7-365)')
param flowLogsRetentionDays int

@description('ID du Log Analytics Workspace pour l\'intégration de Traffic Analytics (optionnel)')
param logAnalyticsWorkspaceId string

@description('Nom du resource Flow Logs')
param flowLogName string

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

resource networkWatcher 'Microsoft.Network/networkWatchers@2023-09-01' existing = {
  name: networkWatcherName
}

resource flowLogs 'Microsoft.Network/networkWatchers/flowLogs@2023-09-01' = {
  parent: networkWatcher
  name: flowLogName
  location: resolvedLocation
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
