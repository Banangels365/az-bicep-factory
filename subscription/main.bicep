// az-platform-lz/subscription/main.bicep
// Subscription module for centralized subscription management

targetScope = 'tenant'

@description('Alias name for the subscription')
param subscriptionAliasName string

@description('Display name of the subscription')
param subscriptionDisplayName string

@description('Billing scope ID')
param billingScope string

@description('Workload type: Prod, Dev, Logging, Quarantine')
@allowed([
  'Prod'
  'Dev'
  'Logging'
  'Quarantine'
])
param workload string = 'Prod'

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
