// platform-lz/modules/diagnostic_settings.bicep
// Diagnostic Settings module for centralized logging

@description('Nom du paramètre de diagnostic')
param diagnosticSettingName string = 'default-diagnostics'

@description('ID du workspace Log Analytics pour les diagnostics') // Obligatoire si vous souhaitez envoyer les diagnostics à un workspace
param workspaceId string

@description('ID du compte de stockage (optionnel)')
param storageAccountId string = ''

@description('ID de la règle d\'autorisation Hub Event (optionnel)')
param eventHubAuthorizationRuleId string = ''

@description('Nom du Hub Event (optionnel)')
param eventHubName string = ''

@description('Catégories de journaux à activer')
param logCategories array = []

@description('Catégories de métriques à activer')
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
@description('ID du paramètre de diagnostic')
output diagnosticSettingId string = diagnosticSetting.id

@description('Nom du paramètre de diagnostic')
output diagnosticSettingName string = diagnosticSetting.name
