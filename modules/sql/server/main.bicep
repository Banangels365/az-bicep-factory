// modules/data/sql/server/main.bicep

/*
  Module : Azure SQL Server (main)
  Fonction :
    Ce module déploie un serveur Azure SQL complet, incluant :
      - Configuration du serveur (TLS, réseau, identité, admin AAD, admin SQL)
      - Règles réseau (firewall, VNet rules, outbound firewall)
      - Paramètres de sécurité (audit, security alert policies, VA)
      - Chiffrement (CMK, encryption protector)
      - Diagnostic settings
      - Déploiement des bases de données
      - Déploiement des elastic pools
      - Déploiement des failover groups
      - Assignations RBAC
      - Verrouillage de ressource

    Il agit comme orchestrateur et appelle les modules enfants :
      - server_database.bicep
      - server_elastic_pool.bicep
      - server_firewall_rule.bicep
      - server_virtual_network_rule.bicep
      - server_security_alert_policy.bicep
      - server_key.bicep
      - server_encryption_protector.bicep
      - server_auditing_setting.bicep
      - server_vulnerability_assessment.bicep
      - server_failover_group.bicep
*/

targetScope = 'resourceGroup'

import { roleAssignmentType, lockType, diagnosticSettingType, externalAdministratorType } from '../types.bicep'

@description('Nom du serveur SQL.')
param name string

@description('Région logique de déploiement (caea = Canada East, cace = Canada Central).')
@allowed([
  'cace'
  'caea'
])
param location string = 'caea'

@description('Login administrateur SQL (facultatif si admin AAD uniquement).')
param administratorLogin string?

@description('Mot de passe administrateur SQL.')
@secure()
param administratorLoginPassword string?

@description('Administrateur Azure AD du serveur SQL.')
param administrators externalAdministratorType?

@description('Configuration des identités managées (systemAssigned et/ou userAssigned).')
param managedIdentities object = {
  systemAssigned: true
}

@description('Resource ID de l\'identité managée utilisateur principale (UAMI).')
param primaryUserAssignedIdentityResourceId string?

@description('Version TLS minimale.')
@allowed([
  '1.0'
  '1.1'
  '1.2'
  '1.3'
])
param minimalTlsVersion string = '1.2'

