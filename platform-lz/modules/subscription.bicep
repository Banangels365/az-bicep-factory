// platform-lz/modules/subscription.bicep
// Subscription module for centralized subscription management

targetScope = 'tenant'

@description('Alias pour le nom de l\'abonnement')
param subscriptionAliasName string

@description('Nom d\'affichage de l\'abonnement')
param subscriptionDisplayName string

@description('ID du scope de facturation (Billing Scope) pour l\'abonnement')
param billingScope string

@description('Workload type: Prod, Dev, Logs, Quar ou Sbox')
@allowed([
  'Prod' // production
  'Dev' // development
  'Logs' // logging/monitoring
  'Quar' // quarantine
  'Sbox' // sandbox
])
param workload string = 'Sbox'

resource subscriptionAlias 'Microsoft.Subscription/aliases@2021-10-01' = {
  name: subscriptionAliasName
  properties: {
    displayName: subscriptionDisplayName
    billingScope: billingScope
    workload: workload
  }
}

output subscriptionId string = subscriptionAlias.properties.subscriptionId
output subscriptionAliasId string = subscriptionAlias.id
