// modules/data/sql/managed-instance/main.bicep
// Module principal pour la création d'une instance SQL managée avec des configurations optionnelles pour les bases de données, la politique d'alerte de sécurité, l'évaluation des vulnérabilités, les clés et le protecteur de chiffrement. 

targetScope = 'resourceGroup'

import { roleAssignmentType, lockType, diagnosticSettingType, externalAdministratorType } from '../types.bicep'

@description('Nom du SQL Managed Instance.')
param name string

@description('Région de déploiement.')
param location string = resourceGroup().location

@description('Login administrateur SQL.')
param administratorLogin string?

@description('Mot de passe administrateur SQL.')
@secure()
param administratorLoginPassword string?

@description('Administrateur Azure AD.')
param administrators externalAdministratorType?

@description('ID complet du subnet hébergeant la managed instance.')
param subnetResourceId string

@description('Nom du SKU.')
param skuName string = 'GP_Gen5'

@description('Tier du SKU.')
param skuTier string = 'GeneralPurpose'

@description('Taille de stockage en GB.')
@minValue(32)
@maxValue(8192)
param storageSizeInGB int = 32

@description('Nombre de vCores.')
param vCores int = 4

@description('Type de licence.')
@allowed([
  'LicenseIncluded'
  'BasePrice'
])
param licenseType string = 'LicenseIncluded'

@description('Famille matérielle.')
param hardwareFamily string = 'Gen5'

@description('Activation de la redondance de zone.')
param zoneRedundant bool = false

@description('Type de service principal pour l\'intégration AAD.')
@allowed([
  'None'
  'SystemAssigned'
])
param servicePrincipal string = 'None'

@description('Mode de création de la managed instance.')
@allowed([
  'Default'
  'PointInTimeRestore'
])
param managedInstanceCreateMode string = 'Default'

@description('Resource ID du partenaire DNS zone.')
param dnsZonePartnerResourceId string?

@description('Collation.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Mode de connexion.')
@allowed([
  'Proxy'
  'Redirect'
  'Default'
])
param proxyOverride string = 'Proxy'

@description('Activation du public data endpoint.')
param publicDataEndpointEnabled bool = false

@description('Fuseau horaire.')
param timezoneId string = 'UTC'

@description('Resource ID de l\'instance pool.')
param instancePoolResourceId string?

@description('Date/heure PITR ISO8601.')
param restorePointInTime string?

@description('Resource ID de la source managed instance.')
param sourceManagedInstanceResourceId string?

@description('Version TLS minimale.')
@allowed([
  'None'
  '1.0'
  '1.1'
  '1.2'
])
param minimalTlsVersion string = '1.2'

@description('Redondance de stockage backup.')
@allowed([
  'Geo'
  'GeoZone'
  'Local'
  'Zone'
])
param requestedBackupStorageRedundancy string = 'Geo'

@description('Fenêtre de maintenance.')
@allowed([
  'SystemManaged'
  'Custom1'
  'Custom2'
])
param maintenanceWindow string?

@description('Managed identities.')
param managedIdentities object = {}

@description('Primary UAMI resource ID.')
param primaryUserAssignedIdentityResourceId string?

@description('Role assignments.')
param roleAssignments roleAssignmentType[] = []

@description('Verrou de ressource.')
param lock lockType?

@description('Diagnostic settings.')
param diagnosticSettings diagnosticSettingType[] = []

@description('Tags à appliquer.')
param tags object = {}

@description('Bases à créer.')
param databases array = []

@description('Security alert policy.')
param securityAlertPolicy object?

@description('Vulnerability assessment.')
param vulnerabilityAssessment object?

@description('Clés SQL MI.')
param keys array = []

@description('Encryption protector.')
param encryptionProtector object?

// Variables pour la configuration de l'identité managéee et de la fenêtre de maintenance
var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var maintenanceConfigurationId = maintenanceWindow == 'Custom1' || maintenanceWindow == 'Custom2'
  ? subscriptionResourceId(
      'Microsoft.Maintenance/publicMaintenanceConfigurations',
      'SQL_${location}_MI_${maintenanceWindow}'
    )
  : null

// Ressource de l'instance SQL managée
resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: skuName
    tier: skuTier
    family: hardwareFamily
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    administrators: administrators != null ? union({ administratorType: 'ActiveDirectory' }, administrators!) : null
    subnetId: subnetResourceId
    licenseType: licenseType
    vCores: vCores
    storageSizeInGB: storageSizeInGB
    collation: collation
    dnsZonePartner: dnsZonePartnerResourceId
    publicDataEndpointEnabled: publicDataEndpointEnabled
    sourceManagedInstanceId: sourceManagedInstanceResourceId
    restorePointInTime: restorePointInTime
    proxyOverride: proxyOverride
    timezoneId: timezoneId
    instancePoolId: instancePoolResourceId
    primaryUserAssignedIdentityId: primaryUserAssignedIdentityResourceId
    requestedBackupStorageRedundancy: requestedBackupStorageRedundancy
    zoneRedundant: zoneRedundant
    servicePrincipal: {
      type: servicePrincipal
    }
    minimalTlsVersion: minimalTlsVersion
    managedInstanceCreateMode: managedInstanceCreateMode
    maintenanceConfigurationId: maintenanceConfigurationId
  }
}

