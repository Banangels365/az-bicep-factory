// connectivity-lz/modules/azure_firewall.bicep
// Azure Firewall module with policy support

@description('Nom Azure Firewall')
param firewallName string

@description('Région Azure Firewall')
param location string

@description('SKU Azure Firewall')
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

@description('ID du sous-réseau du firewall (AzureFirewallSubnet)')
param subnetId string

@description('Address publiques du firewall (liste de resource IDs de public IPs)')
param publicIpAddressIds array

@description('ID de la Firewall Policy à associer (optionnel)')
param firewallPolicyId string = ''

@description('ID du sous-réseau de gestion pour le SKU Basic (optionnel)')
param managementSubnetId string = ''

@description('ID de l\'adresse IP publique de gestion pour le SKU Basic (optionnel)')
param managementPublicIpId string = ''

@description('Zones de disponibilité pour le firewall')
param zones array = []

@description('Activer le proxy DNS')
param enableDnsProxy bool = true

@description('Serveurs DNS pour le firewall')
param dnsServers array = []

@description('Mode Threat Intelligence')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param threatIntelMode string = 'Alert'

@description('Tags à appliquer au firewall')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

// Azure Firewall Resource
resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: firewallName
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
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
@description('ID Azure Firewall')
output firewallId string = azureFirewall.id

@description('Nom Azure Firewall')
output firewallName string = azureFirewall.name

@description('Adresse privée Azure Firewall')
output privateIpAddress string = azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress

@description('Adresses publiques Azure Firewall')
output publicIpAddresses array = [
  for (pipId, i) in publicIpAddressIds: {
    name: 'ipConfig${i + 1}'
    publicIpId: pipId
  }
]
