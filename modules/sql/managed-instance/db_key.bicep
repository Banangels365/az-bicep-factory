// modules/sql/managed-instance/db_key.bicep
// Module pour la configuration d'une clé de serveur pour une instance SQL managée.

targetScope = 'resourceGroup'

@description('Nom de la clé du serveur')
param name string?

@description('Nom de l\'instance SQL managée')
param managedInstanceName string

@description('Type de la clé du serveur pour le protecteur de chiffrement')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

@description('URI de la clé du serveur dans Azure Key Vault (obligatoire si serverKeyType est AzureKeyVault)')
param uri string = ''

// Variable pour générer un nom par défaut basé sur l'URI si le nom n'est pas fourni
var parts = split(uri, '/')
var defaultName = empty(uri) ? 'ServiceManaged' : '${split(parts[2], '.')[0]}_${parts[4]}_${parts[5]}'

// Ressource de l'instance SQL managée existante
resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName
}

// Ressource de la clé du serveur pour l'instance SQL managée
resource key 'Microsoft.Sql/managedInstances/keys@2024-05-01-preview' = {
  name: name ?? defaultName
  parent: managedInstance
  properties: {
    serverKeyType: serverKeyType
    uri: uri
  }
}

// Outputs
@description('Nom de la clé du serveur')
output name string = key.name

@description('ID de la clé du serveur')
output resourceId string = key.id
