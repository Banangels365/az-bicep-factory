// modules/security/rsv/recovery_services_vault.bicep
// Azure Recovery Services Vault pour la sauvegarde et la reprise après sinistre

@description('Nom du Recovery Services Vault')
param vaultName string

@description('Région de déploiement')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('Type de réplication du stockage')
@allowed([
  'LocallyRedundant' // LRS — même datacenter
  'ZoneRedundant' // ZRS — zones dans la même région
  'GeoRedundant' // GRS — région secondaire (recommandé production)
])
param storageType string = 'GeoRedundant'

@description('Activer la restauration inter-régions — nécessite storageType: GeoRedundant')
param enableCrossRegionRestore bool = false // ATTENTION : nécessite storageType: GeoRedundant et peut entraîner des coûts supplémentaires en cas de restauration inter-régions

@description('État d\'immuabilité du vault. ATTENTION : une fois passé à \'Locked\', ce paramètre est irréversible et ne peut pas être désactivé même par un administrateur.')
@allowed([
  'Disabled'
  'Unlocked' // activé mais révocable
  'Locked' // activé et irrévocable — ATTENTION : irréversible
])
param immutabilityState string = 'Disabled'

@description('Activer la suppression réversible des sauvegardes')
param enableSoftDelete bool = true

@description('Durée de rétention de la suppression réversible en jours')
@minValue(14)
@maxValue(180)
param softDeleteRetentionDays int = 14

@description('Activer l\'authentification multi-facteur pour les opérations critiques (MUA)')
param enableMultiUserAuthorization bool = false

@description('Activer l\'accès réseau public')
param publicNetworkAccess bool = false

@description('Politiques de sauvegarde à créer')
param backupPolicies array = []

@description('Activer le Private Endpoint')
param enablePrivateEndpoint bool = false

@description('ID du sous-réseau pour le Private Endpoint')
param privateEndpointSubnetId string = ''

@description('ID de la zone DNS privée pour le vault (privatelink.{region}.backup.windowsazure.com)')
param privateDnsZoneIdVault string = ''

@description('Tags à appliquer aux ressources')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

// Variables
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// Recovery Services Vault
resource vault 'Microsoft.RecoveryServices/vaults@2024-01-01' = {
  name: vaultName
  location: resolvedLocation
  tags: tags
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: union(
    {
      publicNetworkAccess: publicNetworkAccess ? 'Enabled' : 'Disabled'
    },
    immutabilityState != 'Disabled'
      ? {
          immutabilitySettings: { immutabilityState: immutabilityState }
        }
      : {}
  )
}

// Configuration de sécurité du vault
resource vaultSecurityConfig 'Microsoft.RecoveryServices/vaults/backupconfig@2023-06-01' = {
  parent: vault
  name: 'vaultconfig'
  properties: union(
    {
      storageType: storageType
      crossRegionRestoreFlag: enableCrossRegionRestore
      softDeleteFeatureState: enableSoftDelete ? 'Enabled' : 'Disabled'
    },
    enableSoftDelete
      ? {
          softDeleteRetentionPeriodInDays: softDeleteRetentionDays
        }
      : {},
    enableMultiUserAuthorization
      ? {
          resourceGuardOperationRequests: [
            'Microsoft.RecoveryServices/vaults/backupSecurityPIN/action'
            'Microsoft.RecoveryServices/vaults/backupconfig/write'
          ]
        }
      : {}
  )
}

