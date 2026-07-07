// modules/networking/subnet.bicep
// Subnet module for creating individual subnets

@description('Nom du VNet parent')
param vnetName string

@description('Nom du subnet')
param subnetName string

@description('Préfixe d\'adresse du subnet (CIDR)')
param addressPrefix string

@description('ID du groupe de sécurité réseau')
param networkSecurityGroupId string = ''

@description('ID de la table de routage')
param routeTableId string = ''

@description('Points de terminaison de service à associer au subnet')
param serviceEndpoints array = []

@description('Subnet delegations')
param delegations array = []

@description('Stratégie de réseau privé pour les points de terminaison privés (Disabled ou Enabled)')
@allowed([
  'Disabled'
  'Enabled'
])
param privateEndpointNetworkPolicies string = 'Disabled'

@description('Stratégie de réseau privé pour les services de lien privé (Disabled or Enabled)')
@allowed([
  'Disabled'
  'Enabled'
])
param privateLinkServiceNetworkPolicies string = 'Enabled'

@description('ID du NAT Gateway à associer au subnet')
param natGatewayId string = ''

// Note: ce module doit être appelé avec scope: resourceGroup(...)
// pointant vers le RG contenant le VNet parent.
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vnetName
}

// Subnet Resource
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: virtualNetwork
  name: subnetName
  properties: union(
    {
      addressPrefix: addressPrefix
      serviceEndpoints: serviceEndpoints
      delegations: delegations
      privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
      privateLinkServiceNetworkPolicies: privateLinkServiceNetworkPolicies
    },
    !empty(networkSecurityGroupId) ? { networkSecurityGroup: { id: networkSecurityGroupId } } : {},
    !empty(routeTableId) ? { routeTable: { id: routeTableId } } : {},
    !empty(natGatewayId) ? { natGateway: { id: natGatewayId } } : {}
  )
}

// Outputs
@description('ID du subnet')
output subnetId string = subnet.id

@description('Nom du subnet')
output subnetName string = subnet.name

@description('Préfixe d\'adresse du subnet')
output addressPrefix string = subnet.properties.addressPrefix
