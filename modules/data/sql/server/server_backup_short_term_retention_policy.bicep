// modules/data/sql/server/server_backup_short_term_retention_policy.bicep
// Ce module permet de configurer la politique de rétention à court terme des sauvegardes pour une base de données SQL.

targetScope = 'resourceGroup'

@description('Nom du serveur SQL.')
param serverName string

@description('Nom de la base de données.')
param databaseName string

@description('Intervalle de sauvegarde différentielle en heures. Par défaut, cela est défini sur 24 heures.')
param diffBackupIntervalInHours int = 24

@description('Nombre de jours de rétention des sauvegardes à court terme. Par défaut, cela est défini sur 7 jours.')
param retentionDays int = 90

// checkov:skip=CKV_AZURE_23: Existing SQL server, auditing configured elsewhere
// checkov:skip=CKV_AZURE_24: Existing SQL server, retention configured elsewhere
resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName

  resource database 'databases@2023-08-01' existing = {
    name: databaseName
  }
}

#disable-next-line no-unused-existing-resources
resource auditSettings 'Microsoft.Sql/servers/auditingSettings@2023-08-01' existing = {
  name: 'default'
  parent: server
}

resource policy 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2023-08-01' = {
  name: 'default'
  parent: server::database
  properties: {
    diffBackupIntervalInHours: server::database.sku.tier == 'Hyperscale' ? null : diffBackupIntervalInHours
    retentionDays: retentionDays
  }
}

@description('Nom de la politique de rétention à court terme des sauvegardes.')
output name string = policy.name

@description('ID de la ressource de la politique de rétention à court terme des sauvegardes.')
output resourceId string = policy.id