// Politiques de sauvegarde
// Chaque entrée dans backupPolicies doit avoir :
//   name, workloadType (AzureIaasVM / AzureStorage / AzureWorkload)
//   Pour IaasVM : retentionDays, scheduleRunTimes (array de timestamps UTC)
//   Optionnels : weeklyRetentionDays, monthlyRetentionMonths, yearlyRetentionYears
resource backupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-06-01' = [
  for policy in backupPolicies: {
    parent: vault
    name: policy.name
    properties: policy.workloadType == 'AzureIaasVM'
      ? {
          backupManagementType: 'AzureIaasVM'
          instantRpRetentionRangeInDays: policy.?instantRpRetentionDays ?? 2
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: policy.scheduleRunTimes
          }
          retentionPolicy: {
            retentionPolicyType: 'LongTermRetentionPolicy'
            dailySchedule: {
              retentionTimes: policy.scheduleRunTimes
              retentionDuration: {
                count: policy.?retentionDays ?? 30 // 30 jours par défaut
                durationType: 'Days'
              }
            }
          }
        }
      : policy.workloadType == 'AzureStorage'
          ? {
              backupManagementType: 'AzureStorage'
              workLoadType: 'AzureFileShare'
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunFrequency: 'Daily'
                scheduleRunTimes: policy.scheduleRunTimes
              }
              retentionPolicy: {
                retentionPolicyType: 'SimpleRetentionPolicy'
                retentionDuration: {
                  count: policy.retentionDays
                  durationType: 'Days'
                }
              }
            }
          : {
              backupManagementType: 'AzureWorkload'
              workLoadType: policy.?workloadSubType ?? 'SQLDataBase'
              settings: {
                timeZone: policy.?timeZone ?? 'Eastern Standard Time'
                isCompression: false
              }
              subProtectionPolicy: [
                {
                  policyType: 'Full'
                  schedulePolicy: {
                    schedulePolicyType: 'SimpleSchedulePolicy'
                    scheduleRunFrequency: 'Weekly'
                    scheduleRunDays: policy.?fullBackupDays ?? ['Sunday']
                    scheduleRunTimes: policy.scheduleRunTimes
                  }
                  retentionPolicy: {
                    retentionPolicyType: 'LongTermRetentionPolicy'
                    weeklySchedule: {
                      daysOfTheWeek: policy.?fullBackupDays ?? ['Sunday']
                      retentionTimes: policy.scheduleRunTimes
                      retentionDuration: {
                        count: policy.?retentionDays ?? 30 // 30 jours par défaut
                        durationType: 'Weeks'
                      }
                    }
                  }
                }
                {
                  policyType: 'Log'
                  schedulePolicy: {
                    schedulePolicyType: 'LogSchedulePolicy'
                    scheduleFrequencyInMins: policy.?logBackupFrequencyMins ?? 60
                  }
                  retentionPolicy: {
                    retentionPolicyType: 'SimpleRetentionPolicy'
                    retentionDuration: {
                      count: policy.?logRetentionDays ?? 30
                      durationType: 'Days'
                    }
                  }
                }
              ]
            }
  }
]

// Private Endpoint
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(privateDnsZoneIdVault)) {
  name: '${vaultName}-pe'
  location: resolvedLocation
  tags: tags
  properties: {
    subnet: { id: privateEndpointSubnetId }
    privateLinkServiceConnections: [
      {
        name: '${vaultName}-pe-connection'
        properties: {
          privateLinkServiceId: vault.id
          groupIds: ['AzureBackup']
        }
      }
    ]
  }
}

// Private DNS Zone Group
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(privateDnsZoneIdVault)) {
  parent: privateEndpoint
  name: 'vault-dns-zone-group'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'vault-config'
        properties: { privateDnsZoneId: privateDnsZoneIdVault }
      }
    ]
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: vault
  name: '${vaultName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
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

// Outputs
@description('ID du Recovery Services Vault')
output vaultId string = vault.id

@description('Nom du Recovery Services Vault')
output vaultName string = vault.name

@description('ID principal du vault (System-Assigned MI)')
output principalId string = vault.identity.principalId

@description('Noms des politiques de sauvegarde créées')
output backupPolicyNames array = [for (policy, i) in backupPolicies: backupPolicy[i].name]

@description('IDs des politiques de sauvegarde créées')
output backupPolicyIds array = [for (policy, i) in backupPolicies: backupPolicy[i].id]

@description('ID du Private Endpoint')
output privateEndpointId string = (enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(privateDnsZoneIdVault))
  ? privateEndpoint.id
  : ''
