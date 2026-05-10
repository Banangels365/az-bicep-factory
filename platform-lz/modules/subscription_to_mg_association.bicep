// platform-lz/modules/subscription_to_mg_association.bicep
// Subscription to management group association module for centralized subscription management

targetScope = 'tenant'

@description('ID de l\'abonnement à associer')
param subscriptionId string

@description('ID du groupe d\'administration avec lequel associer l\'abonnement')
param managementGroupId string

resource subscriptionAssociation 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = {
  name: '${managementGroupId}/${subscriptionId}'
}
