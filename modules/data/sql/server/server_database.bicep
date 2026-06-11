// modules/data/sql/server/server_database.bicep

/*
  Module : Azure SQL Database Deployment
  Fonction : 
    Ce module déploie une base de données Azure SQL Database sur un serveur existant.
    Il prend en charge :
      - Les configurations de performance (SKU, taille, HA, autoscale)
      - Les modes de création (restore, copy, secondary, sample, etc.)
      - Le chiffrement avec clé gérée par le client (CMK)
      - Les identités managées (system-assigned / user-assigned)
      - Les paramètres de diagnostic
      - Les politiques de rétention (STR / LTR)
      - Le verrouillage du resource (CanNotDelete / ReadOnly)
*/

targetScope = 'resourceGroup'

import { lockType, diagnosticSettingType } from '../types.bicep'

@description('Nom de la base de données à créer.')
param name string

@description('Nom du serveur SQL existant sur lequel la base sera déployée.')
param serverName string

@description('Configuration SKU de la base (tier, compute, etc.).')
param sku object = {
  name: 'GP_Gen5_2'
  tier: 'GeneralPurpose'
}

@description('Délai d\'auto-pause pour les bases serverless. -1 désactive l\'auto-pause.')
param autoPauseDelay int = -1

@description('Zone de disponibilité. -1 = NoPreference.')
@allowed([-1, 1, 2, 3])
param availabilityZone int = -1

@description('Collation du catalogue.')
param catalogCollation string = 'DATABASE_DEFAULT'

@description('Collation de la base de données.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Mode de création de la base (Default, Restore, Copy, PointInTimeRestore, etc.).')
param createMode string = 'Default'

@description('ID de l\'elastic pool si la base doit être intégrée à un pool.')
param elasticPoolResourceId string?

@description('Client ID fédéré pour Azure AD (GUID).')
@minLength(36)
@maxLength(36)
param federatedClientId string?

@description('Comportement en cas de dépassement de la limite gratuite.')
param freeLimitExhaustionBehavior 'AutoPause' | 'BillOverUsage'?

@description('Nombre de réplicas HA pour Business Critical.')
param highAvailabilityReplicaCount int = 0

@description('Active le mode Ledger.')
param isLedgerOn bool = false

@description('Type de licence (BasePrice ou LicenseIncluded).')
param licenseType 'BasePrice' | 'LicenseIncluded'?

@description('ID de la ressource LTR existante pour restaurer une base.')
param longTermRetentionBackupResourceId string?

@description('ID de configuration de maintenance.')
param maintenanceConfigurationId string?

@description('Indique si le cutover manuel est activé pour les migrations.')
param manualCutover bool?

@description('Taille maximale de la base en bytes.')
param maxSizeBytes int = 34359738368

@description('Capacité minimale pour les bases serverless.')
param minCapacity string = '0'

@description('Indique si un cutover doit être effectué.')
param performCutover bool?

@description('Type d\'enclave pour Always Encrypted.')
param preferredEnclaveType 'Default' | 'VBS'?

@description('Active ou désactive le read scale-out.')
param readScale 'Enabled' | 'Disabled' = 'Disabled'

@description('ID d\'une base récupérable.')
param recoverableDatabaseResourceId string?

@description('ID du recovery point dans Recovery Services.')
param recoveryServicesRecoveryPointId string?

@description('Redondance du stockage de sauvegarde.')
param requestedBackupStorageRedundancy 'Geo' | 'GeoZone' | 'Local' | 'Zone' = 'Local'

@description('ID d\'une base supprimée restaurable.')
param restorableDroppedDatabaseResourceId string?

@description('Point dans le temps pour une restauration PITR.')
param restorePointInTime string?

@description('Nom du sample database (AdventureWorksLT, etc.).')
param sampleName string = ''

@description('Type de secondary (Geo, Named, Standby).')
param secondaryType 'Geo' | 'Named' | 'Standby'?

@description('Date de suppression de la base source.')
param sourceDatabaseDeletionDate string?

@description('ID de la base source.')
param sourceDatabaseResourceId string?

@description('ID de la ressource source pour les opérations de migration.')
param sourceResourceId string?

@description('Indique si la base utilise la limite gratuite.')
param useFreeLimit bool?

@description('Active la redondance zone.')
param zoneRedundant bool = false

@description('Tags appliqués à la base.')
param tags object = {}

@description('Localisation de la base.')
param location string = resourceGroup().location

@description('Configuration du verrouillage de ressource.')
param lock lockType?

@description('Liste des diagnostic settings à appliquer.')
param diagnosticSettings diagnosticSettingType[] = []

@description('Configuration de la rétention court terme STR.')
param backupShortTermRetentionPolicy object?

@description('Configuration de la rétention long terme LTR.')
param backupLongTermRetentionPolicy object?

@description('Identités managées (system-assigned / user-assigned).')
param managedIdentities object = {}

@description('Configuration de la clé gérée par le client (CMK).')
param customerManagedKey object?

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

