// platform-lz/subscription/subscription-to-mg-association.bicep
// Subscription to management group association module for centralized subscription management

targetScope = 'tenant'

@description('Subscription ID to associate')
param subscriptionId string

@description('Management Group ID to associate the subscription with')
param managementGroupId string

resource subscriptionAssociation 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = {
  name: '${managementGroupId}/${subscriptionId}'
}