@description('Accès réseau public au serveur SQL.')
@allowed([
  'Disabled'
  'Enabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = 'Disabled'

@description('Activation du support IPv6.')
@allowed([
  'Disabled'
  'Enabled'
])
param isIPv6Enabled string = 'Disabled'

@description('Politique de connexion (Default, Redirect, Proxy).')
@allowed([
  'Default'
  'Redirect'
  'Proxy'
])
param connectionPolicy string = 'Default'

@description('Restriction des flux sortants du serveur SQL.')
@allowed([
  'Disabled'
  'Enabled'
])
param restrictOutboundNetworkAccess string?

@description('Liste des domaines autorisés pour les outbound firewall rules.')
param outboundFirewallRules array = []

@description('Configuration simplifiée des clés CMK (server keys).')
param keys array = []

@description('Configuration de l\'encryption protector du serveur.')
param encryptionProtector object?

@description('Configuration des paramètres d\'audit du serveur SQL.')
param auditSettings object?

@description('Liste des security alert policies à appliquer.')
param securityAlertPolicies array = []

@description('Diagnostic settings à appliquer au serveur SQL.')
param diagnosticSettings diagnosticSettingType[] = []

@description('Configuration de l\'évaluation de vulnérabilité (VA).')
param vulnerabilityAssessment object?

@description('Liste des bases de données à déployer.')
param databases array = []

@description('Liste des elastic pools à déployer.')
param elasticPools array = []

@description('Liste des règles firewall à appliquer.')
param firewallRules array = []

@description('Liste des règles VNet à appliquer.')
param virtualNetworkRules array = []

@description('Liste des failover groups à déployer.')
param failoverGroups array = []

@description('Assignations RBAC à appliquer au serveur SQL.')
param roleAssignments roleAssignmentType[] = []

@description('Verrouillage de ressource (CanNotDelete / ReadOnly).')
param lock lockType?

@description('Tags à appliquer au serveur SQL et ressources enfants.')
param tags object = {}

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// Conversion des UAMI en dictionnaire attendu par Azure
var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

// Construction de l'objet identity selon les combinaisons SA/UAMI
var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

resource server 'Microsoft.Sql/servers@2023-08-01' = {
  name: name
  location: resolvedLocation
  tags: tags
  identity: identity
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword

    // Administrateur Azure AD
    administrators: administrators != null ? union({ administratorType: 'ActiveDirectory' }, administrators!) : null
    version: '12.0'
    minimalTlsVersion: minimalTlsVersion
    primaryUserAssignedIdentityId: primaryUserAssignedIdentityResourceId
    publicNetworkAccess: publicNetworkAccess
    isIPv6Enabled: isIPv6Enabled
    restrictOutboundNetworkAccess: restrictOutboundNetworkAccess
  }
}

resource serverLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  scope: server
  properties: {
    level: lock.?kind!
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

resource serverRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in roleAssignments: {
    name: roleAssignment.?name ?? guid(server.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    scope: server
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      principalType: roleAssignment.?principalType
      description: roleAssignment.?description
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
  }
]

resource serverConnectionPolicy 'Microsoft.Sql/servers/connectionPolicies@2023-08-01' = {
  name: 'default'
  parent: server
  properties: {
    connectionType: connectionPolicy
  }
}

resource serverOutboundFirewallRules 'Microsoft.Sql/servers/outboundFirewallRules@2023-08-01' = [
  for domain in outboundFirewallRules: {
    name: domain
    parent: server
  }
]

module sqlDatabases './server_database.bicep' = [
  for (database, i) in databases: {
    name: '${deployment().name}-sql-db-${i}'
    params: {
      serverName: server.name
      location: resolvedLocation
      name: database.name

      // Configuration SKU
      sku: database.?sku ?? {
        name: 'GP_Gen5_2'
        tier: 'GeneralPurpose'
      }

      // Paramètres généraux
      autoPauseDelay: database.?autoPauseDelay ?? -1
      availabilityZone: database.?availabilityZone ?? -1
      catalogCollation: database.?catalogCollation ?? 'DATABASE_DEFAULT'
      collation: database.?collation ?? 'SQL_Latin1_General_CP1_CI_AS'
      createMode: database.?createMode ?? 'Default'

      // Pool élastique
      elasticPoolResourceId: database.?elasticPoolResourceId

      // Identité fédérée
      federatedClientId: database.?federatedClientId

      // Comportement free tier
      freeLimitExhaustionBehavior: database.?freeLimitExhaustionBehavior

      // Haute disponibilité
      highAvailabilityReplicaCount: database.?highAvailabilityReplicaCount ?? 0

      // Ledger
      isLedgerOn: database.?isLedgerOn ?? false

      // Licence
      licenseType: database.?licenseType

      // Restauration / backup
      longTermRetentionBackupResourceId: database.?longTermRetentionBackupResourceId
      maintenanceConfigurationId: database.?maintenanceConfigurationId
      manualCutover: database.?manualCutover
      maxSizeBytes: database.?maxSizeBytes ?? 34359738368
      minCapacity: database.?minCapacity ?? '0'
      performCutover: database.?performCutover
      preferredEnclaveType: database.?preferredEnclaveType
      readScale: database.?readScale ?? 'Disabled'
      recoverableDatabaseResourceId: database.?recoverableDatabaseResourceId
      recoveryServicesRecoveryPointId: database.?recoveryServicesRecoveryPointId
      requestedBackupStorageRedundancy: database.?requestedBackupStorageRedundancy ?? 'Local'
      restorableDroppedDatabaseResourceId: database.?restorableDroppedDatabaseResourceId
      restorePointInTime: database.?restorePointInTime

      // Samples
      sampleName: database.?sampleName ?? ''

      // Réplication secondaire
      secondaryType: database.?secondaryType

      // Sources
      sourceDatabaseDeletionDate: database.?sourceDatabaseDeletionDate
      sourceDatabaseResourceId: database.?sourceDatabaseResourceId
      sourceResourceId: database.?sourceResourceId

      // Free tier
      useFreeLimit: database.?useFreeLimit

      // Zone redundancy
      zoneRedundant: database.?zoneRedundant ?? false

      // Tags & lock
      tags: database.?tags ?? tags
      lock: database.?lock ?? null

      // Diagnostics
      diagnosticSettings: database.?diagnosticSettings ?? []

      // Identités
      managedIdentities: database.?managedIdentities ?? {}

      // CMK
      customerManagedKey: database.?customerManagedKey

      // STR / LTR
      backupShortTermRetentionPolicy: database.?backupShortTermRetentionPolicy
      backupLongTermRetentionPolicy: database.?backupLongTermRetentionPolicy
    }
  }
]

module sqlElasticPools './server_elastic_pool.bicep' = [
  for (pool, i) in elasticPools: {
    name: '${deployment().name}-sql-ep-${i}'
    params: {
      serverName: server.name
      location: resolvedLocation
      name: pool.name
      tags: pool.?tags ?? tags
      lock: pool.?lock ?? null

      // SKU
      sku: pool.?sku ?? {
        name: 'GP_Gen5'
        tier: 'GeneralPurpose'
        capacity: 2
      }

      // Paramètres généraux
      autoPauseDelay: pool.?autoPauseDelay ?? -1
      availabilityZone: pool.?availabilityZone ?? -1
      highAvailabilityReplicaCount: pool.?highAvailabilityReplicaCount
      licenseType: pool.?licenseType ?? 'LicenseIncluded'
      maintenanceConfigurationId: pool.?maintenanceConfigurationId
      maxSizeBytes: pool.?maxSizeBytes ?? 34359738368
      minCapacity: pool.?minCapacity

      // Paramètres par base
      perDatabaseSettings: pool.?perDatabaseSettings ?? {
        autoPauseDelay: -1
        maxCapacity: '2'
        minCapacity: '0'
      }

      // Sécurité
      preferredEnclaveType: pool.?preferredEnclaveType ?? 'Default'
      zoneRedundant: pool.?zoneRedundant ?? true

      // RBAC
      roleAssignments: pool.?roleAssignments ?? []
    }
  }
]

module sqlFirewallRules './server_firewall_rule.bicep' = [
  for (rule, i) in firewallRules: {
    name: '${deployment().name}-sql-fw-${i}'
    params: {
      serverName: server.name
      name: rule.name
      startIpAddress: rule.?startIpAddress ?? '0.0.0.0'
      endIpAddress: rule.?endIpAddress ?? '0.0.0.0'
    }
  }
]

module sqlVirtualNetworkRules './server_virtual_network_rule.bicep' = [
  for (rule, i) in virtualNetworkRules: {
    name: '${deployment().name}-sql-vnet-${i}'
    params: {
      serverName: server.name
      name: rule.name
      virtualNetworkSubnetResourceId: rule.virtualNetworkSubnetResourceId
      ignoreMissingVnetServiceEndpoint: rule.?ignoreMissingVnetServiceEndpoint ?? false
    }
  }
]

module sqlSecurityAlertPolicies './server_security_alert_policy.bicep' = [
  for (policy, i) in securityAlertPolicies: {
    name: '${deployment().name}-sql-sap-${i}'
    params: {
      serverName: server.name
      name: policy.?name ?? 'Default'
      state: policy.?state ?? 'Enabled'
      disabledAlerts: policy.?disabledAlerts ?? []
      emailAccountAdmins: policy.?emailAccountAdmins ?? true
      emailAddresses: policy.?emailAddresses ?? []
      retentionDays: policy.?retentionDays ?? 0
      storageEndpoint: policy.?storageEndpoint
      storageAccountAccessKey: policy.?storageAccountAccessKey
    }
  }
]

module sqlKeys './server_key.bicep' = [
  for (key, i) in keys: {
    name: '${deployment().name}-sql-key-${i}'
    params: {
      serverName: server.name
      name: key.?name
      serverKeyType: key.?serverKeyType ?? 'ServiceManaged'
      uri: key.?uri ?? ''
    }
  }
]

module sqlEncryptionProtector './server_encryption_protector.bicep' = if (encryptionProtector != null) {
  name: '${deployment().name}-sql-encryption-protector'
  params: {
    sqlServerName: server.name
    serverKeyName: encryptionProtector.?serverKeyName
    serverKeyType: encryptionProtector.?serverKeyType ?? 'ServiceManaged'
    autoRotationEnabled: encryptionProtector.?autoRotationEnabled ?? true
  }
}

module sqlAuditSettings './server_auditing_setting.bicep' = if (auditSettings != null) {
  name: '${deployment().name}-sql-audit'
  params: {
    serverName: server.name
    name: auditSettings.?name ?? 'default'
    state: auditSettings.?state ?? 'Enabled'
    auditActionsAndGroups: auditSettings.?auditActionsAndGroups ?? [
      'BATCH_COMPLETED_GROUP'
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
    ]
    isAzureMonitorTargetEnabled: auditSettings.?isAzureMonitorTargetEnabled ?? true
    isDevopsAuditEnabled: auditSettings.?isDevopsAuditEnabled ?? false
    isManagedIdentityInUse: auditSettings.?isManagedIdentityInUse ?? false
    isStorageSecondaryKeyInUse: auditSettings.?isStorageSecondaryKeyInUse ?? false
    queueDelayMs: auditSettings.?queueDelayMs ?? 1000
    retentionDays: auditSettings.?retentionDays ?? 90
    storageAccountResourceId: auditSettings.?storageAccountResourceId ?? ''
    managedIdentityPrincipalId: server.?identity.?principalId
  }
}

module sqlVulnerabilityAssessment './server_vulnerability_assessment.bicep' = if (vulnerabilityAssessment != null) {
  name: '${deployment().name}-sql-va'
  params: {
    serverName: server.name
    name: vulnerabilityAssessment.?name ?? 'default'
    recurringScans: vulnerabilityAssessment.?recurringScans
    storageAccountResourceId: vulnerabilityAssessment.?storageAccountResourceId
    useStorageAccountAccessKey: vulnerabilityAssessment.?useStorageAccountAccessKey ?? false
    createStorageRoleAssignment: vulnerabilityAssessment.?createStorageRoleAssignment ?? false
    managedIdentityPrincipalId: server.?identity.?principalId
  }
}

module sqlFailoverGroups './server_failover_group.bicep' = [
  for (fog, i) in failoverGroups: {
    name: '${deployment().name}-sql-fog-${i}'
    params: {
      serverName: server.name
      name: fog.name
      tags: fog.?tags ?? tags
      databases: fog.databases
      partnerServerResourceIds: fog.partnerServerResourceIds
      readOnlyEndpoint: fog.?readOnlyEndpoint
      readWriteEndpoint: fog.readWriteEndpoint
      secondaryType: fog.secondaryType
    }
  }
]

resource serverDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for diagnosticSetting in diagnosticSettings: {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    scope: server
    properties: {
      // Destinations
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName

      // Logs
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]

      // Metrics
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? []): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]

      // Marketplace Partner
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId

      // Log Analytics destination type
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
  }
]

// Outputs
@description('Nom du serveur SQL.')
output name string = server.name

@description('ID complet de la ressource serveur SQL.')
output resourceId string = server.id

@description('Nom de domaine complet (FQDN) du serveur SQL.')
output fullyQualifiedDomainName string = server.properties.fullyQualifiedDomainName

@description('PrincipalId de l\'identité managée système (si activée).')
output systemAssignedMIPrincipalId string? = server.?identity.?principalId

@description('Région Azure réelle du serveur SQL.')
output location string = server.location
