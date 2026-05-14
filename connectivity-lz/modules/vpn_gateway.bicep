// connectivity-lz/modules/vpn_gateway.bicep
// VPN Gateway module for site-to-site and point-to-site connectivity

@description('VPN Gateway name')
param vpnGatewayName string

@description('Location for the VPN gateway')
param location string = resourceGroup().location

@description('Gateway type')
@allowed([
  'Vpn'
  'ExpressRoute'
])
param gatewayType string = 'Vpn'

@description('VPN type')
@allowed([
  'RouteBased'
  'PolicyBased'
])
param vpnType string = 'RouteBased'

@description('Gateway SKU')
@allowed([
  'Basic'
  'VpnGw1'
  'VpnGw2'
  'VpnGw3'
  'VpnGw4'
  'VpnGw5'
  'VpnGw1AZ'
  'VpnGw2AZ'
  'VpnGw3AZ'
  'VpnGw4AZ'
  'VpnGw5AZ'
])
param gatewaySku string = 'VpnGw1'

@description('Gateway generation')
@allowed([
  'Generation1'
  'Generation2'
  'None'
])
param vpnGatewayGeneration string = 'Generation1'

@description('Subnet ID for the gateway (GatewaySubnet)')
param subnetId string

@description('Public IP Address resource ID for the gateway')
param publicIpAddressId string

@description('Second Public IP Address resource ID (for active-active)')
param publicIpAddressId2 string = ''

@description('Enable BGP')
param enableBgp bool = false

@description('BGP ASN number')
param bgpAsn int = 65515

@description('BGP peering address')
param bgpPeeringAddress string = ''

@description('Enable active-active mode')
param activeActive bool = false

@description('Point-to-site configuration')
param p2sConfiguration object = {}

@description('Custom BGP IP addresses for active-active')
param customBgpIpAddresses array = []

@description('Tags to apply to the VPN gateway')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID for diagnostics')
param logAnalyticsWorkspaceId string = ''

// VPN Gateway Resource
resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2023-09-01' = {
  name: vpnGatewayName
  location: location
  tags: tags
  properties: {
    gatewayType: gatewayType
    vpnType: vpnType
    vpnGatewayGeneration: vpnGatewayGeneration
    enableBgp: enableBgp
    activeActive: activeActive
    sku: {
      name: gatewaySku
      tier: gatewaySku
    }
    ipConfigurations: activeActive && !empty(publicIpAddressId2)
      ? [
          {
            name: 'ipConfig1'
            properties: {
              privateIPAllocationMethod: 'Dynamic'
              subnet: {
                id: subnetId
              }
              publicIPAddress: {
                id: publicIpAddressId
              }
            }
          }
          {
            name: 'ipConfig2'
            properties: {
              privateIPAllocationMethod: 'Dynamic'
              subnet: {
                id: subnetId
              }
              publicIPAddress: {
                id: publicIpAddressId2
              }
            }
          }
        ]
      : [
          {
            name: 'ipConfig1'
            properties: {
              privateIPAllocationMethod: 'Dynamic'
              subnet: {
                id: subnetId
              }
              publicIPAddress: {
                id: publicIpAddressId
              }
            }
          }
        ]
    bgpSettings: enableBgp
      ? {
          asn: bgpAsn
          bgpPeeringAddress: !empty(bgpPeeringAddress) ? bgpPeeringAddress : null
          peerWeight: 0
          bgpPeeringAddresses: !empty(customBgpIpAddresses) ? customBgpIpAddresses : null
        }
      : null
    vpnClientConfiguration: !empty(p2sConfiguration)
      ? {
          vpnClientAddressPool: {
            addressPrefixes: p2sConfiguration.vpnClientAddressPool
          }
          vpnClientProtocols: p2sConfiguration.?vpnClientProtocols ?? ['OpenVPN']
          vpnAuthenticationTypes: p2sConfiguration.?vpnAuthenticationTypes ?? ['Certificate']
          vpnClientRootCertificates: p2sConfiguration.?vpnClientRootCertificates ?? []
          vpnClientRevokedCertificates: p2sConfiguration.?vpnClientRevokedCertificates ?? []
          radiusServerAddress: p2sConfiguration.?radiusServerAddress ?? null
          radiusServerSecret: p2sConfiguration.?radiusServerSecret ?? null
          aadTenant: p2sConfiguration.?aadTenant ?? null
          aadAudience: p2sConfiguration.?aadAudience ?? null
          aadIssuer: p2sConfiguration.?aadIssuer ?? null
        }
      : null
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: vpnGateway
  name: '${vpnGatewayName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'GatewayDiagnosticLog'
        enabled: true
      }
      {
        category: 'TunnelDiagnosticLog'
        enabled: true
      }
      {
        category: 'RouteDiagnosticLog'
        enabled: true
      }
      {
        category: 'IKEDiagnosticLog'
        enabled: true
      }
      {
        category: 'P2SDiagnosticLog'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// Outputs
@description('VPN Gateway resource ID')
output vpnGatewayId string = vpnGateway.id

@description('VPN Gateway name')
output vpnGatewayName string = vpnGateway.name

@description('BGP settings')
output bgpSettings object = enableBgp ? vpnGateway.properties.bgpSettings : {}

@description('Gateway public IP address')
output publicIpAddress string = reference(publicIpAddressId, '2023-09-01').ipAddress