// Ressource de verrouillage pour l'instance SQL managée
resource managedInstanceLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  scope: managedInstance
  properties: {
    level: lock.?kind!
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

// Ressource de paramètres de diagnostic pour l'instance SQL managée
resource managedInstanceDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for diagnosticSetting in diagnosticSettings: {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    scope: managedInstance
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

// Ressource de rôles pour l'instance SQL managée
resource managedInstanceRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in roleAssignments: {
    name: roleAssignment.?name ?? guid(managedInstance.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    scope: managedInstance
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

// Modules pour les bases de données, la politique d'alerte de sécurité, l'évaluation des vulnérabilités, les clés et le protecteur de chiffrement
module miDatabases './database.bicep' = [
  for (database, i) in databases: {
    name: '${deployment().name}-mi-db-${i}'
    params: {
      managedInstanceName: managedInstance.name
      name: database.name
      location: database.?location ?? managedInstance.location
      collation: database.?collation ?? 'SQL_Latin1_General_CP1_CI_AS'
      catalogCollation: database.?catalogCollation ?? 'SQL_Latin1_General_CP1_CI_AS'
      createMode: database.?createMode ?? 'Default'
      sourceDatabaseId: database.?sourceDatabaseId
      restorePointInTime: database.?restorePointInTime
      restorableDroppedDatabaseId: database.?restorableDroppedDatabaseId
      storageContainerUri: database.?storageContainerUri
      storageContainerSasToken: database.?storageContainerSasToken
      recoverableDatabaseId: database.?recoverableDatabaseId
      longTermRetentionBackupResourceId: database.?longTermRetentionBackupResourceId
      diagnosticSettings: database.?diagnosticSettings ?? []
      lock: database.?lock ?? null
      backupShortTermRetentionPolicy: database.?backupShortTermRetentionPolicy
      backupLongTermRetentionPolicy: database.?backupLongTermRetentionPolicy
      tags: database.?tags ?? tags
    }
  }
]

module miSecurityAlert './db_security_alert_policy.bicep' = if (securityAlertPolicy != null) {
  name: '${deployment().name}-mi-security-alert'
  params: {
    managedInstanceName: managedInstance.name
    name: securityAlertPolicy.?name ?? 'Default'
    state: securityAlertPolicy.?state ?? 'Enabled'
    disabledAlerts: securityAlertPolicy.?disabledAlerts ?? []
    emailAccountAdmins: securityAlertPolicy.?emailAccountAdmins ?? true
    emailAddresses: securityAlertPolicy.?emailAddresses ?? []
    retentionDays: securityAlertPolicy.?retentionDays ?? 0
    storageAccountResourceId: securityAlertPolicy.?storageAccountResourceId
  }
}

module miVulnerabilityAssessment './db_vulnerability_assessment.bicep' = if (vulnerabilityAssessment != null) {
  name: '${deployment().name}-mi-vulnerability'
  params: {
    managedInstanceName: managedInstance.name
    name: vulnerabilityAssessment.?name ?? 'default'
    recurringScans: vulnerabilityAssessment.?recurringScans
    storageAccountResourceId: vulnerabilityAssessment.?storageAccountResourceId
    useStorageAccountAccessKey: vulnerabilityAssessment.?useStorageAccountAccessKey ?? false
    createStorageRoleAssignment: vulnerabilityAssessment.?createStorageRoleAssignment ?? false
    managedIdentityPrincipalId: managedInstance.?identity.?principalId
  }
}

module miKeys './db_key.bicep' = [
  for (key, i) in keys: {
    name: '${deployment().name}-mi-key-${i}'
    params: {
      managedInstanceName: managedInstance.name
      name: key.?name
      serverKeyType: key.?serverKeyType ?? 'ServiceManaged'
      uri: key.?uri ?? ''
    }
  }
]

module miEncryptionProtector './db_encryption_protector.bicep' = if (encryptionProtector != null) {
  name: '${deployment().name}-mi-encryption-protector'
  params: {
    managedInstanceName: managedInstance.name
    serverKeyName: encryptionProtector.?serverKeyName
    serverKeyType: encryptionProtector.?serverKeyType ?? 'ServiceManaged'
    autoRotationEnabled: encryptionProtector.?autoRotationEnabled ?? true
  }
}

// Outputs
@description('Nom de l\'instance SQL managée')
output name string = managedInstance.name

@description('ID de l\'instance SQL managée')
output resourceId string = managedInstance.id

@description('Principal ID de l\'identité managée système (si applicable)')
output systemAssignedMIPrincipalId string? = managedInstance.?identity.?principalId

@description('Région de l\'instance SQL managée')
output location string = managedInstance.location