var identity = !empty(managedIdentities)
  ? {
      type: !empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'UserAssigned' : null
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var isHSMManagedCMK = split(customerManagedKey.?keyVaultResourceId ?? '', '/')[?7] == 'managedHSMs'
resource cMKKeyVault 'Microsoft.KeyVault/vaults@2025-05-01' existing = if (!empty(customerManagedKey) && !isHSMManagedCMK) {
  name: last(split(customerManagedKey!.keyVaultResourceId, '/'))
  scope: resourceGroup(
    split(customerManagedKey!.keyVaultResourceId, '/')[2],
    split(customerManagedKey!.keyVaultResourceId, '/')[4]
  )

  resource cMKKey 'keys@2025-05-01' existing = {
    name: customerManagedKey!.keyName
  }
}

resource database 'Microsoft.Sql/servers/databases@2023-08-01' = {
  name: name
  parent: server
  location: location
  tags: tags
  identity: identity
  sku: sku
  properties: {
    autoPauseDelay: autoPauseDelay
    availabilityZone: availabilityZone != -1 ? string(availabilityZone) : 'NoPreference'
    catalogCollation: catalogCollation
    collation: collation
    createMode: createMode
    elasticPoolId: elasticPoolResourceId
    federatedClientId: federatedClientId
    freeLimitExhaustionBehavior: freeLimitExhaustionBehavior
    highAvailabilityReplicaCount: highAvailabilityReplicaCount
    isLedgerOn: isLedgerOn
    licenseType: licenseType
    longTermRetentionBackupResourceId: longTermRetentionBackupResourceId
    maintenanceConfigurationId: maintenanceConfigurationId
    manualCutover: manualCutover
    maxSizeBytes: maxSizeBytes
    minCapacity: json(minCapacity)
    performCutover: performCutover
    preferredEnclaveType: preferredEnclaveType
    readScale: readScale
    recoverableDatabaseId: recoverableDatabaseResourceId
    recoveryServicesRecoveryPointId: recoveryServicesRecoveryPointId
    requestedBackupStorageRedundancy: requestedBackupStorageRedundancy
    restorableDroppedDatabaseId: restorableDroppedDatabaseResourceId
    restorePointInTime: restorePointInTime
    sampleName: !empty(sampleName) ? sampleName : null
    secondaryType: secondaryType
    sourceDatabaseDeletionDate: sourceDatabaseDeletionDate
    sourceDatabaseId: sourceDatabaseResourceId
    sourceResourceId: sourceResourceId
    useFreeLimit: useFreeLimit
    zoneRedundant: zoneRedundant
    encryptionProtector: !empty(customerManagedKey)
      ? !empty(customerManagedKey.?keyVersion)
          ? !isHSMManagedCMK
              ? '${cMKKeyVault::cMKKey.?properties.keyUri}${customerManagedKey!.keyVersion}'
              : 'https://${last(split(customerManagedKey!.keyVaultResourceId, '/'))}.managedhsm.azure.net/keys/${customerManagedKey!.keyName}/${customerManagedKey!.keyVersion}'
          : customerManagedKey.?autoRotationEnabled ?? true
              ? !isHSMManagedCMK
                  ? cMKKeyVault::cMKKey.?properties.keyUri
                  : 'https://${last(split(customerManagedKey!.keyVaultResourceId, '/'))}.managedhsm.azure.net/keys/${customerManagedKey!.keyName}'
              : !isHSMManagedCMK
                  ? cMKKeyVault::cMKKey.?properties.keyUriWithVersion
                  : fail('Managed HSM CMK encryption requires either specifying the keyVersion or omitting the autoRotationEnabled property. Setting autoRotationEnabled to false without a keyVersion is not allowed.')
      : null
    encryptionProtectorAutoRotation: customerManagedKey.?autoRotationEnabled
  }
}

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
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? []): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
  }
]

module shortRetention './server_backup_short_term_retention_policy.bicep' = if (backupShortTermRetentionPolicy != null) {
  name: '${deployment().name}-sql-db-str-${name}'
  params: {
    serverName: serverName
    databaseName: database.name
    diffBackupIntervalInHours: backupShortTermRetentionPolicy.?diffBackupIntervalInHours ?? 24
    retentionDays: backupShortTermRetentionPolicy.?retentionDays ?? 7
  }
}

module longRetention './server_backup_long_term_retention_policy.bicep' = if (backupLongTermRetentionPolicy != null) {
  name: '${deployment().name}-sql-db-ltr-${name}'
  params: {
    serverName: serverName
    databaseName: database.name
    weeklyRetention: backupLongTermRetentionPolicy.?weeklyRetention
    monthlyRetention: backupLongTermRetentionPolicy.?monthlyRetention
    yearlyRetention: backupLongTermRetentionPolicy.?yearlyRetention
    weekOfYear: backupLongTermRetentionPolicy.?weekOfYear ?? 1
  }
}

@description('Nom de la base de données déployée.')
output name string = database.name

@description('ID complet de la ressource Azure SQL Database.')
output resourceId string = database.id

@description('Localisation effective de la base.')
output location string = database.location
