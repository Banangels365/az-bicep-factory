// modules/data/sql/server/server_firewall_rule.bicep

/*
  Module : Azure SQL Server Firewall Rule
  Fonction :
    Ce module crée ou met à jour une règle de pare-feu (firewall rule)
    sur un serveur Azure SQL existant. Il permet :
      - De définir une plage d’adresses IP autorisées
      - D’ouvrir l’accès à une IP unique ou à un range
      - D’appliquer la règle directement sur le serveur SQL ciblé
*/

targetScope = 'resourceGroup'

@description('Nom de la règle de pare-feu à créer.')
param name string

@description('Adresse IP de fin de la plage autorisée. Par défaut : 0.0.0.0.')
param endIpAddress string = '0.0.0.0'

@description('Adresse IP de début de la plage autorisée. Par défaut : 0.0.0.0.')
param startIpAddress string = '0.0.0.0'

@description('Nom du serveur SQL existant sur lequel appliquer la règle de pare-feu.')
param serverName string

// checkov:skip=CKV_AZURE_23: Existing SQL server, auditing configured elsewhere
// checkov:skip=CKV_AZURE_24: Existing SQL server, retention configured elsewhere
resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

resource firewallRule 'Microsoft.Sql/servers/firewallRules@2023-08-01' = {
  name: name
  parent: server
  properties: {
    endIpAddress: endIpAddress
    startIpAddress: startIpAddress
  }
}

@description('Nom de la règle de pare-feu créée.')
output name string = firewallRule.name

@description('ID complet de la ressource firewall rule.')
output resourceId string = firewallRule.id
