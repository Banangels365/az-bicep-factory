// connectivity-lz/connectivity.bicep
// Hub Network orchestrator for Hub-Spoke topology

targetScope = 'subscription'

@description('Organization name')
param organizationName string

@description('Environment')
@allowed([
  'prod' // production
  'logs' // logging/monitoring
  'quar' // quarantine
  'sbox' // sandbox
])
param environment string

@description('Azure region for hub resources')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('Connectivity Resource Group (must exist prior to deployment)')
param connectivityResourceGroupName string

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
  'VpnGw4'
  'VpnGw5'
  'VpnGw1AZ'
  'VpnGw2AZ'
  'VpnGw3AZ'
  'VpnGw4AZ'
  'VpnGw5AZ'
])
param vpnGatewaySku string = 'VpnGw1'

@description('VPN Gateway generation — Generation2 required for VpnGw4/5 and all AZ SKUs')
@allowed([
  'Generation1'
  'Generation2'
])
param vpnGatewayGeneration string = 'Generation1'

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
  Environnement: environment
  ManagedBy: 'Bicep'
  Purpose: 'Hub-Network'
}

// ============================================
// VARIABLES
// ============================================

var hubVnetName = 'vnet-${organizationName}-hub-${environment}-${location}'
var firewallName = 'afw-${organizationName}-hub-${environment}'
var vpnGatewayName = 'vpngw-${organizationName}-hub-${environment}'
var bastionName = 'bas-${organizationName}-hub-${environment}'
var ddosProtectionPlanName = 'ddos-${organizationName}-${environment}'

// NSG names
var nsgManagementName = 'nsg-hub-${environment}-${location}'

// Public IP names
var pipVpnGatewayName = 'pip-vpngw-${environment}'
var pipFirewallName = 'pip-afw-${environment}'
var pipBastionName = 'pip-bas-${environment}'

// Route table names
var rtManagementName = 'rt-hub-${environment}-${location}'

// ============================================
// DDoS PROTECTION PLAN
// ============================================

