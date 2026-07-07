// modules/sql/server/server_backup_long_term_retention_policy.bicep
// Ce module permet de configurer la politique de rétention à long terme des sauvegardes pour une base de données SQL.

targetScope = 'resourceGroup'

@description('Nom du serveur SQL.')
param serverName string

@description('Nom de la base de données.')
param databaseName string

@description('Période de rétention mensuelle des sauvegardes. Peut être null pour désactiver la rétention mensuelle.')
param monthlyRetention string?

@description('Période de rétention hebdomadaire des sauvegardes. Peut être null pour désactiver la rétention hebdomadaire.')
param weeklyRetention string?

@description('Numéro de la semaine de l\'année pour la rétention hebdomadaire des sauvegardes.')
param weekOfYear int = 1

@description('Période de rétention annuelle des sauvegardes. Peut être null pour désactiver la rétention annuelle.')
param yearlyRetention string?

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName

  resource database 'databases@2023-08-01' existing = {
    name: databaseName
  }
}

resource policy 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2023-08-01' = {
  name: 'default'
  parent: server::database
  properties: {
    monthlyRetention: monthlyRetention
    weeklyRetention: weeklyRetention
    weekOfYear: weekOfYear
    yearlyRetention: yearlyRetention
  }
}

@description('Nom de la politique de rétention à long terme des sauvegardes.')
output name string = policy.name

@description('ID de la ressource de la politique de rétention à long terme des sauvegardes.')
output resourceId string = policy.id
