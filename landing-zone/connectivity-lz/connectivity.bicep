// landing-zone/connectivity-lz/connectivity.bicep
// Hub Network orchestrator for Hub-Spoke topology

targetScope = 'subscription'

@description('Nom de l\'organisation')
param organizationName string

@description('Environnement')
@allowed([
  'prod' // production
  'logs' // logging/monitoring
  'quar' // quarantine
  'sbox' // sandbox
])
param environment string

@description('Région de déploiement')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('Connectivity Resource Group (doit être créé au préalable)')
param connectivityResourceGroupName string

@description('Préfixe d\'adresse du VNet du hub')
param hubVnetAddressPrefix string = '10.0.0.0/16'

@description('Préfixe d\'adresse du sous-réseau de la passerelle')
param gatewaySubnetAddressPrefix string = '10.0.0.0/27'

@description('Préfixe d\'adresse du sous-réseau d\'Azure Firewall')
param firewallSubnetAddressPrefix string = '10.0.1.0/26'

@description('Préfixe d\'adresse du sous-réseau de Bastion')
param bastionSubnetAddressPrefix string = '10.0.2.0/26'

@description('Préfixe d\'adresse du sous-réseau de gestion')
param managementSubnetAddressPrefix string = '10.0.3.0/24'

@description('Déployer le VPN Gateway')
param deployVpnGateway bool = true

@description('Déployer Azure Firewall')
param deployAzureFirewall bool = true

@description('Déployer Azure Bastion')
param deployBastion bool = true

@description('Déployer le plan de protection DDoS')
param deployDdosProtection bool = false

@description('SKU du VPN Gateway')
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

@description('Génération du VPN Gateway — Generation2 requis pour VpnGw4/5 et tous les SKUs AZ')
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

@description('Zones de disponibilité pour les ressources redondantes par zone')
param availabilityZones array = []

@description('ID de l\'espace de travail Log Analytics')
param logAnalyticsWorkspaceId string

@description('Tags à appliquer à toutes les ressources')
param tags object = {
  Environnement: environment
  Purpose: 'Hub-Network'
}

// ============================================
// VARIABLES
// ============================================

var hubVnetName = 'vnet-${organizationName}-hub-${environment}-${location}'
var firewallName = 'afw-${organizationName}-hub-${environment}-${location}'
var vpnGatewayName = 'vpngw-${organizationName}-hub-${environment}'
var bastionName = 'bas-${organizationName}-hub-${environment}'
var ddosProtectionPlanName = 'ddos-${organizationName}-${environment}'

// NSG names
var nsgManagementName = 'nsg-hub-${organizationName}-${environment}-${location}'
var nsgBastionName = 'nsg-bastion-${organizationName}-${environment}-${location}'

// Public IP names
var pipVpnGatewayName = 'pip-vpngw-${organizationName}-${environment}'
var pipFirewallName = 'pip-afw-${organizationName}-${environment}'
var pipBastionName = 'pip-bas-${organizationName}-${environment}'

// Route table names
var rtManagementName = 'rt-hub-${organizationName}-${environment}-${location}'

// ============================================
// PLAN DE PROTECTION DDoS
// ============================================

