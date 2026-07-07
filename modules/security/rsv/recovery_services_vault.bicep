// modules/security/rsv/recovery_services_vault.bicep
// Azure Recovery Services Vault pour la sauvegarde et la reprise après sinistre.

targetScope = 'resourceGroup'

@description('Nom du Recovery Services Vault.')
param vaultName string

@description('Région de déploiement. Par défaut, la région du resource group.')
param location string = resourceGroup().location

@description('Tags à appliquer aux ressources.')
param tags object = {}

@description('Type d\'identité managée à affecter au vault.')
@allowed([
  'None'
  'SystemAssigned'
])
param managedIdentityType string = 'SystemAssigned'

@description('État d\'accès réseau public du vault.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('État d\'immuabilité du coffre. Locked est irréversible.')
@allowed([
  'Disabled'
  'Unlocked'
  'Locked'
])
param immutabilityState string = 'Disabled'

@description('Paramètres de redondance du vault.')
param redundancySettings object = {
  standardTierStorageRedundancy: 'GeoRedundant' // Valeurs possibles : GeoRedundant, LocallyRedundant, ZoneRedundant
  crossRegionRestore: 'Disabled' // Valeurs possibles : Enabled, Disabled
}

@description('Paramètres de restauration. Exemple : crossSubscriptionRestoreState.')
param restoreSettings object = {}

@description('Paramètres de monitoring du vault, notamment les alertes Azure Monitor et classiques.')
param monitoringSettings object = {}

@description('Paramètres de soft delete du vault.')
param softDeleteSettings object = {
  softDeleteState: 'Enabled'
  softDeleteRetentionPeriodInDays: 14
  enhancedSecurityState: 'Enabled'
}

@description('Configuration de source scan des paramètres de sécurité du vault.')
param sourceScanConfiguration object = {}

@description('Liste des opérations protégées par Resource Guard / MUA.')
param resourceGuardOperationRequests array = []

@description('Configuration de chiffrement CMK. Non fournie par défaut pour garder le module simple.')
param customerManagedKey object = {}

@description('Configuration du backup config du vault.')
param backupConfig object = {}

@description('Paramètres d\'alertes de réplication Site Recovery.')
param replicationAlertSettings object = {}

@description('Liste des politiques de sauvegarde à créer dans le vault.')
param backupPolicies array = []

@description('Liste des politiques de réplication Site Recovery à créer dans le vault.')
param replicationPolicies array = []

@description('Activer la création de private endpoints pour le vault.')
param enablePrivateEndpoint bool = false

@description('ID du sous-réseau du private endpoint.')
param privateEndpointSubnetId string = ''

@description('Liste des IDs des zones DNS privées à associer au private endpoint.')
param privateDnsZoneIds array = []

@description('Nom du private endpoint. Si vide, une valeur par défaut est calculée.')
param privateEndpointName string = ''

@description('Groupe de sous-ressource Private Link à exposer. AzureBackup et AzureSiteRecovery sont les cas les plus fréquents.')
@allowed([
  'AzureBackup'
  'AzureSiteRecovery'
])
param privateEndpointService string = 'AzureBackup'

@description('Activer les diagnostic settings sur le vault.')
param enableDiagnostics bool = false

@description('Nom des diagnostic settings.')
param diagnosticSettingsName string = ''

@description('ID du Log Analytics Workspace cible pour les diagnostics.')
param logAnalyticsWorkspaceId string = ''

@description('ID du Storage Account cible pour les diagnostics.')
param diagnosticStorageAccountId string = ''

@description('ID de la règle d\'autorisation Event Hub cible pour les diagnostics.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Nom de l\'Event Hub cible pour les diagnostics.')
param diagnosticEventHubName string = ''

// Variables
var identity = managedIdentityType == 'SystemAssigned' ? { type: 'SystemAssigned' } : { type: 'None' }

var resolvedPrivateEndpointName = !empty(privateEndpointName) ? privateEndpointName : '${vaultName}-pe'

