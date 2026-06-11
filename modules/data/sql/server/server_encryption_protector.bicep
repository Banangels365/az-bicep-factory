// modules/data/sql/server/server_encryption_protector.bicep

/*
  Module : Azure SQL Server Encryption Protector
  Fonction :
    Ce module configure l’encryption protector d’un serveur Azure SQL.
    Il permet :
      - De définir le type de clé (ServiceManaged ou AzureKeyVault)
      - D’activer ou non la rotation automatique
      - De spécifier le nom de la clé serveur (serverKeyName)
    Le module s’applique sur un serveur SQL existant.
*/

targetScope = 'resourceGroup'

@description('Nom du serveur SQL existant sur lequel appliquer la configuration de chiffrement.')
param sqlServerName string

@description('Nom de la clé serveur (Key Vault key name ou Managed Key name selon le type).')
param serverKeyName string

@description('Active ou désactive la rotation automatique de la clé.')
param autoRotationEnabled bool = true

@description('Type de clé utilisée pour le chiffrement du serveur SQL.')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

resource sqlServer 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: sqlServerName
}

resource encryptionProtector 'Microsoft.Sql/servers/encryptionProtector@2023-08-01' = {
  name: 'current'
  parent: sqlServer
  properties: {
    serverKeyType: serverKeyType
    autoRotationEnabled: autoRotationEnabled
    serverKeyName: serverKeyName
  }
}

@description('Nom de l’encryption protector configuré.')
output name string = encryptionProtector.name

@description('ID complet de la ressource encryption protector.')
output resourceId string = encryptionProtector.id
