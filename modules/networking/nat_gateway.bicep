// modules/networking/nat_gateway.bicep
// NAT Gateway module for outbound internet connectivity

@description('Nom du NAT Gateway')
param natGatewayName string

@description('Région pour le NAT gateway')
param location string = resourceGroup().location

@description('ID des adresses IP publiques pour le NAT gateway')
param publicIpAddressIds array = []

@description('ID des préfixes IP publics pour le NAT gateway')
param publicIpPrefixIds array = []

@description('Temps d\'inactivité avant déconnexion (en minutes, 4-120)')
@minValue(4)
@maxValue(120)
param idleTimeoutInMinutes int = 4

// Ajouter une validation
@description('Zone de disponibilité (0 ou 1 élément — NAT Gateway ne supporte qu\'une seule zone)')
@maxLength(1)
param zones array = []

@description('Tags à appliquer au NAT gateway')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

// NAT Gateway Resource
resource natGateway 'Microsoft.Network/natGateways@2023-09-01' = {
  name: natGatewayName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  zones: !empty(zones) ? zones : null
  properties: {
    idleTimeoutInMinutes: idleTimeoutInMinutes
    publicIpAddresses: [
      for pipId in publicIpAddressIds: {
        id: pipId
      }
    ]
    publicIpPrefixes: [
      for prefixId in publicIpPrefixIds: {
        id: prefixId
      }
    ]
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: natGateway
  name: '${natGatewayName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// Outputs
@description('ID du NAT Gateway')
output natGatewayId string = natGateway.id

@description('Nom du NAT Gateway')
output natGatewayName string = natGateway.name
