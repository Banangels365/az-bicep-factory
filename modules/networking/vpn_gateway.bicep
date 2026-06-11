// connectivity-lz/modules/vpn_gateway.bicep
// VPN Gateway module for site-to-site and point-to-site connectivity

@description('Nom de la VPN Gateway')
param vpnGatewayName string

@description('Région pour la VPN Gateway')
param location string

@description('Type de passerelle')
@allowed([
  'Vpn'
  'ExpressRoute'
])
param gatewayType string = 'Vpn'

@description('Type de VPN')
@allowed([
  'RouteBased'
  'PolicyBased'
])
param vpnType string = 'RouteBased'

@description('SKU de la passerelle VPN')
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

@description('Génération de la passerelle VPN')
@allowed([
  'Generation1'
  'Generation2'
  'None'
])
param vpnGatewayGeneration string = 'Generation1'

@description('ID de sous-réseau pour la passerelle (GatewaySubnet)')
param subnetId string

@description('ID de ressource d\'adresse IP publique pour la passerelle')
param publicIpAddressId string

@description('ID de ressource d\'adresse IP publique secondaire pour la passerelle (optionnel, requis pour active-active)')
param publicIpAddressId2 string = ''

@description('Activer BGP')
param enableBgp bool = false

@description('Numéro ASN BGP')
param bgpAsn int = 65515

@description('Adresse de peering BGP')
param bgpPeeringAddress string = ''

@description('Activer le mode active-active')
param activeActive bool = false

@description('Configuration point-to-site')
param p2sConfiguration object = {}

@description('Custom BGP IP addresses for active-active configuration (optionnel, si non fourni, Azure assignera automatiquement les adresses IP de peering BGP)')
param customBgpIpAddresses array = []

@description('Tags à appliquer à la Passerelle VPN')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID de l\'espace de travail Log Analytics pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// VPN Gateway Resource
resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2023-09-01' = {
  name: vpnGatewayName
  location: resolvedLocation
  tags: tags
  properties: union(
    {
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
                subnet: { id: subnetId }
                publicIPAddress: { id: publicIpAddressId }
              }
            }
            {
              name: 'ipConfig2'
              properties: {
                privateIPAllocationMethod: 'Dynamic'
                subnet: { id: subnetId }
                publicIPAddress: { id: publicIpAddressId2 }
              }
            }
          ]
        : [
            {
              name: 'ipConfig1'
              properties: {
                privateIPAllocationMethod: 'Dynamic'
                subnet: { id: subnetId }
                publicIPAddress: { id: publicIpAddressId }
              }
            }
          ]
    },
    enableBgp
      ? {
          bgpSettings: union(
            { asn: bgpAsn, peerWeight: 0 },
            !empty(bgpPeeringAddress) ? { bgpPeeringAddress: bgpPeeringAddress } : {},
            !empty(customBgpIpAddresses) ? { bgpPeeringAddresses: customBgpIpAddresses } : {}
          )
        }
      : {},
    !empty(p2sConfiguration)
      ? {
          vpnClientConfiguration: union(
            {
              vpnClientAddressPool: { addressPrefixes: p2sConfiguration.vpnClientAddressPool }
              vpnClientProtocols: p2sConfiguration.?vpnClientProtocols ?? ['OpenVPN']
              vpnAuthenticationTypes: p2sConfiguration.?vpnAuthenticationTypes ?? ['Certificate']
              vpnClientRootCertificates: p2sConfiguration.?vpnClientRootCertificates ?? []
              vpnClientRevokedCertificates: p2sConfiguration.?vpnClientRevokedCertificates ?? []
            },
            !empty(p2sConfiguration.?radiusServerAddress ?? '')
              ? { radiusServerAddress: p2sConfiguration.radiusServerAddress }
              : {},
            !empty(p2sConfiguration.?radiusServerSecret ?? '')
              ? { radiusServerSecret: p2sConfiguration.radiusServerSecret }
              : {},
            !empty(p2sConfiguration.?aadTenant ?? '') ? { aadTenant: p2sConfiguration.aadTenant } : {},
            !empty(p2sConfiguration.?aadAudience ?? '') ? { aadAudience: p2sConfiguration.aadAudience } : {},
            !empty(p2sConfiguration.?aadIssuer ?? '') ? { aadIssuer: p2sConfiguration.aadIssuer } : {}
          )
        }
      : {}
  )
}

// Resource pour récupérer les détails de l'adresse IP publique associée à la VPN Gateway

resource vpnGatewayPublicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' existing = {
  name: last(split(publicIpAddressId, '/'))
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: vpnGateway
  name: '${vpnGatewayName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        categoryGroup: 'allLogs'
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
@description('ID de la VPN Gateway')
output vpnGatewayId string = vpnGateway.id

@description('Nom de la VPN Gateway')
output vpnGatewayName string = vpnGateway.name

@description('Paramètres BGP de la VPN Gateway (si BGP est activé)')
output bgpSettings object = enableBgp ? vpnGateway.properties.bgpSettings : {}

@description('Adresse IP publique du VPN Gateway')
output publicIpAddress string = vpnGatewayPublicIp.properties.ipAddress ?? ''
