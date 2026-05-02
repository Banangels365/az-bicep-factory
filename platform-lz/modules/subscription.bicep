// platform-lz/subscription.bicep
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
  'prod' // production
  'logs' // logging/monitoring
  'quar' // quarantine
  'sbox' // sandbox
])
param workload string = 'sbox'

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
