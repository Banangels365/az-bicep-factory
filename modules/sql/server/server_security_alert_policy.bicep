// modules/sql/server/server_security_alert_policy.bicep

/*
  Module : Azure SQL Server Security Alert Policy
  Fonction :
    Ce module configure la politique d'alertes de sécurité (Threat Detection)
    d'un serveur Azure SQL. Il permet :
      - D'activer ou désactiver la politique
      - De définir les alertes à désactiver
      - De configurer les notifications par email
      - De définir la durée de rétention des logs
      - D'envoyer les logs vers un compte de stockage
*/

targetScope = 'resourceGroup'

@description('Nom du serveur SQL sur lequel appliquer la politique d\'alertes de sécurité.')
param serverName string

@description('Nom de la politique d\'alertes. Par défaut : "Default".')
param name string = 'Default'

@description('État de la politique d\'alertes (Enabled ou Disabled).')
@allowed([
  'Enabled'
  'Disabled'
])
param state string = 'Enabled'

@description('Liste des alertes à désactiver (ex. Sql_Injection, Data_Exfiltration).')
param disabledAlerts array = []

@description('Indique si les administrateurs du serveur doivent recevoir les alertes par email.')
param emailAccountAdmins bool = true

@description('Liste d\'adresses email supplémentaires à notifier.')
param emailAddresses array = []

@description('Durée de rétention des logs en jours. 0 = désactivé.')
param retentionDays int = 0

@description('Endpoint du compte de stockage pour l\'export des logs (facultatif).')
param storageEndpoint string?

@description('Clé d\'accès du compte de stockage (facultatif).')
@secure()
param storageAccountAccessKey string?

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

resource securityAlertPolicy 'Microsoft.Sql/servers/securityAlertPolicies@2023-08-01' = {
  name: name
  parent: server
  properties: {
    state: state
    disabledAlerts: disabledAlerts
    emailAccountAdmins: emailAccountAdmins
    emailAddresses: length(emailAddresses) > 0 ? emailAddresses : null
    retentionDays: retentionDays
    storageEndpoint: storageEndpoint
    storageAccountAccessKey: storageAccountAccessKey
  }
}

@description('Nom de la politique d\'alertes configurée.')
output name string = securityAlertPolicy.name

@description('ID complet de la ressource de politique d\'alertes.')
output resourceId string = securityAlertPolicy.id