module ddosProtection './modules/ddos_protection.bicep' = if (deployDdosProtection) {
  scope: resourceGroup(connectivityResourceGroupName)
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
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-nsg-management'
  params: {
    nsgName: nsgManagementName
    location: location
    securityRules: [
      // --- Bastion mandatory inbound rules (per Microsoft documentation) ---
      {
        name: 'AllowHttpsInbound'
        description: 'Allow HTTPS from Internet to Bastion'
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
        name: 'AllowGatewayManagerInbound'
        description: 'Allow GatewayManager inbound (required by Bastion)'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '443'
        sourceAddressPrefix: 'GatewayManager'
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 110
        direction: 'Inbound'
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        description: 'Allow Azure Load Balancer health probes'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '443'
        sourceAddressPrefix: 'AzureLoadBalancer'
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 120
        direction: 'Inbound'
      }
      {
        name: 'AllowBastionHostCommunication'
        description: 'Allow Bastion host-to-host communication'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRanges: ['5701', '8080']
        sourceAddressPrefix: 'VirtualNetwork'
        destinationAddressPrefix: 'VirtualNetwork'
        access: 'Allow'
        priority: 130
        direction: 'Inbound'
      }
      // --- Management subnet rules ---
      {
        name: 'AllowRDP'
        description: 'Allow RDP from Bastion subnet'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '3389'
        sourceAddressPrefix: bastionSubnetAddressPrefix
        destinationAddressPrefix: managementSubnetAddressPrefix
        access: 'Allow'
        priority: 200
        direction: 'Inbound'
      }
      {
        name: 'AllowSSH'
        description: 'Allow SSH from Bastion subnet'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '22'
        sourceAddressPrefix: bastionSubnetAddressPrefix
        destinationAddressPrefix: managementSubnetAddressPrefix
        access: 'Allow'
        priority: 210
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
// PUBLIC IP ADDRESSES
// Déployées tôt pour que le Firewall resolve son IP privée
// avant la création de la route table.
// ============================================

module pipVpnGateway './modules/public_ip.bicep' = if (deployVpnGateway) {
  scope: resourceGroup(connectivityResourceGroupName)
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
  scope: resourceGroup(connectivityResourceGroupName)
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
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-pip-bastion'
  params: {
    publicIpName: pipBastionName
    location: location
    sku: 'Standard'
    allocationMethod: 'Static'
    zones: availabilityZones
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
}

// ============================================
// HUB VIRTUAL NETWORK (phase 1 — sans NSG/UDR sur le management subnet)
// On crée d'abord le VNet pour obtenir son ID, puis on déploie
// le Firewall, et enfin la route table pointant vers le Firewall.
// Le subnet management est mis à jour dans une passe séparée via
// le module subnet.bicep (phase 2, voir plus bas).
// ============================================

module hubVnet './modules/virtual_network.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-hub-vnet'
  params: {
    vnetName: hubVnetName
    location: location
    addressPrefixes: [hubVnetAddressPrefix]
    enableDdosProtection: deployDdosProtection
    // FIX BCP318 : opérateur ?. pour accéder à l'output d'un module conditionnel.
    // Si ddosProtection n'est pas déployé, l'expression retourne null, et ?? fournit ''.
    ddosProtectionPlanId: ddosProtection.?outputs.ddosProtectionPlanId ?? ''
    subnets: [
      {
        name: 'GatewaySubnet'
        addressPrefix: gatewaySubnetAddressPrefix
        // GatewaySubnet ne doit PAS avoir de NSG ni de route table
      }
      {
        name: 'AzureFirewallSubnet'
        addressPrefix: firewallSubnetAddressPrefix
        // AzureFirewallSubnet ne doit PAS avoir de NSG ni de route table
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: bastionSubnetAddressPrefix
        // AzureBastionSubnet ne doit PAS avoir de route table
        networkSecurityGroupId: nsgManagement.outputs.nsgId
      }
      {
        name: 'snet-hub-management'
        addressPrefix: managementSubnetAddressPrefix
        networkSecurityGroupId: nsgManagement.outputs.nsgId
        // routeTableId sera appliqué en phase 2 après le déploiement du Firewall
      }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  // dependsOn supprimé : nsgManagement.outputs.nsgId est référencé dans params.subnets
  // → Bicep infère la dépendance implicitement (no-unnecessary-dependson)
}

// ============================================
// AZURE FIREWALL
// Déployé après le VNet pour obtenir l'IP privée
// qui sera utilisée dans la route table (phase 2).
// ============================================

module azureFirewall './modules/azure_firewall.bicep' = if (deployAzureFirewall) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-azure-firewall'
  params: {
    firewallName: firewallName
    location: location
    skuName: 'AZFW_VNet'
    skuTier: firewallSkuTier
    subnetId: '${hubVnet.outputs.vnetId}/subnets/AzureFirewallSubnet'
    publicIpAddressIds: [
      pipFirewall.?outputs.publicIpId ?? ''
    ]
    zones: availabilityZones
    enableDnsProxy: true
    threatIntelMode: 'Alert'
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  // dependsOn supprimé : hubVnet.outputs.vnetId et pipFirewall.?outputs.publicIpId
  // sont référencés dans params → dépendances implicites (no-unnecessary-dependson)
}

// ============================================
// ROUTE TABLE (phase 2)
// Créée après le Firewall pour utiliser son IP privée.
// ============================================

module routeTableManagement './modules/route_table.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-rt-management'
  params: {
    routeTableName: rtManagementName
    location: location
    disableBgpRoutePropagation: true
    routes: deployAzureFirewall
      ? [
          {
            name: 'DefaultToFirewall'
            addressPrefix: '0.0.0.0/0'
            nextHopType: 'VirtualAppliance'
            // FIX BCP318 : opérateur ?. sur le module conditionnel azureFirewall.
            // Si deployAzureFirewall est false, cette branche du ternaire n'est jamais évaluée,
            // mais Bicep analyse quand même l'expression → ?. + ?? nécessaires.
            nextHopIpAddress: azureFirewall.?outputs.privateIpAddress ?? ''
          }
        ]
      : []
    tags: tags
  }
  // dependsOn supprimé : azureFirewall.?outputs.privateIpAddress est référencé dans params.routes
  // → dépendance implicite sur azureFirewall (no-unnecessary-dependson)
}

// ============================================
// SUBNET MANAGEMENT — Phase 2
// Mise à jour du subnet management avec la route table
// maintenant que le Firewall et son IP sont disponibles.
// ============================================

module managementSubnet './modules/subnet.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-subnet-management-phase2'
  params: {
    vnetName: hubVnetName
    subnetName: 'snet-hub-management'
    addressPrefix: managementSubnetAddressPrefix
    networkSecurityGroupId: nsgManagement.outputs.nsgId
    routeTableId: routeTableManagement.outputs.routeTableId
  }
  // dependsOn supprimé : hubVnetName est un param string (pas un output),
  // mais nsgManagement.outputs.nsgId et routeTableManagement.outputs.routeTableId
  // sont référencés dans params → toutes les dépendances sont implicites (no-unnecessary-dependson)
}

// ============================================
// VPN GATEWAY
// ============================================

module vpnGateway './modules/vpn_gateway.bicep' = if (deployVpnGateway) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-vpn-gateway'
  params: {
    vpnGatewayName: vpnGatewayName
    location: location
    gatewaySku: vpnGatewaySku
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    vpnGatewayGeneration: vpnGatewayGeneration
    subnetId: '${hubVnet.outputs.vnetId}/subnets/GatewaySubnet'
    // FIX BCP318 : opérateur ?. sur le module conditionnel pipVpnGateway.
    publicIpAddressId: pipVpnGateway.?outputs.publicIpId ?? ''
    enableBgp: false
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  // dependsOn supprimé : hubVnet.outputs.vnetId et pipVpnGateway.?outputs.publicIpId
  // sont référencés dans params → dépendances implicites (no-unnecessary-dependson)
}

// ============================================
// AZURE BASTION
// ============================================

module bastion './modules/azure_bastion.bicep' = if (deployBastion) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-bastion'
  params: {
    bastionName: bastionName
    location: location
    sku: 'Standard'
    subnetId: '${hubVnet.outputs.vnetId}/subnets/AzureBastionSubnet'
    // FIX BCP318 : opérateur ?. sur le module conditionnel pipBastion.
    publicIpAddressId: pipBastion.?outputs.publicIpId ?? ''
    enableFileCopy: true
    enableTunneling: true
    scaleUnits: 2
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  // dependsOn supprimé : hubVnet.outputs.vnetId et pipBastion.?outputs.publicIpId
  // sont référencés dans params → dépendances implicites (no-unnecessary-dependson)
}

// ============================================
// OUTPUTS
// ============================================

output hubVnetId string = hubVnet.outputs.vnetId
output hubVnetName string = hubVnet.outputs.vnetName
output hubVnetAddressPrefix string = hubVnetAddressPrefix

output gatewaySubnetId string = '${hubVnet.outputs.vnetId}/subnets/GatewaySubnet'
output firewallSubnetId string = '${hubVnet.outputs.vnetId}/subnets/AzureFirewallSubnet'
output bastionSubnetId string = '${hubVnet.outputs.vnetId}/subnets/AzureBastionSubnet'
output managementSubnetId string = '${hubVnet.outputs.vnetId}/subnets/snet-hub-management'

// FIX BCP318 : même pattern ?. ?? '' appliqué sur tous les outputs conditionnels.
output vpnGatewayId string = vpnGateway.?outputs.vpnGatewayId ?? ''
output azureFirewallId string = azureFirewall.?outputs.firewallId ?? ''
output azureFirewallPrivateIp string = azureFirewall.?outputs.privateIpAddress ?? ''
output bastionId string = bastion.?outputs.bastionId ?? ''
output ddosProtectionPlanId string = ddosProtection.?outputs.ddosProtectionPlanId ?? ''
