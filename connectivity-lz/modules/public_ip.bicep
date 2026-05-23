// connectivity-lz/modules/public_ip.bicep
// Public IP Address module

@description('Public IP Address name')
param publicIpName string

@description('Location for the public IP')
param location string = resourceGroup().location

@description('Public IP Address SKU')
@allowed([
  'Basic'
  'Standard'
])
param sku string = 'Standard'

@description('Public IP Address allocation method')
@allowed([
  'Dynamic'
  'Static'
])
param allocationMethod string = 'Static'

@description('Public IP Address version')
@allowed([
  'IPv4'
  'IPv6'
])
param publicIpAddressVersion string = 'IPv4'

@description('Idle timeout in minutes')
@minValue(4)
@maxValue(30)
param idleTimeoutInMinutes int = 4

@description('DNS domain name label')
param domainNameLabel string = ''

@description('Availability zones for the public IP')
param zones array = []

@description('DDoS protection mode')
@allowed([
  'Disabled'
  'Enabled'
  'VirtualNetworkInherited'
])
param ddosProtectionMode string = 'VirtualNetworkInherited'

@description('DDoS Protection Plan ID')
param ddosProtectionPlanId string = ''

@description('Tags to apply to the public IP')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID for diagnostics')
param logAnalyticsWorkspaceId string = ''

// Public IP Address Resource
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIpName
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
  tags: tags
  sku: {
    name: sku
    tier: 'Regional'
  }
  zones: !empty(zones) ? zones : null
  properties: {
    publicIPAllocationMethod: allocationMethod
    publicIPAddressVersion: publicIpAddressVersion
    idleTimeoutInMinutes: idleTimeoutInMinutes
    dnsSettings: !empty(domainNameLabel)
      ? {
          domainNameLabel: domainNameLabel
        }
      : null
    ddosSettings: ddosProtectionMode != 'Disabled'
      ? {
          protectionMode: ddosProtectionMode
          ddosProtectionPlan: !empty(ddosProtectionPlanId)
            ? {
                id: ddosProtectionPlanId
              }
            : null
        }
      : null
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: publicIp
  name: '${publicIpName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'DDoSProtectionNotifications'
        enabled: true
      }
      {
        category: 'DDoSMitigationFlowLogs'
        enabled: true
      }
      {
        category: 'DDoSMitigationReports'
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
@description('Public IP Address resource ID')
output publicIpId string = publicIp.id

@description('Public IP Address name')
output publicIpName string = publicIp.name

@description('Public IP Address (once assigned)')
output ipAddress string = publicIp.properties.ipAddress

@description('Fully qualified domain name')
output fqdn string = !empty(domainNameLabel) ? publicIp.properties.dnsSettings.fqdn : ''
