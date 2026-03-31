// connectivity-lz/modules/hub_network.bicep
// Hub Network orchestrator for Hub-Spoke topology

targetScope = 'subscription'

@description('Organization name')
param organizationName string

@description('Environment')
@allowed([
  'prod'
  'logging'
  'quarantine'
  'sandbox'
])
param environment string

@description('Azure region for hub resources')
param location string = 'canadacentral'

@description('Hub VNet address prefix')
param hubVnetAddressPrefix string = '10.0.0.0/16'

@description('Gateway subnet address prefix')
param gatewaySubnetAddressPrefix string = '10.0.0.0/27'

@description('Azure Firewall subnet address prefix')
param firewallSubnetAddressPrefix string = '10.0.1.0/26'

@description('Bastion subnet address prefix')
param bastionSubnetAddressPrefix string = '10.0.2.0/27'

@description('Management subnet address prefix')
param managementSubnetAddressPrefix string = '10.0.3.0/24'

@description('Deploy VPN Gateway')
param deployVpnGateway bool = true

@description('Deploy Azure Firewall')
param deployAzureFirewall bool = true

@description('Deploy Azure Bastion')
param deployBastion bool = true

@description('Deploy DDoS Protection Plan')
param deployDdosProtection bool = false

@description('VPN Gateway SKU')
@allowed([
  'VpnGw1'
  'VpnGw2'
  'VpnGw3'
  'VpnGw1AZ'
  'VpnGw2AZ'
  'VpnGw3AZ'
])
param vpnGatewaySku string = 'VpnGw1'

@description('Azure Firewall SKU tier')
@allowed([
  'Standard'
  'Premium'
])
param firewallSkuTier string = 'Standard'

@description('Availability zones for zone-redundant resources')
param availabilityZones array = []

@description('Log Analytics Workspace ID')
param logAnalyticsWorkspaceId string

@description('Tags to apply to all resources')
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  Purpose: 'Hub-Network'
}

// Variables
var resourceGroupName = 'rg-${organizationName}-hub-${environment}-${location}'
var hubVnetName = 'vnet-${organizationName}-hub-${environment}-${location}'
var firewallName = 'afw-${organizationName}-hub-${environment}'
var vpnGatewayName = 'vpngw-${organizationName}-hub-${environment}'
var bastionName = 'bas-${organizationName}-hub-${environment}'
var ddosProtectionPlanName = 'ddos-${organizationName}-${environment}'

// NSG names
var nsgManagementName = 'nsg-hub-management-${environment}'
var nsgFirewallName = 'nsg-hub-firewall-${environment}'

// Public IP names
var pipVpnGatewayName = 'pip-vpngw-${environment}'
var pipFirewallName = 'pip-afw-${environment}'
var pipBastionName = 'pip-bas-${environment}'

// Route table names
var rtManagementName = 'rt-hub-management-${environment}'

// ============================================
// RESOURCE GROUP
// ============================================

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// ============================================
// DDoS PROTECTION PLAN
// ============================================

module ddosProtection './modules/ddos_protection.bicep' = if (deployDdosProtection) {
  scope: resourceGroup
  name: 'deploy-ddos-protection'
  params: {
    ddosProtectionPlanName: ddosProtectionPlanName
    location: location
    tags: tags
  }
}

// ============================================
// NETWORK SECURITY GROUPS
// ============================================

