// connectivity-lz/connectivity.bicepparam
// Parameters for connectivity hub deployment

using './connectivity.bicep'

// Organization configuration
param organizationName = 'acmy'
param environment = 'sbox' // prod, logs, quar, sbox
param location = 'caea' // canadacentral ou canadaeast

// Doit avoir été créé au préalable
param connectivityResourceGroupName = 'rg-${organizationName}-${environment}-${location}-networking'

// Hub VNet addressing
param hubVnetAddressPrefix = '10.0.0.0/16'
param gatewaySubnetAddressPrefix = '10.0.0.0/27' // 32 IPs — suffisant pour le gateway
param firewallSubnetAddressPrefix = '10.0.1.0/26' // 64 IPs — minimum recommandé pour Azure Firewall
param bastionSubnetAddressPrefix = '10.0.2.0/27' // 32 IPs — minimum requis pour Bastion
param managementSubnetAddressPrefix = '10.0.3.0/24'

// Feature toggles
param deployVpnGateway = true
param deployAzureFirewall = true
param deployBastion = true
param deployDdosProtection = true // Doit être activé pour l'environnement Production

// VPN Gateway configuration
// VpnGw1AZ nécessite Generation2 — les deux paramètres sont alignés
param vpnGatewaySku = 'VpnGw1AZ' // SKU zone-redondant recommandé pour prod
param vpnGatewayGeneration = 'Generation2' // Obligatoire pour les SKUs AZ

// Azure Firewall
param firewallSkuTier = 'Standard' // Utiliser 'Premium' pour IDPS, TLS inspection, URL filtering

// High availability — zones 1, 2, 3 pour canadacentral. ne pas spécifier pour canadaeast (pas de zones disponibles)
param availabilityZones = []

// Logging
param logAnalyticsWorkspaceId = '/subscriptions/0061dc3e-7704-4778-bcda-b566d000d486/resourceGroups/rg-acmy-sbox-caea-monitoring/providers/Microsoft.OperationalInsights/workspaces/law-acmy-sbox-caea'

// liste des tags à appliquer à toutes les ressources
param tags = {
  Application: 'Connectivity-LZ'
  Environnement: 'sbox'
  CreeLe: '2024-05-22'
  CreePar: 'Bicep'
  Criticite: 'Moyen'
  Responsable: 'CloudOps-Team'
  ResponsableEmail: 'cloudops@acmy.com'
}
