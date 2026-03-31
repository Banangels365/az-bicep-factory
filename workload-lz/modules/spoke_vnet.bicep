// workloads/spoke-vnet/main.bicep
// Spoke VNet module for 3-tier application architecture

targetScope = 'subscription'

@description('Organization name')
param organizationName string

@description('Workload name')
param workloadName string

@description('Environment')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string

@description('Azure region')
param location string = 'canadacentral'

@description('Spoke VNet address prefix')
param spokeVnetAddressPrefix string

@description('Web tier subnet address prefix')
param webSubnetAddressPrefix string

@description('App tier subnet address prefix')
param appSubnetAddressPrefix string

@description('Data tier subnet address prefix')
param dataSubnetAddressPrefix string

@description('Private endpoints subnet address prefix')
param privateEndpointsSubnetAddressPrefix string

@description('Hub VNet ID for peering')
param hubVnetId string

@description('Hub VNet resource group name')
param hubVnetResourceGroupName string

@description('Hub VNet subscription ID')
param hubVnetSubscriptionId string

@description('Azure Firewall private IP (for routing)')
param azureFirewallPrivateIp string

@description('Log Analytics Workspace ID')
param logAnalyticsWorkspaceId string

@description('Enable DDoS Protection')
param enableDdosProtection bool = false

@description('DDoS Protection Plan ID')
param ddosProtectionPlanId string = ''

@description('Tags to apply to all resources')
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  Workload: workloadName
}

// Variables
var resourceGroupName = 'rg-${organizationName}-${workloadName}-${environment}-${location}'
var spokeVnetName = 'vnet-${organizationName}-${workloadName}-${environment}-${location}'

// NSG names
var nsgWebName = 'nsg-${workloadName}-web-${environment}'
var nsgAppName = 'nsg-${workloadName}-app-${environment}'
var nsgDataName = 'nsg-${workloadName}-data-${environment}'
var nsgPeSubnetName = 'nsg-${workloadName}-pe-${environment}'

// Route table names
var rtWebName = 'rt-${workloadName}-web-${environment}'
var rtAppName = 'rt-${workloadName}-app-${environment}'
var rtDataName = 'rt-${workloadName}-data-${environment}'

// Subnet names
var webSubnetName = 'snet-${workloadName}-web-${environment}'
var appSubnetName = 'snet-${workloadName}-app-${environment}'
var dataSubnetName = 'snet-${workloadName}-data-${environment}'
var peSubnetName = 'snet-${workloadName}-privateendpoints-${environment}'

// ============================================
// RESOURCE GROUP
// ============================================

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// ============================================
// NETWORK SECURITY GROUPS
// ============================================

