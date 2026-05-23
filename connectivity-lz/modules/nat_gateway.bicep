// connectivity-lz/modules/nat_gateway.bicep
// NAT Gateway module for outbound internet connectivity

@description('NAT Gateway name')
param natGatewayName string

@description('Location for the NAT gateway')
param location string

@description('Public IP Address resource IDs')
param publicIpAddressIds array = []

@description('Public IP Prefix resource IDs')
param publicIpPrefixIds array = []

@description('Idle timeout in minutes')
@minValue(4)
@maxValue(120)
param idleTimeoutInMinutes int = 4

@description('Availability zones')
param zones array = []

@description('Tags to apply to the NAT gateway')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID for diagnostics')
param logAnalyticsWorkspaceId string = ''

// NAT Gateway Resource
resource natGateway 'Microsoft.Network/natGateways@2023-09-01' = {
  name: natGatewayName
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
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
    logs: []
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// Outputs
@description('NAT Gateway resource ID')
output natGatewayId string = natGateway.id

@description('NAT Gateway name')
output natGatewayName string = natGateway.name
