// modules/monitoring/alerts/activity_log_alert.bicep
// Déploie une alerte basée sur l'Activity Log Azure.
// Les conditions sont transmises directement sous forme de allOf, afin de conserver un module souple et proche de l'API Azure.

targetScope = 'resourceGroup'

@description('Nom de l\'alerte Activity Log.')
param name string

@description('Description de l\'alerte.')
param alertDescription string = ''

@description('Localisation de la ressource. Généralement global.')
param location string = 'global'

@description('Indique si l\'alerte est activée.')
param enabled bool = true

@description('Liste des scopes (resource IDs) auxquels l\'alerte s\'applique.')
param scopes array = [
  subscription().id
]

@description('Liste des actions à exécuter. Chaque objet peut contenir actionGroupId et webhookProperties.')
param actions array = []

@description('Conditions de déclenchement de l\'alerte. Chaque objet correspond à un élément du allOf Azure Monitor.')
param conditions array

@description('Tags à appliquer à la ressource.')
param tags object = {}

@description('Paramètres de verrouillage de la ressource.')
param lock object = {}

// Variables

var actionGroups = [
  for action in actions: {
    actionGroupId: action.?actionGroupId ?? action
    webhookProperties: action.?webhookProperties
  }
]

// Création des ressources

resource activityLogAlert 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    scopes: scopes
    condition: {
      allOf: conditions
    }
    actions: {
      actionGroups: actionGroups
    }
    enabled: enabled
    description: !empty(alertDescription) ? alertDescription : null
  }
}

resource activityLogAlertLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock) && lock.?kind != 'None') {
  name: lock.?name ?? '${name}-lock'
  scope: activityLogAlert
  properties: {
    level: lock.kind
    notes: lock.?notes ?? (lock.kind == 'CanNotDelete'
      ? 'Cannot delete the resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

// Outputs

@description('Nom de l\'alerte Activity Log créée.')
output name string = activityLogAlert.name

@description('ID de ressource de l\'alerte Activity Log créée.')
output resourceId string = activityLogAlert.id

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name

@description('Localisation de l\'alerte Activity Log.')
output location string = activityLogAlert.location
