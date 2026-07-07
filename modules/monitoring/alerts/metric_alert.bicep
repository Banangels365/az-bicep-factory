// modules/monitoring/alerts/metric_alert.bicep
// Déploie une alerte métrique Azure Monitor.

targetScope = 'resourceGroup'

@description('Nom de l\'alerte métrique.')
param name string

@description('Description de l\'alerte.')
param alertDescription string = ''

@description('Localisation de la ressource. Généralement global.')
param location string = 'global'

@description('Indique si l\'alerte est activée.')
param enabled bool = true

@description('Sévérité de l\'alerte, de 0 à 4.')
@allowed([
  0
  1
  2
  3
  4
])
param severity int = 3

@description('Fréquence d\'évaluation en durée ISO 8601.')
@allowed([
  'PT1M'
  'PT5M'
  'PT15M'
  'PT30M'
  'PT1H'
])
param evaluationFrequency string = 'PT5M'

@description('Fenêtre d\'observation en durée ISO 8601.')
@allowed([
  'PT1M'
  'PT5M'
  'PT15M'
  'PT30M'
  'PT1H'
  'PT6H'
  'PT12H'
  'P1D'
])
param windowSize string = 'PT15M'

@description('Liste des resource IDs surveillés par l\'alerte.')
param scopes array

@description('Type de ressource ciblée. Obligatoire pour certains scénarios multi-ressources.')
param targetResourceType string = ''

@description('Région des ressources ciblées. Obligatoire pour certains scénarios multi-ressources.')
param targetResourceRegion string = ''

@description('Indique si l\'alerte doit être auto-résolue.')
param autoMitigate bool = true

@description('Liste des actions à exécuter. Chaque objet peut contenir actionGroupId et webHookProperties.')
param actions array = []

@description('Critère d\'alerte complet, incluant odata.type et les propriétés attendues par Azure Monitor.')
param criteria object

@description('Tags à appliquer à la ressource.')
param tags object = {}

@description('Paramètres de verrouillage de la ressource.')
param lock object = {}

// Variables

var actionGroups = [
  for action in actions: {
    actionGroupId: action.?actionGroupId ?? action
    webHookProperties: action.?webHookProperties
  }
]

// Création des ressources

resource metricAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: !empty(alertDescription) ? alertDescription : null
    severity: severity
    enabled: enabled
    scopes: scopes
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    targetResourceType: !empty(targetResourceType) ? targetResourceType : null
    targetResourceRegion: !empty(targetResourceRegion) ? targetResourceRegion : null
    criteria: union(
      {
        'odata.type': criteria['odata.type']
      },
      contains(criteria, 'allOf')
        ? {
            allOf: criteria.allOf
          }
        : {},
      contains(criteria, 'componentResourceId')
        ? {
            componentId: criteria.componentResourceId
          }
        : {},
      contains(criteria, 'failedLocationCount')
        ? {
            failedLocationCount: criteria.failedLocationCount
          }
        : {},
      contains(criteria, 'webTestResourceId')
        ? {
            webTestId: criteria.webTestResourceId
          }
        : {}
    )
    autoMitigate: autoMitigate
    actions: actionGroups
  }
}

resource metricAlertLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock) && lock.?kind != 'None') {
  name: lock.?name ?? '${name}-lock'
  scope: metricAlert
  properties: {
    level: lock.kind
    notes: lock.?notes ?? (lock.kind == 'CanNotDelete'
      ? 'Cannot delete the resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

// Outputs

@description('Nom de l\'alerte métrique créée.')
output name string = metricAlert.name

@description('ID de ressource de l\'alerte métrique créée.')
output resourceId string = metricAlert.id

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name

@description('Localisation de l\'alerte métrique.')
output location string = metricAlert.location
