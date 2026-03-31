// connectivity-lz/connectivity.bicepparam
// Parameters for connectivity hub deployment

using './connectivity.bicep'

// Organization configuration
param organizationName = 'contoso'
param environment = 'prod'
param location = 'canadacentral'

// Hub VNet addressing
param hubVnetAddressPrefix = '10.0.0.0/16'
param gatewaySubnetAddressPrefix = '10.0.0.0/27'
param firewallSubnetAddressPrefix = '10.0.1.0/26'
param bastionSubnetAddressPrefix = '10.0.2.0/27'
param managementSubnetAddressPrefix = '10.0.3.0/24'

// Feature toggles
param deployVpnGateway = true
param deployAzureFirewall = true
param deployBastion = true
param deployDdosProtection = false // Enable for production

// Gateway configuration
param vpnGatewaySku = 'VpnGw1AZ' // Use AZ SKU for zone redundancy
param firewallSkuTier = 'Standard' // Use 'Premium' for advanced threat protection

// High availability
param availabilityZones = [
  '1'
  '2'
  '3'
]

// Logging
param logAnalyticsWorkspaceId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-platform-management-prod/providers/Microsoft.OperationalInsights/workspaces/law-contoso-platform-prod'

// Tagging
param tags = {
  Environment: 'Production'
  ManagedBy: 'Bicep'
  CostCenter: 'IT-Network'
  Owner: 'NetworkOps-Team'
  Purpose: 'Hub-Network'
}
