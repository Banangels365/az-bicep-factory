// modules/sql/managed-instance/db_security_alert_policy.bicep
// Module pour la configuration de la politique d'alerte de sécurité d'une instance SQL managée.

targetScope = 'resourceGroup'

@description('Nom de l\'instance SQL managée')
param managedInstanceName string

@description('Nom de la politique d\'alerte de sécurité')
param name string = 'Default'

@description('État de la politique d\'alerte de sécurité')
@allowed([
  'Enabled'
  'Disabled'
])
param state string = 'Enabled'

@description('Liste des types d\'alertes désactivées')
param disabledAlerts array = []

@description('Envoi d\'alertes aux administrateurs de compte')
param emailAccountAdmins bool = true

@description('Liste des adresses e-mail pour les alertes de sécurité')
param emailAddresses array = []

@description('Nombre de jours de rétention pour les alertes de sécurité')
param retentionDays int = 0

@description('ID de la ressource du compte de stockage pour les alertes de sécurité (optionnel)')
param storageAccountResourceId string?

// Ressource de l'instance SQL managée existante
resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName
}

// Ressource de la politique d'alerte de sécurité
resource securityAlertPolicy 'Microsoft.Sql/managedInstances/securityAlertPolicies@2024-05-01-preview' = {
  name: name
  parent: managedInstance
  properties: {
    state: state
    disabledAlerts: disabledAlerts
    emailAccountAdmins: emailAccountAdmins
    emailAddresses: length(emailAddresses) > 0 ? emailAddresses : null
    retentionDays: retentionDays
    storageAccountAccessKey: !empty(storageAccountResourceId)
      ? listKeys(storageAccountResourceId!, '2023-05-01').keys[0].value
      : null
    storageEndpoint: !empty(storageAccountResourceId)
      ? 'https://${last(split(storageAccountResourceId!, '/'))}.blob.${environment().suffixes.storage}'
      : null
  }
}

// Outputs
@description('Nom de la politique d\'alerte de sécurité')
output name string = securityAlertPolicy.name

@description('ID de la politique d\'alerte de sécurité')
output resourceId string = securityAlertPolicy.id
