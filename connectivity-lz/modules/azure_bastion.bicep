// connectivity-lz/modules/azure_bastion.bicep
// Azure Bastion module for secure RDP/SSH access

@description('Azure Bastion name')
param bastionName string

@description('Location for the bastion')
param location string

@description('Bastion SKU')
@allowed([
  'Basic'
  'Standard'
])
param sku string = 'Standard'

@description('Subnet ID for the bastion (AzureBastionSubnet)')
param subnetId string

@description('Public IP Address resource ID for the bastion')
param publicIpAddressId string

@description('Enable IP Connect feature (Standard SKU only)')
param enableIpConnect bool = false

@description('Enable shareable link feature (Standard SKU only)')
param enableShareableLink bool = false

@description('Enable tunneling feature (Standard SKU only)')
param enableTunneling bool = false

@description('Enable file copy feature (Standard SKU only)')
param enableFileCopy bool = false

@description('Scale units (2-50, Standard SKU only)')
@minValue(2)
@maxValue(50)
param scaleUnits int = 2

@description('Tags to apply to the bastion')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID for diagnostics')
param logAnalyticsWorkspaceId string = ''

// Azure Bastion Resource
resource bastion 'Microsoft.Network/bastionHosts@2023-09-01' = {
  name: bastionName
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    ipConfigurations: [
      {
        name: 'bastionIpConfig'
        properties: {
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: publicIpAddressId
          }
        }
      }
    ]
    enableIpConnect: sku == 'Standard' ? enableIpConnect : false
    enableShareableLink: sku == 'Standard' ? enableShareableLink : false
    enableTunneling: sku == 'Standard' ? enableTunneling : false
    enableFileCopy: sku == 'Standard' ? enableFileCopy : false
    scaleUnits: sku == 'Standard' ? scaleUnits : 2
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: bastion
  name: '${bastionName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'BastionAuditLogs'
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
@description('Azure Bastion resource ID')
output bastionId string = bastion.id

@description('Azure Bastion name')
output bastionName string = bastion.name

@description('Azure Bastion DNS name')
output dnsName string = bastion.properties.dnsName
