// modules/monitoring/alerts/action_group.bicep
// Déploie un Action Group Azure Monitor.

targetScope = 'resourceGroup'

@description('Nom de l\'Action Group.')
param name string

@description('Nom court de l\'Action Group, utilisé notamment dans certains canaux de notification.')
@minLength(1)
@maxLength(12)
param groupShortName string

@description('Indique si l\'Action Group est activé.')
param enabled bool = true

@description('Localisation de la ressource. Généralement global.')
param location string = 'global'

@description('Liste des email receivers.')
param emailReceivers array = []

@description('Liste des Event Hub receivers.')
param eventHubReceivers array = []

@description('Liste des SMS receivers.')
param smsReceivers array = []

@description('Liste des webhook receivers.')
param webhookReceivers array = []

@description('Liste des ITSM receivers.')
param itsmReceivers array = []

@description('Liste des Azure App Push receivers.')
param azureAppPushReceivers array = []

@description('Liste des Automation Runbook receivers.')
param automationRunbookReceivers array = []

@description('Liste des voice receivers.')
param voiceReceivers array = []

@description('Liste des Logic App receivers.')
param logicAppReceivers array = []

@description('Liste des Azure Function receivers.')
param azureFunctionReceivers array = []

@description('Liste des ARM role receivers.')
param armRoleReceivers array = []

@description('Liste des incident receivers.')
param incidentReceivers array = []

@description('Tags à appliquer à la ressource.')
param tags object = {}

@description('Paramètres de verrouillage de la ressource.') // Exemple : { kind: ''CanNotDelete'', name: ''lock-monitoring'', notes: ''Protection'' }.
param lock object = {}

// Création des ressources

resource actionGroup 'Microsoft.Insights/actionGroups@2024-10-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    groupShortName: groupShortName
    enabled: enabled
    emailReceivers: emailReceivers
    eventHubReceivers: eventHubReceivers
    smsReceivers: smsReceivers
    webhookReceivers: webhookReceivers
    itsmReceivers: itsmReceivers
    azureAppPushReceivers: azureAppPushReceivers
    automationRunbookReceivers: automationRunbookReceivers
    voiceReceivers: voiceReceivers
    logicAppReceivers: logicAppReceivers
    azureFunctionReceivers: azureFunctionReceivers
    armRoleReceivers: armRoleReceivers
    incidentReceivers: incidentReceivers
  }
}

resource actionGroupLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock) && lock.?kind != 'None') {
  name: lock.?name ?? '${name}-lock'
  scope: actionGroup
  properties: {
    level: lock.kind
    notes: lock.?notes ?? (lock.kind == 'CanNotDelete'
      ? 'Cannot delete the resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

// Outputs

@description('Nom de l\'Action Group créé.')
output name string = actionGroup.name

@description('ID de ressource de l\'Action Group créé.')
output resourceId string = actionGroup.id

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name

@description('Localisation de l\'Action Group.')
output location string = actionGroup.location
