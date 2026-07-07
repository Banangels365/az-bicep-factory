// modules/monitoring/logging/diagnostic_settings.bicep
// Déploie un diagnostic setting réutilisable.
//
// Ce module est conçu pour être invoqué au scope de la ressource cible ou d'un scope
// plus large compatible (par exemple subscription pour l'Activity Log export).
// Le module reste générique : on lui fournit les destinations et les catégories.

@description('Nom du diagnostic setting.')
@minLength(1)
@maxLength(260)
param diagnosticSettingName string = 'default-diagnostics'

@description('ID du workspace Log Analytics de destination. Laisser vide si non utilisé.')
param workspaceId string = ''

@description('ID du compte de stockage de destination. Laisser vide si non utilisé.')
param storageAccountId string = ''

@description('ID de la règle d\'autorisation Event Hub de destination. Laisser vide si non utilisé.')
param eventHubAuthorizationRuleId string = ''

@description('Nom de l\'Event Hub cible. Si vide, Azure peut créer ou utiliser un hub par catégorie selon le contexte.')
param eventHubName string = ''

@description('Liste des catégories ou groupes de logs à activer. Chaque objet peut contenir category, categoryGroup et enabled.')
param logCategoriesAndGroups array = []

@description('Liste des catégories de métriques à activer. Chaque objet doit contenir au moins category, et peut contenir enabled.')
param metricCategories array = [
  {
    category: 'AllMetrics'
    enabled: true
  }
]

@description('Type de destination Log Analytics. Valeurs possibles : Dedicated ou AzureDiagnostics. Laisser vide pour le comportement par défaut.')
@allowed([
  ''
  'Dedicated'
  'AzureDiagnostics'
])
param logAnalyticsDestinationType string = ''

@description('ID complet d\'une ressource Marketplace partenaire vers laquelle envoyer les logs. Laisser vide si non utilisé.')
param marketplacePartnerResourceId string = ''

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingName
  properties: {
    workspaceId: !empty(workspaceId) ? workspaceId : null
    storageAccountId: !empty(storageAccountId) ? storageAccountId : null
    eventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : null
    eventHubName: !empty(eventHubName) ? eventHubName : null
    logAnalyticsDestinationType: !empty(logAnalyticsDestinationType) ? logAnalyticsDestinationType : null
    marketplacePartnerId: !empty(marketplacePartnerResourceId) ? marketplacePartnerResourceId : null
    logs: [
      for group in logCategoriesAndGroups: {
        category: group.?category
        categoryGroup: group.?categoryGroup
        enabled: group.?enabled ?? true
      }
    ]
    metrics: [
      for metric in metricCategories: {
        category: metric.category
        enabled: metric.?enabled ?? true
        timeGrain: null
      }
    ]
  }
}

@description('ID du diagnostic setting créé.')
output diagnosticSettingId string = diagnosticSetting.id

@description('Nom du diagnostic setting créé.')
output diagnosticSettingName string = diagnosticSetting.name
