// connectivity-lz/modules/virtual_network_peering.bicep
// VNet Peering module for Hub-Spoke topology

@description('Local Virtual Network name')
param localVnetName string

@description('Remote Virtual Network resource ID')
param remoteVnetId string

@description('Peering name (optional, auto-generated if not provided)')
param peeringName string = '${localVnetName}-to-${last(split(remoteVnetId, '/'))}'

@description('Allow virtual network access')
param allowVirtualNetworkAccess bool = true

@description('Allow forwarded traffic')
param allowForwardedTraffic bool = true

@description('Allow gateway transit')
param allowGatewayTransit bool = false

@description('Use remote gateways')
param useRemoteGateways bool = false

@description('Enable peering on both sides (bidirectional)')
param createReversePeering bool = false

// Reference to local VNet
resource localVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: localVnetName
}

// VNet Peering from Local to Remote
resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: localVnet
  name: peeringName
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: remoteVnetId
    }
  }
}

// Reverse VNet Peering (optional)
resource reversePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = if (createReversePeering) {
  parent: localVnet
  name: '${last(split(remoteVnetId, '/'))}-to-${localVnetName}'
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: useRemoteGateways
    useRemoteGateways: allowGatewayTransit
    remoteVirtualNetwork: {
      id: remoteVnetId
    }
  }
}

// Outputs
@description('VNet Peering resource ID')
output peeringId string = vnetPeering.id

@description('VNet Peering name')
output peeringName string = vnetPeering.name

@description('Peering state')
output peeringState string = vnetPeering.properties.peeringState
