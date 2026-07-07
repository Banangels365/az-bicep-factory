// modules/sql/managed-instance/db_backup_long_term_retention_policy.bicep
// Module pour la politique de rétention à long terme des sauvegardes d'une base de données SQL managée.

targetScope = 'resourceGroup'

@description('Nom de la politique de rétention à long terme des sauvegardes')
param name string = 'default'

@description('Nom de la base de données SQL')
param databaseName string

@description('Nom de l\'instance SQL managée')
param managedInstanceName string

@description('Niveau d\'accès pour les sauvegardes à long terme (Archive ou Hot)')
@allowed([
  'Archive'
  'Hot'
])
param backupStorageAccessTier string = 'Hot'

@description('Semaine de l\'année pour la rétention hebdomadaire (1-52)')
param weekOfYear int = 5

@description('Rétention hebdomadaire')
param weeklyRetention string = 'P1M'

@description('Rétention mensuelle')
param monthlyRetention string = 'P1Y'

@description('Rétention annuelle')
param yearlyRetention string = 'P5Y'

// Ressource de l'instance SQL managée existante
resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName

  resource database 'databases@2024-05-01-preview' existing = {
    name: databaseName
  }
}

// Ressource de rétention à long terme des sauvegardes pour la base de données
resource longRetention 'Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies@2024-05-01-preview' = {
  name: name
  parent: managedInstance::database
  properties: {
    backupStorageAccessTier: backupStorageAccessTier
    monthlyRetention: monthlyRetention
    weeklyRetention: weeklyRetention
    weekOfYear: weekOfYear
    yearlyRetention: yearlyRetention
  }
}

// Outputs
@description('Nom de la politique de rétention à long terme des sauvegardes')
output name string = longRetention.name

@description('ID de la politique de rétention à long terme des sauvegardes')
output resourceId string = longRetention.id
