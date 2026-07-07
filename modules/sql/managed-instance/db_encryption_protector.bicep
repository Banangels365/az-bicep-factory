// modules/sql/managed-instance/db_encryption_protector.bicep
// Module pour la configuration du protecteur de chiffrement d'une instance SQL managée.

targetScope = 'resourceGroup'

@description('Nom de l\'instance SQL managée')
param managedInstanceName string

@description('Nom de la clé du serveur pour le protecteur de chiffrement')
param serverKeyName string

@description('Activation de la rotation automatique des clés')
param autoRotationEnabled bool = true

@description('Type de la clé du serveur pour le protecteur de chiffrement')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

// Ressource de l'instance SQL managée existante
resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName
}

// Ressource du protecteur de chiffrement pour l'instance SQL managée
resource encryptionProtector 'Microsoft.Sql/managedInstances/encryptionProtector@2024-05-01-preview' = {
  name: 'current'
  parent: managedInstance
  properties: {
    serverKeyType: serverKeyType
    autoRotationEnabled: autoRotationEnabled
    serverKeyName: serverKeyName
  }
}

// Outputs
@description('Nom du protecteur de chiffrement')
output name string = encryptionProtector.name

@description('ID du protecteur de chiffrement')
output resourceId string = encryptionProtector.id