var resolvedDiagnosticSettingsName = !empty(diagnosticSettingsName)
  ? diagnosticSettingsName
  : '${vaultName}-diagnostics'

var backupConfigName = backupConfig.?name ?? 'vaultconfig'

// Création du Recovery Services Vault
resource vault 'Microsoft.RecoveryServices/vaults@2025-08-01' = {
  name: vaultName
  location: location
  tags: tags
  identity: identity
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    publicNetworkAccess: publicNetworkAccess

    monitoringSettings: !empty(monitoringSettings)
      ? {
          azureMonitorAlertSettings: !empty(monitoringSettings.?azureMonitorAlertSettings)
            ? {
                alertsForAllFailoverIssues: monitoringSettings.azureMonitorAlertSettings.?alertsForAllFailoverIssues ?? 'Enabled'
                alertsForAllJobFailures: monitoringSettings.azureMonitorAlertSettings.?alertsForAllJobFailures ?? 'Enabled'
                alertsForAllReplicationIssues: monitoringSettings.azureMonitorAlertSettings.?alertsForAllReplicationIssues ?? 'Enabled'
              }
            : null
          classicAlertSettings: !empty(monitoringSettings.?classicAlertSettings)
            ? {
                alertsForCriticalOperations: monitoringSettings.classicAlertSettings.?alertsForCriticalOperations ?? 'Enabled'
                emailNotificationsForSiteRecovery: monitoringSettings.classicAlertSettings.?emailNotificationsForSiteRecovery ?? 'Enabled'
              }
            : null
        }
      : null

    securitySettings: {
      immutabilitySettings: immutabilityState != 'Disabled'
        ? {
            state: immutabilityState
          }
        : null
      softDeleteSettings: !empty(softDeleteSettings)
        ? {
            softDeleteState: softDeleteSettings.?softDeleteState ?? 'Enabled'
            softDeleteRetentionPeriodInDays: softDeleteSettings.?softDeleteRetentionPeriodInDays ?? 14
            enhancedSecurityState: softDeleteSettings.?enhancedSecurityState ?? 'Enabled'
          }
        : null
      sourceScanConfiguration: !empty(sourceScanConfiguration) ? sourceScanConfiguration : null
    }

    redundancySettings: !empty(redundancySettings)
      ? {
          standardTierStorageRedundancy: redundancySettings.standardTierStorageRedundancy
          crossRegionRestore: redundancySettings.?crossRegionRestore ?? 'Disabled'
        }
      : null

    restoreSettings: !empty(restoreSettings) ? restoreSettings : null

    resourceGuardOperationRequests: !empty(resourceGuardOperationRequests) ? resourceGuardOperationRequests : null

    encryption: !empty(customerManagedKey) ? customerManagedKey : null
  }
}

// Backup configuration du vault.
// Ce bloc couvre les paramètres de backupConfig AVM sans nécessiter un 4e fichier dédié.
resource vaultBackupConfig 'Microsoft.RecoveryServices/vaults/backupconfig@2025-08-01' = if (!empty(backupConfig)) {
  parent: vault
  name: backupConfigName
  properties: {
    enhancedSecurityState: backupConfig.?enhancedSecurityState
    resourceGuardOperationRequests: backupConfig.?resourceGuardOperationRequests ?? []
    softDeleteFeatureState: backupConfig.?softDeleteFeatureState
    storageModelType: backupConfig.?storageModelType ?? redundancySettings.?standardTierStorageRedundancy
    storageType: backupConfig.?storageType ?? redundancySettings.?standardTierStorageRedundancy
    storageTypeState: backupConfig.?storageTypeState ?? 'Locked'
    isSoftDeleteFeatureStateEditable: backupConfig.?isSoftDeleteFeatureStateEditable ?? true
  }
}

