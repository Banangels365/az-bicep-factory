param vaults_RSV_DEMO_AZFS_AzBackupLRS_name string = 'RSV-DEMO-AZFS-AzBackupLRS'

resource vaults_RSV_DEMO_AZFS_AzBackupLRS_name_resource 'Microsoft.RecoveryServices/vaults@2025-02-01' = {
  name: vaults_RSV_DEMO_AZFS_AzBackupLRS_name
  location: 'canadacentral'
  tags: {
    Projet: 'DEMO AZFS'
    'Create on': '2025-11-18'
    'Create by': 'Banangels'
  }
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    securitySettings: {
      immutabilitySettings: {
        state: 'Unlocked'
      }
      softDeleteSettings: {
        softDeleteRetentionPeriodInDays: 14
        softDeleteState: 'Enabled'
        enhancedSecurityState: 'Enabled'
      }
      sourceScanConfiguration: {
        state: 'Disabled'
      }
    }
    redundancySettings: {
      standardTierStorageRedundancy: 'LocallyRedundant'
      crossRegionRestore: 'Disabled'
    }
    publicNetworkAccess: 'Enabled'
    restoreSettings: {
      crossSubscriptionRestoreSettings: {
        crossSubscriptionRestoreState: 'Enabled'
      }
    }
  }
}

resource vaults_RSV_DEMO_AZFS_AzBackupLRS_name_DefaultPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-02-01' = {
  parent: vaults_RSV_DEMO_AZFS_AzBackupLRS_name_resource
  name: 'DefaultPolicy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V1'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2025-11-19T04:30:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2025-11-19T04:30:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'UTC'
    protectedItemsCount: 0
  }
}

resource vaults_RSV_DEMO_AZFS_AzBackupLRS_name_DEMO_FileShare_Backup_Policy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-02-01' = {
  parent: vaults_RSV_DEMO_AZFS_AzBackupLRS_name_resource
  name: 'DEMO-FileShare-Backup-Policy'
  properties: {
    backupManagementType: 'AzureStorage'
    workLoadType: 'AzureFileShare'
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2025-11-18T22:00:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2025-11-18T22:00:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    timeZone: 'Eastern Standard Time'
    protectedItemsCount: 0
  }
}

resource vaults_RSV_DEMO_AZFS_AzBackupLRS_name_DEMO_VM_Backup_Policy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-02-01' = {
  parent: vaults_RSV_DEMO_AZFS_AzBackupLRS_name_resource
  name: 'DEMO-VM-Backup-Policy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V2'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicyV2'
      scheduleRunFrequency: 'Hourly'
      hourlySchedule: {
        interval: 4
        scheduleWindowStartTime: '2025-11-18T23:00:00Z'
        scheduleWindowDuration: 24
      }
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2025-11-18T23:00:00Z'
        ]
        retentionDuration: {
          count: 14
          durationType: 'Days'
        }
      }
      weeklySchedule: {
        daysOfTheWeek: [
          'Sunday'
        ]
        retentionTimes: [
          '2025-11-18T23:00:00Z'
        ]
        retentionDuration: {
          count: 4
          durationType: 'Weeks'
        }
      }
      monthlySchedule: {
        retentionScheduleFormatType: 'Weekly'
        retentionScheduleWeekly: {
          daysOfTheWeek: [
            'Sunday'
          ]
          weeksOfTheMonth: [
            'First'
          ]
        }
        retentionTimes: [
          '2025-11-18T23:00:00Z'
        ]
        retentionDuration: {
          count: 6
          durationType: 'Months'
        }
      }
    }
    tieringPolicy: {
      ArchivedRP: {
        tieringMode: 'DoNotTier'
        duration: 0
        durationType: 'Invalid'
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'Eastern Standard Time'
    protectedItemsCount: 0
  }
}

resource vaults_RSV_DEMO_AZFS_AzBackupLRS_name_EnhancedPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-02-01' = {
  parent: vaults_RSV_DEMO_AZFS_AzBackupLRS_name_resource
  name: 'EnhancedPolicy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V2'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicyV2'
      scheduleRunFrequency: 'Hourly'
      hourlySchedule: {
        interval: 4
        scheduleWindowStartTime: '2025-11-19T08:00:00Z'
        scheduleWindowDuration: 12
      }
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2025-11-19T08:00:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'UTC'
    protectedItemsCount: 0
  }
}

resource vaults_RSV_DEMO_AZFS_AzBackupLRS_name_HourlyLogBackup 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-02-01' = {
  parent: vaults_RSV_DEMO_AZFS_AzBackupLRS_name_resource
  name: 'HourlyLogBackup'
  properties: {
    backupManagementType: 'AzureWorkload'
    workLoadType: 'SQLDataBase'
    settings: {
      timeZone: 'UTC'
      issqlcompression: false
      isCompression: false
    }
    subProtectionPolicy: [
      {
        policyType: 'Full'
        schedulePolicy: {
          schedulePolicyType: 'SimpleSchedulePolicy'
          scheduleRunFrequency: 'Daily'
          scheduleRunTimes: [
            '2025-11-19T04:30:00Z'
          ]
          scheduleWeeklyFrequency: 0
        }
        retentionPolicy: {
          retentionPolicyType: 'LongTermRetentionPolicy'
          dailySchedule: {
            retentionTimes: [
              '2025-11-19T04:30:00Z'
            ]
            retentionDuration: {
              count: 30
              durationType: 'Days'
            }
          }
        }
      }
      {
        policyType: 'Log'
        schedulePolicy: {
          schedulePolicyType: 'LogSchedulePolicy'
          scheduleFrequencyInMins: 60
        }
        retentionPolicy: {
          retentionPolicyType: 'SimpleRetentionPolicy'
          retentionDuration: {
            count: 30
            durationType: 'Days'
          }
        }
      }
    ]
    protectedItemsCount: 0
  }
}

resource vaults_RSV_DEMO_AZFS_AzBackupLRS_name_defaultAlertSetting 'Microsoft.RecoveryServices/vaults/replicationAlertSettings@2025-02-01' = {
  parent: vaults_RSV_DEMO_AZFS_AzBackupLRS_name_resource
  name: 'defaultAlertSetting'
  properties: {
    sendToOwners: 'DoNotSend'
    customEmailAddresses: []
  }
}

resource vaults_RSV_DEMO_AZFS_AzBackupLRS_name_default 'Microsoft.RecoveryServices/vaults/replicationVaultSettings@2025-02-01' = {
  parent: vaults_RSV_DEMO_AZFS_AzBackupLRS_name_resource
  name: 'default'
  properties: {}
}
