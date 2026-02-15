// az-platform-lz/diagnostic-settings/main.bicep
// Diagnostic Settings module for centralized logging

@description('Name of the diagnostic setting')
param diagnosticSettingName string = 'default-diagnostics'

@description('Log Analytics Workspace resource ID')
param workspaceId string

@description('Storage Account resource ID (optional)')
param storageAccountId string = ''

@description('Event Hub Authorization Rule ID (optional)')
param eventHubAuthorizationRuleId string = ''

@description('Event Hub name (optional)')
param eventHubName string = ''

@description('Log categories to enable')
param logCategories array = []

@description('Metric categories to enable')
param metricCategories array = [
  {
    category: 'AllMetrics'
    enabled: true
  }
]

// @description('Enable all log categories automatically')
// param enableAllLogs bool = true

// Note: This module is meant to be called with a specific resource scope
// Example usage in parent template:
// module diagnostics 'diagnostic-settings/main.bicep' = {
//   scope: resourceToMonitor
//   name: 'diagnostics-deployment'
//   params: { ... }
// }

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingName
  properties: {
    workspaceId: !empty(workspaceId) ? workspaceId : null
    storageAccountId: !empty(storageAccountId) ? storageAccountId : null
    eventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : null
    eventHubName: !empty(eventHubName) ? eventHubName : null
    logs: logCategories
    metrics: metricCategories
  }
}

// Outputs
@description('Diagnostic setting resource ID')
output diagnosticSettingId string = diagnosticSetting.id

@description('Diagnostic setting name')
output diagnosticSettingName string = diagnosticSetting.name
