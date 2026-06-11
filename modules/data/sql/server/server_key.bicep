// modules/data/sql/server/server_key.bicep

/*
  Module : Azure SQL Server Key (Customer-Managed Key)
  Fonction :
    Ce module configure une clé SQL Server (server key) pour un serveur Azure SQL.
    Il permet :
      - D’utiliser une clé gérée par le client (CMK) via un URI Key Vault ou Managed HSM
      - De générer automatiquement un nom de clé basé sur l’URI si aucun nom n’est fourni
      - De définir le type de clé (AzureKeyVault ou ServiceManaged)
    Le module s’applique sur un serveur SQL existant.
*/

targetScope = 'resourceGroup'

@description('Nom explicite de la clé SQL. Si non fourni, un nom sera généré automatiquement à partir de l’URI.')
param name string?

@description('Nom du serveur SQL sur lequel la clé sera configurée.')
param serverName string

@description('Type de clé utilisée pour le chiffrement du serveur SQL.')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

@description('URI complet de la clé dans Key Vault ou Managed HSM. Exemple : https://myvault.vault.azure.net/keys/mykey/version')
param uri string = ''

var splittedKeyUri = split(uri, '/')

var serverKeyName = empty(uri)
  ? 'ServiceManaged'
  : '${split(splittedKeyUri[2], '.')[0]}_${splittedKeyUri[4]}_${splittedKeyUri[5]}'

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

resource key 'Microsoft.Sql/servers/keys@2023-08-01' = {
  name: name ?? serverKeyName
  parent: server
  properties: {
    serverKeyType: serverKeyType
    uri: uri
  }
}

@description('Nom de la clé SQL créée ou mise à jour.')
output name string = key.name

@description('ID complet de la ressource de clé SQL.')
output resourceId string = key.id
