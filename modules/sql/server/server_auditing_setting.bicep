// modules/sql/server/server_auditing_setting.bicep

/*
  Module : Azure SQL Server Auditing Settings
  Fonction :
    Ce module configure les paramètres d’audit (Auditing Settings) d’un serveur Azure SQL.
    Il permet :
      - D’activer ou désactiver l’audit
      - De définir les actions et groupes d’actions audités
      - D’activer l’audit vers Azure Monitor ou DevOps
      - D’utiliser une identité managée ou une clé d’accès de stockage
      - De configurer la rétention des logs
      - De créer automatiquement une attribution de rôle RBAC pour l’identité managée
*/

targetScope = 'resourceGroup'

@description('Nom de l\'auditing setting.')
param name string

@description('Nom du serveur SQL.')
param serverName string

@description('État de l\'audit. Peut être "Enabled" ou "Disabled".')
@allowed([
  'Enabled'
  'Disabled'
])
param state string = 'Enabled'

@description('Liste des actions et des groupes à auditer.')
param auditActionsAndGroups array = [
  'BATCH_COMPLETED_GROUP'
  'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
  'FAILED_DATABASE_AUTHENTICATION_GROUP'
]

@description('Indique si l\'audit est activé pour la cible Azure Monitor.')
param isAzureMonitorTargetEnabled bool = true

@description('Indique si l\'audit est activé pour DevOps.')
param isDevopsAuditEnabled bool = false

@description('Indique si une identité gérée est utilisée pour l\'audit.')
param isManagedIdentityInUse bool = false

@description('Indique si la clé secondaire du stockage est utilisée pour l\'audit.')
param isStorageSecondaryKeyInUse bool = false

@description('Délai de file d\'attente en millisecondes pour l\'audit.')
param queueDelayMs int = 1000

@description('Nombre de jours de rétention pour l\'audit.')
param retentionDays int = 90

@description('ID de la ressource de stockage pour l\'audit.')
param storageAccountResourceId string = ''

@description('ID de principal de l\'identité gérée pour l\'audit.')
param managedIdentityPrincipalId string?

var storageBlobDataContributorRoleDefinitionId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
)

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

resource storageRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (isManagedIdentityInUse && !empty(storageAccountResourceId) && !empty(managedIdentityPrincipalId)) {
  name: guid(storageAccountResourceId, managedIdentityPrincipalId!, storageBlobDataContributorRoleDefinitionId)
  properties: {
    roleDefinitionId: storageBlobDataContributorRoleDefinitionId
    principalId: managedIdentityPrincipalId!
    principalType: 'ServicePrincipal'
  }
}

resource auditSettings 'Microsoft.Sql/servers/auditingSettings@2023-08-01' = {
  name: name
  parent: server
  properties: {
    state: state
    auditActionsAndGroups: auditActionsAndGroups
    isAzureMonitorTargetEnabled: isAzureMonitorTargetEnabled
    isDevopsAuditEnabled: isDevopsAuditEnabled
    isManagedIdentityInUse: isManagedIdentityInUse
    isStorageSecondaryKeyInUse: isStorageSecondaryKeyInUse
    queueDelayMs: queueDelayMs
    retentionDays: retentionDays
    storageAccountAccessKey: !empty(storageAccountResourceId) && !isManagedIdentityInUse
      ? listKeys(storageAccountResourceId, '2023-05-01').keys[0].value
      : null
    storageAccountSubscriptionId: !empty(storageAccountResourceId) ? split(storageAccountResourceId, '/')[2] : null
    storageEndpoint: !empty(storageAccountResourceId)
      ? 'https://${last(split(storageAccountResourceId, '/'))}.blob.${environment().suffixes.storage}'
      : null
  }
}

@description('Nom de l\'auditing setting créé.')
output name string = auditSettings.name

@description('ID de la ressource de l\'auditing setting créé.')
output resourceId string = auditSettings.id
