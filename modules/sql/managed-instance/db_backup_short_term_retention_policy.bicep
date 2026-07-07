// modules/sql/managed-instance/db_backup_short_term_retention_policy.bicep
// Module pour la politique de rétention à court terme des sauvegardes d'une base de données SQL managée.

targetScope = 'resourceGroup'

@description('Nom de la politique de rétention à court terme des sauvegardes')
param name string = 'default'

@description('Nom de la base de données SQL')
param databaseName string

@description('Nom de l\'instance SQL managée')
param managedInstanceName string

@description('Nombre de jours de rétention')
param retentionDays int = 90

// Ressource de l'instance SQL managée existante
resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName

  resource database 'databases@2024-05-01-preview' existing = {
    name: databaseName
  }
}

// Ressource de rétention à court terme des sauvegardes pour la base de données
resource shortRetention 'Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies@2024-05-01-preview' = {
  name: name
  parent: managedInstance::database
  properties: {
    retentionDays: retentionDays
  }
}

// Outputs
@description('Nom de la politique de rétention à court terme des sauvegardes')
output name string = shortRetention.name

@description('ID de la politique de rétention à court terme des sauvegardes')
output resourceId string = shortRetention.id
