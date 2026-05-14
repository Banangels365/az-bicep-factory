// connectivity-lz/modules/subnet.bicep
// Subnet module for creating individual subnets

@description('Virtual Network name')
param vnetName string

@description('Subnet name')
param subnetName string

@description('Subnet address prefix (CIDR notation)')
param addressPrefix string

@description('Network Security Group resource ID')
param networkSecurityGroupId string = ''

@description('Route Table resource ID')
param routeTableId string = ''

@description('Service endpoints to enable')
param serviceEndpoints array = []

@description('Subnet delegations')
param delegations array = []

@description('Private endpoint network policies (Disabled or Enabled)')
@allowed([
  'Disabled'
  'Enabled'
])
param privateEndpointNetworkPolicies string = 'Disabled'

@description('Private link service network policies (Disabled or Enabled)')
@allowed([
  'Disabled'
  'Enabled'
])
param privateLinkServiceNetworkPolicies string = 'Enabled'

@description('NAT Gateway resource ID')
param natGatewayId string = ''

// Reference to existing VNet
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vnetName
}

// Subnet Resource
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: virtualNetwork
  name: subnetName
  properties: {
    addressPrefix: addressPrefix
    networkSecurityGroup: !empty(networkSecurityGroupId)
      ? {
          id: networkSecurityGroupId
        }
      : null
    routeTable: !empty(routeTableId)
      ? {
          id: routeTableId
        }
      : null
    serviceEndpoints: serviceEndpoints
    delegations: delegations
    privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
    privateLinkServiceNetworkPolicies: privateLinkServiceNetworkPolicies
    natGateway: !empty(natGatewayId)
      ? {
          id: natGatewayId
        }
      : null
  }
}

// Outputs
@description('Subnet resource ID')
output subnetId string = subnet.id

@description('Subnet name')
output subnetName string = subnet.name

@description('Subnet address prefix')
output addressPrefix string = subnet.properties.addressPrefix
