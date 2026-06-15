// modules/networking/public_ip.bicep
// Public IP Address module

@description('Nom de l\'adresse IP publique')
param publicIpName string

@description('Région pour l\'adresse IP publique')
param location string

@description('SKU de l\'adresse IP publique')
@allowed([
  'Basic'
  'Standard'
])
param sku string = 'Standard'

@description('Méthode d\'allocation de l\'adresse IP publique')
@allowed([
  'Dynamic'
  'Static'
])
param allocationMethod string = 'Static'

@description('Version de l\'adresse IP publique')
@allowed([
  'IPv4'
  'IPv6'
])
param publicIpAddressVersion string = 'IPv4'

@description('Temps d\'inactivité avant déallocation de l\'adresse IP publique (en minutes, 4-30)')
@minValue(4)
@maxValue(30)
param idleTimeoutInMinutes int = 4

@description('Label pour le nom de domaine DNS')
param domainNameLabel string = ''

@description('Zones de disponibilité pour l\'adresse IP publique')
param zones array = []

@description('Mode de protection DDoS pour l\'adresse IP publique')
@allowed([
  'Disabled'
  'Enabled'
  'VirtualNetworkInherited'
])
param ddosProtectionMode string = 'VirtualNetworkInherited'

@description('DDoS Protection Plan ID')
param ddosProtectionPlanId string = ''

@description('Tags à appliquer à l\'adresse IP publique')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Workspace Log Analytics pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// Public IP Address Resource
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIpName
  location: resolvedLocation
  tags: tags
  sku: {
    name: sku
    tier: 'Regional'
  }
  zones: !empty(zones) ? zones : null
  properties: union(
    {
      publicIPAllocationMethod: allocationMethod
      publicIPAddressVersion: publicIpAddressVersion
      idleTimeoutInMinutes: idleTimeoutInMinutes
    },
    !empty(domainNameLabel) ? { dnsSettings: { domainNameLabel: domainNameLabel } } : {},
    ddosProtectionMode != 'Disabled'
      ? {
          ddosSettings: union(
            { protectionMode: ddosProtectionMode },
            !empty(ddosProtectionPlanId) ? { ddosProtectionPlan: { id: ddosProtectionPlanId } } : {}
          )
        }
      : {}
  )
}

// Diagnostic Settings — métriques seulement si DDoS désactivé
resource diagnosticSettingsMetricsOnly 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId) && ddosProtectionMode == 'Disabled') {
  scope: publicIp
  name: '${publicIpName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// Diagnostic Settings — logs + métriques si DDoS actif
resource diagnosticSettingsWithLogs 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId) && ddosProtectionMode != 'Disabled') {
  scope: publicIp
  name: '${publicIpName}-diagnostics'
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
@description('ID de l\'adresse IP publique')
output publicIpId string = publicIp.id

@description('Nom de l\'adresse IP publique')
output publicIpName string = publicIp.name

@description('Adresse IP publique (une fois attribuée)')
output ipAddress string = publicIp.properties.ipAddress

@description('Nom de domaine pleinement qualifié')
output fqdn string = !empty(domainNameLabel) ? publicIp.properties.dnsSettings.fqdn : ''