module nsgManagement './modules/network_security_group.bicep' = {
  scope: resourceGroup
  name: 'deploy-nsg-management'
  params: {
    nsgName: nsgManagementName
    location: location
    securityRules: [
      {
        name: 'AllowRDP'
        description: 'Allow RDP from Bastion subnet'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '3389'
        sourceAddressPrefix: bastionSubnetAddressPrefix
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 100
        direction: 'Inbound'
      }
      {
        name: 'AllowSSH'
        description: 'Allow SSH from Bastion subnet'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '22'
        sourceAddressPrefix: bastionSubnetAddressPrefix
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 110
        direction: 'Inbound'
      }
      {
        name: 'DenyAllInbound'
        description: 'Deny all other inbound traffic'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
        access: 'Deny'
        priority: 4096
        direction: 'Inbound'
      }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
}

// ============================================
// ROUTE TABLES
// ============================================

module routeTableManagement './modules/route_table.bicep' = {
  scope: resourceGroup
  name: 'deploy-rt-management'
  params: {
    routeTableName: rtManagementName
    location: location
    disableBgpRoutePropagation: false
    routes: deployAzureFirewall
      ? [
          {
            name: 'ToInternet'
            addressPrefix: '0.0.0.0/0'
            nextHopType: 'VirtualAppliance'
            nextHopIpAddress: deployAzureFirewall ? azureFirewall.outputs.privateIpAddress : ''
          }
        ]
      : []
    tags: tags
  }
  dependsOn: deployAzureFirewall
    ? [
        azureFirewall
      ]
    : []
}

// ============================================
// HUB VIRTUAL NETWORK
// ============================================

module hubVnet './modules/virtual_network.bicep' = {
  scope: resourceGroup
  name: 'deploy-hub-vnet'
  params: {
    vnetName: hubVnetName
    location: location
    addressPrefixes: [hubVnetAddressPrefix]
    enableDdosProtection: deployDdosProtection
    ddosProtectionPlanId: deployDdosProtection ? ddosProtection.outputs.ddosProtectionPlanId : ''
    subnets: [
      {
        name: 'GatewaySubnet'
        addressPrefix: gatewaySubnetAddressPrefix
      }
      {
        name: 'AzureFirewallSubnet'
        addressPrefix: firewallSubnetAddressPrefix
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: bastionSubnetAddressPrefix
      }
      {
        name: 'snet-hub-management'
        addressPrefix: managementSubnetAddressPrefix
        networkSecurityGroupId: nsgManagement.outputs.nsgId
        routeTableId: routeTableManagement.outputs.routeTableId
      }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  dependsOn: [
    nsgManagement
    routeTableManagement
  ]
}

// ============================================
// PUBLIC IP ADDRESSES
// ============================================

module pipVpnGateway './modules/public_ip.bicep' = if (deployVpnGateway) {
  scope: resourceGroup
  name: 'deploy-pip-vpngw'
  params: {
    publicIpName: pipVpnGatewayName
    location: location
    sku: 'Standard'
    allocationMethod: 'Static'
    zones: availabilityZones
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
}

module pipFirewall './modules/public_ip.bicep' = if (deployAzureFirewall) {
  scope: resourceGroup
  name: 'deploy-pip-firewall'
  params: {
    publicIpName: pipFirewallName
    location: location
    sku: 'Standard'
    allocationMethod: 'Static'
    zones: availabilityZones
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
}

module pipBastion './modules/public_ip.bicep' = if (deployBastion) {
  scope: resourceGroup
  name: 'deploy-pip-bastion'
  params: {
    publicIpName: pipBastionName
    location: location
    sku: 'Standard'
    allocationMethod: 'Static'
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
}

// ============================================
// VPN GATEWAY
// ============================================

module vpnGateway './modules/vpn_gateway.bicep' = if (deployVpnGateway) {
  scope: resourceGroup
  name: 'deploy-vpn-gateway'
  params: {
    vpnGatewayName: vpnGatewayName
    location: location
    gatewaySku: vpnGatewaySku
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    vpnGatewayGeneration: 'Generation1'
    subnetId: '${hubVnet.outputs.vnetId}/subnets/GatewaySubnet'
    publicIpAddressId: pipVpnGateway.outputs.publicIpId
    enableBgp: false
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  dependsOn: [
    hubVnet
    pipVpnGateway
  ]
}

// ============================================
// AZURE FIREWALL
// ============================================

module azureFirewall './modules/azure_firewall.bicep' = if (deployAzureFirewall) {
  scope: resourceGroup
  name: 'deploy-azure-firewall'
  params: {
    firewallName: firewallName
    location: location
    skuName: 'AZFW_VNet'
    skuTier: firewallSkuTier
    subnetId: '${hubVnet.outputs.vnetId}/subnets/AzureFirewallSubnet'
    publicIpAddressIds: [
      pipFirewall.outputs.publicIpId
    ]
    zones: availabilityZones
    enableDnsProxy: true
    threatIntelMode: 'Alert'
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  dependsOn: [
    hubVnet
    pipFirewall
  ]
}

// ============================================
// AZURE BASTION
// ============================================

module bastion './modules/azure_bastion.bicep' = if (deployBastion) {
  scope: resourceGroup
  name: 'deploy-bastion'
  params: {
    bastionName: bastionName
    location: location
    sku: 'Standard'
    subnetId: '${hubVnet.outputs.vnetId}/subnets/AzureBastionSubnet'
    publicIpAddressId: pipBastion.outputs.publicIpId
    enableFileCopy: true
    enableTunneling: true
    scaleUnits: 2
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  dependsOn: [
    pipBastion
  ]
}

// ============================================
// OUTPUTS
// ============================================

output resourceGroupName string = resourceGroup.name
output hubVnetId string = hubVnet.outputs.vnetId
output hubVnetName string = hubVnet.outputs.vnetName
output hubVnetAddressPrefix string = hubVnetAddressPrefix

output gatewaySubnetId string = '${hubVnet.outputs.vnetId}/subnets/GatewaySubnet'
output firewallSubnetId string = '${hubVnet.outputs.vnetId}/subnets/AzureFirewallSubnet'
output bastionSubnetId string = '${hubVnet.outputs.vnetId}/subnets/AzureBastionSubnet'
output managementSubnetId string = '${hubVnet.outputs.vnetId}/subnets/snet-hub-management'

output vpnGatewayId string = deployVpnGateway ? vpnGateway.outputs.vpnGatewayId : ''
output azureFirewallId string = deployAzureFirewall ? azureFirewall.outputs.firewallId : ''
output azureFirewallPrivateIp string = deployAzureFirewall ? azureFirewall.outputs.privateIpAddress : ''
output bastionId string = deployBastion ? bastion.outputs.bastionId : ''

output ddosProtectionPlanId string = deployDdosProtection ? ddosProtection.outputs.ddosProtectionPlanId : ''