// Paramètres d'alertes Site Recovery.
// Ce bloc couvre la logique du module AVM replication alert setting.
resource vaultReplicationAlertSettings 'Microsoft.RecoveryServices/vaults/replicationAlertSettings@2025-08-01' = if (!empty(replicationAlertSettings)) {
  parent: vault
  name: replicationAlertSettings.?name ?? 'defaultAlertSetting'
  properties: {
    customEmailAddresses: replicationAlertSettings.?customEmailAddresses ?? []
    locale: replicationAlertSettings.?locale
    sendToOwners: replicationAlertSettings.?sendToOwners ?? 'Send'
  }
}

module backupPoliciesModule './backup_policy.bicep' = [
  for (policy, index) in backupPolicies: {
    name: 'backup-policy-${uniqueString(vault.name, policy.name, string(index))}'
    params: {
      recoveryVaultName: vault.name
      name: policy.name
      properties: policy.properties
    }
  }
]

module replicationPoliciesModule './replication_policy.bicep' = [
  for (policy, index) in replicationPolicies: {
    name: 'replication-policy-${uniqueString(vault.name, policy.name, string(index))}'
    params: {
      recoveryVaultName: vault.name
      name: policy.name
      appConsistentFrequencyInMinutes: policy.?appConsistentFrequencyInMinutes ?? 60
      crashConsistentFrequencyInMinutes: policy.?crashConsistentFrequencyInMinutes ?? 5
      multiVmSyncStatus: policy.?multiVmSyncStatus ?? 'Enable'
      recoveryPointHistory: policy.?recoveryPointHistory ?? 1440
    }
  }
]

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-10-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId)) {
  name: resolvedPrivateEndpointName
  location: location
  tags: tags
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${resolvedPrivateEndpointName}-connection'
        properties: {
          privateLinkServiceId: vault.id
          groupIds: [
            privateEndpointService
          ]
        }
      }
    ]
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-10-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(privateDnsZoneIds)) {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      for (zoneId, index) in privateDnsZoneIds: {
        name: 'dns-zone-${index + 1}'
        properties: {
          privateDnsZoneId: zoneId
        }
      }
    ]
  }
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && (!empty(logAnalyticsWorkspaceId) || !empty(diagnosticStorageAccountId) || !empty(diagnosticEventHubAuthorizationRuleId))) {
  scope: vault
  name: resolvedDiagnosticSettingsName
  properties: {
    workspaceId: !empty(logAnalyticsWorkspaceId) ? logAnalyticsWorkspaceId : null
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId)
      ? diagnosticEventHubAuthorizationRuleId
      : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// outputs
@description('ID du Recovery Services Vault.')
output vaultId string = vault.id

@description('Nom du Recovery Services Vault.')
output vaultName string = vault.name

@description('Localisation du Recovery Services Vault.')
output vaultLocation string = vault.location

@description('ID principal de l\'identité système du vault, si activée.')
output principalId string = managedIdentityType == 'SystemAssigned' ? vault.identity.principalId : ''

@description('ID de ressource du backup config du vault.')
output backupConfigId string = !empty(backupConfig) ? vaultBackupConfig.id : ''

@description('ID de ressource du paramètre d\'alerte de réplication.')
output replicationAlertSettingId string = !empty(replicationAlertSettings) ? vaultReplicationAlertSettings.id : ''

@description('Noms des politiques de sauvegarde créées.')
output backupPolicyNames array = [for (policy, i) in backupPolicies: backupPoliciesModule[i].outputs.name]

@description('IDs des politiques de sauvegarde créées.')
output backupPolicyIds array = [for (policy, i) in backupPolicies: backupPoliciesModule[i].outputs.resourceId]

@description('Noms des politiques de réplication créées.')
output replicationPolicyNames array = [
  for (policy, i) in replicationPolicies: replicationPoliciesModule[i].outputs.name
]

@description('IDs des politiques de réplication créées.')
output replicationPolicyIds array = [
  for (policy, i) in replicationPolicies: replicationPoliciesModule[i].outputs.resourceId
]

@description('ID du Private Endpoint créé, si activé.')
output privateEndpointId string = (enablePrivateEndpoint && !empty(privateEndpointSubnetId)) ? privateEndpoint.id : ''
