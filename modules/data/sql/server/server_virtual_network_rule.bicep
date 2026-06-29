// modules/data/sql/server/server_virtual_network_rule.bicep

/*
  Module : Azure SQL Server Virtual Network Rule
  Fonction :
    Ce module crée ou met à jour une règle d'accès réseau (Virtual Network Rule)
    pour un serveur Azure SQL. Il permet :
      - D'autoriser un subnet spécifique à accéder au serveur SQL
      - De gérer l'option ignoreMissingVnetServiceEndpoint
      - D'appliquer la règle directement sur le serveur SQL existant
*/

targetScope = 'resourceGroup'

@description('Nom de la règle de réseau virtuel à créer.')
param name string

@description('Indique si la règle doit être créée même si le service endpoint SQL n\'est pas activé sur le subnet.')
param ignoreMissingVnetServiceEndpoint bool = false

@description('ID complet de la ressource subnet autorisée à accéder au serveur SQL.')
param virtualNetworkSubnetResourceId string

@description('Nom du serveur SQL existant sur lequel appliquer la règle.')
param serverName string

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

#disable-next-line no-unused-existing-resources
resource auditSettings 'Microsoft.Sql/servers/auditingSettings@2023-08-01' existing = {
  name: 'default'
  parent: server
}

resource virtualNetworkRule 'Microsoft.Sql/servers/virtualNetworkRules@2023-08-01' = {
  name: name
  parent: server
  properties: {
    ignoreMissingVnetServiceEndpoint: ignoreMissingVnetServiceEndpoint
    virtualNetworkSubnetId: virtualNetworkSubnetResourceId
  }
}

@description('Nom de la règle de réseau virtuel créée.')
output name string = virtualNetworkRule.name

@description('ID complet de la ressource Virtual Network Rule.')
output resourceId string = virtualNetworkRule.id