// NSG for Web Tier
module nsgWeb '../../connectivity-lz/modules/network_security_group.bicep' = {
  scope: resourceGroup
  name: 'deploy-nsg-web'
  params: {
    nsgName: nsgWebName
    location: location
    securityRules: [
      {
        name: 'AllowHttpsInbound'
        description: 'Allow HTTPS from Internet'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '443'
        sourceAddressPrefix: 'Internet'
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 100
        direction: 'Inbound'
      }
      {
        name: 'AllowHttpInbound'
        description: 'Allow HTTP from Internet (redirect to HTTPS)'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '80'
        sourceAddressPrefix: 'Internet'
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 110
        direction: 'Inbound'
      }
      {
        name: 'AllowAppTierOutbound'
        description: 'Allow traffic to App tier'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: webSubnetAddressPrefix
        destinationAddressPrefix: appSubnetAddressPrefix
        access: 'Allow'
        priority: 100
        direction: 'Outbound'
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
    enableFlowLogs: true
    tags: tags
  }
}

// NSG for App Tier
module nsgApp '../../modules/networking/nsg/main.bicep' = {
  scope: resourceGroup
  name: 'deploy-nsg-app'
  params: {
    nsgName: nsgAppName
    location: location
    securityRules: [
      {
        name: 'AllowWebTierInbound'
        description: 'Allow traffic from Web tier'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: webSubnetAddressPrefix
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 100
        direction: 'Inbound'
      }
      {
        name: 'AllowDataTierOutbound'
        description: 'Allow traffic to Data tier'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: appSubnetAddressPrefix
        destinationAddressPrefix: dataSubnetAddressPrefix
        access: 'Allow'
        priority: 100
        direction: 'Outbound'
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
    enableFlowLogs: true
    tags: tags
  }
}

// NSG for Data Tier
module nsgData '../../modules/networking/nsg/main.bicep' = {
  scope: resourceGroup
  name: 'deploy-nsg-data'
  params: {
    nsgName: nsgDataName
    location: location
    securityRules: [
      {
        name: 'AllowAppTierInbound'
        description: 'Allow traffic from App tier'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: appSubnetAddressPrefix
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 100
        direction: 'Inbound'
      }
      {
        name: 'AllowSqlInbound'
        description: 'Allow SQL from App tier'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '1433'
        sourceAddressPrefix: appSubnetAddressPrefix
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
      {
        name: 'DenyInternetOutbound'
        description: 'Deny outbound to Internet'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: 'Internet'
        access: 'Deny'
        priority: 4000
        direction: 'Outbound'
      }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    enableFlowLogs: true
    tags: tags
  }
}

// NSG for Private Endpoints
module nsgPe '../../modules/networking/nsg/main.bicep' = {
  scope: resourceGroup
  name: 'deploy-nsg-pe'
  params: {
    nsgName: nsgPeSubnetName
    location: location
    securityRules: [
      {
        name: 'AllowVnetInbound'
        description: 'Allow traffic from VNet'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: 'VirtualNetwork'
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 100
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

// Route table for Web Tier (to Firewall)
module rtWeb '../../modules/networking/route-table/main.bicep' = {
  scope: resourceGroup
  name: 'deploy-rt-web'
  params: {
    routeTableName: rtWebName
    location: location
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'ToInternetViaFirewall'
        addressPrefix: '0.0.0.0/0'
        nextHopType: 'VirtualAppliance'
        nextHopIpAddress: azureFirewallPrivateIp
      }
    ]
    tags: tags
  }
}

// Route table for App Tier
module rtApp '../../modules/networking/route-table/main.bicep' = {
  scope: resourceGroup
  name: 'deploy-rt-app'
  params: {
    routeTableName: rtAppName
    location: location
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'ToInternetViaFirewall'
        addressPrefix: '0.0.0.0/0'
        nextHopType: 'VirtualAppliance'
        nextHopIpAddress: azureFirewallPrivateIp
      }
    ]
    tags: tags
  }
}

// Route table for Data Tier
module rtData '../../modules/networking/route-table/main.bicep' = {
  scope: resourceGroup
  name: 'deploy-rt-data'
  params: {
    routeTableName: rtDataName
    location: location
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'ToInternetViaFirewall'
        addressPrefix: '0.0.0.0/0'
        nextHopType: 'VirtualAppliance'
        nextHopIpAddress: azureFirewallPrivateIp
      }
    ]
    tags: tags
  }
}

// ============================================
// SPOKE VIRTUAL NETWORK
// ============================================

module spokeVnet '../../modules/networking/virtual-network/main.bicep' = {
  scope: resourceGroup
  name: 'deploy-spoke-vnet'
  params: {
    vnetName: spokeVnetName
    location: location
    addressPrefixes: [spokeVnetAddressPrefix]
    enableDdosProtection: enableDdosProtection
    ddosProtectionPlanId: ddosProtectionPlanId
    subnets: [
      {
        name: webSubnetName
        addressPrefix: webSubnetAddressPrefix
        networkSecurityGroupId: nsgWeb.outputs.nsgId
        routeTableId: rtWeb.outputs.routeTableId
        serviceEndpoints: [
          {
            service: 'Microsoft.Web'
          }
          {
            service: 'Microsoft.Storage'
          }
        ]
      }
      {
        name: appSubnetName
        addressPrefix: appSubnetAddressPrefix
        networkSecurityGroupId: nsgApp.outputs.nsgId
        routeTableId: rtApp.outputs.routeTableId
        serviceEndpoints: [
          {
            service: 'Microsoft.Web'
          }
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.KeyVault'
          }
          {
            service: 'Microsoft.Sql'
          }
        ]
      }
      {
        name: dataSubnetName
        addressPrefix: dataSubnetAddressPrefix
        networkSecurityGroupId: nsgData.outputs.nsgId
        routeTableId: rtData.outputs.routeTableId
        serviceEndpoints: [
          {
            service: 'Microsoft.Sql'
          }
          {
            service: 'Microsoft.Storage'
          }
        ]
      }
      {
        name: peSubnetName
        addressPrefix: privateEndpointsSubnetAddressPrefix
        networkSecurityGroupId: nsgPe.outputs.nsgId
        privateEndpointNetworkPolicies: 'Disabled'
      }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  dependsOn: [
    nsgWeb
    nsgApp
    nsgData
    nsgPe
    rtWeb
    rtApp
    rtData
  ]
}

// ============================================
// VNET PEERING TO HUB
// ============================================

// Peering from Spoke to Hub
module peeringToHub '../../modules/networking/vnet-peering/main.bicep' = {
  scope: resourceGroup
  name: 'deploy-peering-to-hub'
  params: {
    localVnetName: spokeVnetName
    remoteVnetId: hubVnetId
    peeringName: '${spokeVnetName}-to-hub'
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
  }
  dependsOn: [
    spokeVnet
  ]
}

// Peering from Hub to Spoke (deployed in Hub subscription/RG)
module peeringFromHub '../../modules/networking/vnet-peering/main.bicep' = {
  scope: resourceGroup(hubVnetSubscriptionId, hubVnetResourceGroupName)
  name: 'deploy-peering-from-hub-${workloadName}'
  params: {
    localVnetName: last(split(hubVnetId, '/'))
    remoteVnetId: spokeVnet.outputs.vnetId
    peeringName: 'hub-to-${spokeVnetName}'
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
  }
  dependsOn: [
    spokeVnet
  ]
}

// ============================================
// OUTPUTS
// ============================================

output resourceGroupName string = resourceGroup.name
output resourceGroupId string = resourceGroup.id

output spokeVnetId string = spokeVnet.outputs.vnetId
output spokeVnetName string = spokeVnet.outputs.vnetName
output spokeVnetAddressPrefix string = spokeVnetAddressPrefix

output webSubnetId string = '${spokeVnet.outputs.vnetId}/subnets/${webSubnetName}'
output appSubnetId string = '${spokeVnet.outputs.vnetId}/subnets/${appSubnetName}'
output dataSubnetId string = '${spokeVnet.outputs.vnetId}/subnets/${dataSubnetName}'
output privateEndpointsSubnetId string = '${spokeVnet.outputs.vnetId}/subnets/${peSubnetName}'

output nsgWebId string = nsgWeb.outputs.nsgId
output nsgAppId string = nsgApp.outputs.nsgId
output nsgDataId string = nsgData.outputs.nsgId
output nsgPeId string = nsgPe.outputs.nsgId
