// connectivity-lz/modules/virtual_network_peering.bicep
// VNet Peering module for Hub-Spoke topology

@description('Nom du Virtual Network local')
param localVnetName string

@description('ID de la ressource du Virtual Network distant')
param remoteVnetId string

@description('Nom du peering VNet (optionnel)')
param peeringName string = '' // vide = calculé automatiquement

@description('Autoriser l\'accès entre les réseaux virtuels')
param allowVirtualNetworkAccess bool = true

@description('Autoriser le trafic transmis')
param allowForwardedTraffic bool = true

@description('Autoriser la traversée de la passerelle')
param allowGatewayTransit bool = false

@description('Utiliser les passerelles distantes (si allowGatewayTransit est vrai)')
param useRemoteGateways bool = false

// Variable pour résoudre le nom du peering
var resolvedPeeringName = !empty(peeringName) ? peeringName : '${localVnetName}-to-${last(split(remoteVnetId, '/'))}'

// Reference to local VNet
resource localVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: localVnetName
}

// VNet Peering from Local to Remote
resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: localVnet
  name: resolvedPeeringName
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    // Note: allowGatewayTransit et useRemoteGateways sont mutuellement exclusifs.
    // Si les deux sont true, useRemoteGateways prend précédence (comportement hub-spoke standard).
    allowGatewayTransit: allowGatewayTransit && !useRemoteGateways
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: remoteVnetId
    }
  }
}

// Outputs
@description('ID du peering VNet')
output peeringId string = vnetPeering.id

@description('Nom du peering VNet')
output peeringName string = vnetPeering.name

@description('État du peering')
output peeringState string = vnetPeering.properties.peeringState
