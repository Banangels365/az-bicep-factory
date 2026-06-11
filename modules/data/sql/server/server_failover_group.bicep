// modules/data/sql/server/server_failover_group.bicep

/*
  Module : Azure SQL Failover Group Deployment
  Fonction :
    Ce module déploie un Failover Group (FOG) entre un serveur SQL principal
    et un ou plusieurs serveurs partenaires. Il permet :
      - De définir les bases incluses dans le failover group
      - De configurer les serveurs partenaires
      - De définir les endpoints Read/Write et Read-Only
      - De choisir le type de réplication (Geo ou Standby)
      - D’appliquer des tags au Failover Group
*/

targetScope = 'resourceGroup'

@description('Nom du Failover Group à créer.')
param name string

@description('Nom du serveur SQL principal sur lequel le Failover Group sera créé.')
param serverName string

@description('Liste des noms de bases de données à inclure dans le Failover Group.')
param databases array

@description('Liste des IDs des serveurs partenaires participant au Failover Group.')
param partnerServerResourceIds array

@description('Configuration optionnelle du endpoint en lecture seule (read-only).')
param readOnlyEndpoint object?

@description('Configuration obligatoire du endpoint en lecture/écriture (read-write).')
param readWriteEndpoint object

@description('Type de réplication secondaire : Geo ou Standby.')
param secondaryType 'Geo' | 'Standby'

@description('Tags appliqués au Failover Group.')
param tags object = {}

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

resource failoverGroup 'Microsoft.Sql/servers/failoverGroups@2024-05-01-preview' = {
  name: name
  parent: server
  tags: tags
  properties: {
    databases: [for db in databases: resourceId('Microsoft.Sql/servers/databases', serverName, db)]
    partnerServers: [
      for partnerServerResourceId in partnerServerResourceIds: {
        id: partnerServerResourceId
      }
    ]
    readOnlyEndpoint: !empty(readOnlyEndpoint)
      ? {
          failoverPolicy: readOnlyEndpoint!.failoverPolicy
          targetServer: resourceId(resourceGroup().name, 'Microsoft.Sql/servers', readOnlyEndpoint!.targetServer)
        }
      : null
    readWriteEndpoint: readWriteEndpoint
    secondaryType: secondaryType
  }
}

@description('Nom du Failover Group déployé.')
output name string = failoverGroup.name

@description('ID complet de la ressource Failover Group.')
output resourceId string = failoverGroup.id
