// connectivity-lz/connectivity.bicepparam
// Parameters for connectivity hub deployment

using './connectivity.bicep'

// Organization configuration
param organizationName = 'contoso'
param environment = 'prod'
param location = 'canadacentral'

// Hub VNet addressing
param hubVnetAddressPrefix = '10.0.0.0/16'
param gatewaySubnetAddressPrefix = '10.0.0.0/27'   // 32 IPs — suffisant pour le gateway
param firewallSubnetAddressPrefix = '10.0.1.0/26'  // 64 IPs — minimum recommandé pour Azure Firewall
param bastionSubnetAddressPrefix  = '10.0.2.0/27'  // 32 IPs — minimum requis pour Bastion
param managementSubnetAddressPrefix = '10.0.3.0/24'

// Feature toggles
param deployVpnGateway    = true
param deployAzureFirewall = true
param deployBastion       = true
param deployDdosProtection = true  // FIX: activé pour l'environnement Production

// VPN Gateway configuration
// FIX: VpnGw1AZ nécessite Generation2 — les deux paramètres sont alignés
param vpnGatewaySku        = 'VpnGw1AZ'   // SKU zone-redondant recommandé pour prod
param vpnGatewayGeneration = 'Generation2' // Obligatoire pour les SKUs AZ

// Azure Firewall
param firewallSkuTier = 'Standard' // Utiliser 'Premium' pour IDPS, TLS inspection, URL filtering

// High availability — zones 1, 2, 3 pour canadacentral
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
