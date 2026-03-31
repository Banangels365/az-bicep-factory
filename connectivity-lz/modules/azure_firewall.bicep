// connectivity-lz/modules/azure_firewall.bicep
// Azure Firewall module with policy support

@description('Azure Firewall name')
param firewallName string

@description('Location for the firewall')
param location string = resourceGroup().location

@description('Azure Firewall SKU')
@allowed([
  'AZFW_VNet'
  'AZFW_Hub'
])
param skuName string = 'AZFW_VNet'

@description('Azure Firewall tier')
@allowed([
  'Standard'
  'Premium'
  'Basic'
])
param skuTier string = 'Standard'

@description('Subnet ID for the firewall (AzureFirewallSubnet)')
param subnetId string

@description('Public IP Address resource IDs for the firewall')
param publicIpAddressIds array

@description('Firewall Policy resource ID')
param firewallPolicyId string = ''

@description('Management subnet ID for Basic SKU')
param managementSubnetId string = ''

@description('Management public IP resource ID for Basic SKU')
param managementPublicIpId string = ''

@description('Availability zones')
param zones array = []

@description('Enable DNS proxy')
param enableDnsProxy bool = true

@description('DNS servers for the firewall')
param dnsServers array = []

@description('Threat Intelligence mode')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param threatIntelMode string = 'Alert'

@description('Tags to apply to the firewall')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID for diagnostics')
param logAnalyticsWorkspaceId string = ''

// Azure Firewall Resource
resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: firewallName
  location: location
  tags: tags
  zones: !empty(zones) ? zones : null
  properties: {
    sku: {
      name: skuName
      tier: skuTier
    }
    ipConfigurations: [
      for (pipId, i) in publicIpAddressIds: {
        name: 'ipConfig${i + 1}'
        properties: {
          subnet: i == 0
            ? {
                id: subnetId
              }
            : null
          publicIPAddress: {
            id: pipId
          }
        }
      }
    ]
    managementIpConfiguration: skuTier == 'Basic' && !empty(managementSubnetId) && !empty(managementPublicIpId)
      ? {
          name: 'mgmtIpConfig'
          properties: {
            subnet: {
              id: managementSubnetId
            }
            publicIPAddress: {
              id: managementPublicIpId
            }
          }
        }
      : null
    firewallPolicy: !empty(firewallPolicyId)
      ? {
          id: firewallPolicyId
        }
      : null
    threatIntelMode: threatIntelMode
    additionalProperties: enableDnsProxy
      ? {
          'Network.DNS.EnableProxy': 'true'
          'Network.DNS.Servers': !empty(dnsServers) ? join(dnsServers, ',') : ''
        }
      : {}
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: azureFirewall
  name: '${firewallName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'AzureFirewallApplicationRule'
        enabled: true
      }
      {
        category: 'AzureFirewallNetworkRule'
        enabled: true
      }
      {
        category: 'AzureFirewallDnsProxy'
        enabled: true
      }
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
@description('Azure Firewall resource ID')
output firewallId string = azureFirewall.id

@description('Azure Firewall name')
output firewallName string = azureFirewall.name

@description('Azure Firewall private IP address')
output privateIpAddress string = azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress

@description('Azure Firewall public IP addresses')
output publicIpAddresses array = [
  for (pipId, i) in publicIpAddressIds: {
    name: 'ipConfig${i + 1}'
    publicIpId: pipId
  }
]