module ddosProtection '../../modules/networking/ddos_protection.bicep' = if (deployDdosProtection) {
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

module nsgManagement '../../modules/networking/network_security_group.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-nsg-management'
  params: {
    nsgName: nsgManagementName
    location: location
    securityRules: [
      // nsgManagement — règles management uniquement
      {
        name: 'AllowRDP'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '3389'
        sourceAddressPrefix: bastionSubnetAddressPrefix
        destinationAddressPrefix: managementSubnetAddressPrefix
        access: 'Allow'
        priority: 100
        direction: 'Inbound'
      }
      {
        name: 'AllowSSH'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '22'
        sourceAddressPrefix: bastionSubnetAddressPrefix
        destinationAddressPrefix: managementSubnetAddressPrefix
        access: 'Allow'
        priority: 110
        direction: 'Inbound'
      }
      {
        name: 'DenyAllInbound'
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

// NSG dédié au subnet Bastion pour permettre des règles spécifiques (ex: autoriser uniquement le port 22/3389 depuis le subnet management, et pas depuis tout le VNet)
module nsgBastion '../../modules/networking/network_security_group.bicep' = if (deployBastion) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-nsg-bastion'
  params: {
    nsgName: nsgBastionName
    location: location
    securityRules: [
      // -- INBOUND ---
      {
        name: 'AllowHttpsInbound'
        description: 'Required: HTTPS from Internet'
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
        description: 'Required: Bastion control plane'
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
        description: 'Required: health probes'
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
        name: 'AllowBastionHostCommunicationInbound'
        description: 'Required: host-to-host'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRanges: ['5701', '8080']
        sourceAddressPrefix: 'VirtualNetwork'
        destinationAddressPrefix: 'VirtualNetwork'
        access: 'Allow'
        priority: 130
        direction: 'Inbound'
      }
      // ----- OUTBOUND ---------
      {
        name: 'AllowSshRdpOutbound'
        description: 'Required: SSH/RDP to target VMs'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRanges: ['22', '3389']
        sourceAddressPrefix: '*'
        destinationAddressPrefix: 'VirtualNetwork'
        access: 'Allow'
        priority: 100
        direction: 'Outbound'
      }
      {
        name: 'AllowAzureCloudOutbound'
        description: 'Required: Bastion control plane outbound'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '443'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: 'AzureCloud'
        access: 'Allow'
        priority: 110
        direction: 'Outbound'
      }
      {
        name: 'AllowBastionCommunicationOutbound'
        description: 'Required: host-to-host outbound'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRanges: ['5701', '8080']
        sourceAddressPrefix: '*'
        destinationAddressPrefix: 'VirtualNetwork'
        access: 'Allow'
        priority: 120
        direction: 'Outbound'
      }
      {
        name: 'AllowGetSessionInformation'
        description: 'Required: session info via HTTP'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '80'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: 'Internet'
        access: 'Allow'
        priority: 130
        direction: 'Outbound'
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

module pipVpnGateway '../../modules/networking/public_ip.bicep' = if (deployVpnGateway) {
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

module pipFirewall '../../modules/networking/public_ip.bicep' = if (deployAzureFirewall) {
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

module pipBastion '../../modules/networking/public_ip.bicep' = if (deployBastion) {
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

module hubVnet '../../modules/networking/virtual_network.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-hub-vnet'
  params: {
    vnetName: hubVnetName
    location: location
    addressPrefixes: [hubVnetAddressPrefix]
    enableDdosProtection: deployDdosProtection
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
        networkSecurityGroupId: nsgBastion.?outputs.nsgId ?? '' // NSG dédié Bastion
      }
      {
        name: 'snet-hub-management'
        addressPrefix: managementSubnetAddressPrefix
        networkSecurityGroupId: nsgManagement.?outputs.nsgId ?? '' // NSG de management
        // routeTableId sera appliqué en phase 2 après le déploiement du Firewall
      }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
}

// ============================================
// AZURE FIREWALL
// Déployé après le VNet pour obtenir l'IP privée
// qui sera utilisée dans la route table (phase 2).
// ============================================

module azureFirewall '../../modules/networking/azure_firewall.bicep' = if (deployAzureFirewall) {
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
}

// ============================================
// ROUTE TABLE (phase 2)
// Créée après le Firewall pour utiliser son IP privée.
// ============================================

module routeTableManagement '../../modules/networking/route_table.bicep' = {
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
            nextHopIpAddress: azureFirewall.?outputs.privateIpAddress ?? ''
          }
        ]
      : []
    tags: tags
  }
}

// ============================================
// SUBNET MANAGEMENT — Phase 2
// Mise à jour du subnet management avec la route table
// maintenant que le Firewall et son IP sont disponibles.
// ============================================

module managementSubnet '../../modules/networking/subnet.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-subnet-management-phase2'
  params: {
    vnetName: hubVnetName
    subnetName: 'snet-hub-management'
    addressPrefix: managementSubnetAddressPrefix
    networkSecurityGroupId: nsgManagement.?outputs.nsgId ?? ''
    routeTableId: routeTableManagement.outputs.routeTableId
  }
}

// ============================================
// Passerelle VPN (VPN Gateway)
// ============================================

module vpnGateway '../../modules/networking/vpn_gateway.bicep' = if (deployVpnGateway) {
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
}

// ============================================
// AZURE BASTION
// ============================================

module bastion '../../modules/networking/azure_bastion.bicep' = if (deployBastion) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-bastion'
  params: {
    bastionName: bastionName
    location: location
    sku: 'Standard'
    subnetId: '${hubVnet.outputs.vnetId}/subnets/AzureBastionSubnet'
    publicIpAddressId: pipBastion.?outputs.publicIpId ?? ''
    enableFileCopy: true
    enableTunneling: true
    scaleUnits: 2
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
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

output vpnGatewayId string = vpnGateway.?outputs.vpnGatewayId ?? ''
output azureFirewallId string = azureFirewall.?outputs.firewallId ?? ''
output azureFirewallPrivateIp string = azureFirewall.?outputs.privateIpAddress ?? ''
output bastionId string = bastion.?outputs.bastionId ?? ''
output ddosProtectionPlanId string = ddosProtection.?outputs.ddosProtectionPlanId ?? ''
