// modules/data/sql/managed-instance/database.bicep
// Module pour la création d'une base de données SQL Managed Instance.

targetScope = 'resourceGroup'

import { lockType } from '../types.bicep'

@description('Nom de la base de données SQL Managed Instance')
param name string

@description('Nom de l\'instance SQL Managed Instance parent')
param managedInstanceName string

@description('Région de déploiement')
param location string = resourceGroup().location

@description('Collation de la base de données')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Collation du catalogue de la base de données')
param catalogCollation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Mode de création de la base de données')
@allowed([
  'Default'
  'RestoreExternalBackup'
  'PointInTimeRestore'
  'Recovery'
  'RestoreLongTermRetentionBackup'
])
param createMode string = 'Default'

@description('ID de la base de données source pour les modes de création de restauration')
param sourceDatabaseId string?

@description('Point de temps pour la restauration')
param restorePointInTime string?

@description('ID de la base de données supprimée restorable')
param restorableDroppedDatabaseId string?

@description('URI du conteneur de stockage')
param storageContainerUri string?

@description('SAS token pour le conteneur de stockage')
@secure()
param storageContainerSasToken string?

@description('ID de la base de données récupérable')
param recoverableDatabaseId string?

@description('ID de la ressource de sauvegarde de conservation à long terme')
param longTermRetentionBackupResourceId string?

@description('Paramètres de diagnostic pour la base de données')
param diagnosticSettings array = []

@description('Paramètres de verrouillage pour la base de données')
param lock lockType?

@description('Paramètres de politique de rétention des sauvegardes à court terme')
param backupShortTermRetentionPolicy object?

@description('Paramètres de politique de rétention des sauvegardes à long terme')
param backupLongTermRetentionPolicy object?

@description('Tags pour la base de données')
param tags object = {}

// Ressource de l'instance SQL managée existante
resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName
}

// Ressource de la base de données SQL Managed Instance
resource database 'Microsoft.Sql/managedInstances/databases@2024-05-01-preview' = {
  name: name
  parent: managedInstance
  location: location
  tags: tags
  properties: {
    collation: collation
    catalogCollation: catalogCollation
    createMode: createMode
    sourceDatabaseId: sourceDatabaseId
    restorePointInTime: restorePointInTime
    restorableDroppedDatabaseId: restorableDroppedDatabaseId
    storageContainerUri: storageContainerUri
    storageContainerSasToken: storageContainerSasToken
    recoverableDatabaseId: recoverableDatabaseId
    longTermRetentionBackupResourceId: longTermRetentionBackupResourceId
  }
}

// Ressource de verrouillage pour la base de données
resource databaseLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  scope: database
  properties: {
    level: lock.?kind!
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

// Ressource de paramètres de diagnostic pour la base de données
resource databaseDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for diagnosticSetting in diagnosticSettings: {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    scope: database
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
  }
]

// Modules pour les politiques de rétention des sauvegardes
module shortRetention './db_backup_short_term_retention_policy.bicep' = if (backupShortTermRetentionPolicy != null) {
  name: '${deployment().name}-mi-db-str-${name}'
  params: {
    managedInstanceName: managedInstanceName
    databaseName: database.name
    name: backupShortTermRetentionPolicy.?name ?? 'default'
    retentionDays: backupShortTermRetentionPolicy.?retentionDays ?? 35
  }
}

module longRetention './db_backup_long_term_retention_policy.bicep' = if (backupLongTermRetentionPolicy != null) {
  name: '${deployment().name}-mi-db-ltr-${name}'
  params: {
    managedInstanceName: managedInstanceName
    databaseName: database.name
    name: backupLongTermRetentionPolicy.?name ?? 'default'
    backupStorageAccessTier: backupLongTermRetentionPolicy.?backupStorageAccessTier ?? 'Hot'
    weeklyRetention: backupLongTermRetentionPolicy.?weeklyRetention ?? 'P1M'
    monthlyRetention: backupLongTermRetentionPolicy.?monthlyRetention ?? 'P1Y'
    yearlyRetention: backupLongTermRetentionPolicy.?yearlyRetention ?? 'P5Y'
    weekOfYear: backupLongTermRetentionPolicy.?weekOfYear ?? 5
  }
}

// Outputs
@description('Nom de la base de données SQL Managed Instance')
output name string = database.name

@description('ID de la base de données SQL Managed Instance')
output resourceId string = database.id

@description('Région de la base de données SQL Managed Instance')
output location string = database.location
