// modules/logging/diagnostic_settings.bicep

/* Ce module de paramètres de diagnostic est utilisé pour configurer les paramètres 
   de journalisation centralisée pour les ressources Azure.

   Il permet de spécifier les catégories de journaux et de métriques à activer, 
   ainsi que les détails de la configuration du workspace Log Analytics, 
   du compte de stockage et de la règle d'autorisation du Hub Event.
*/

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
