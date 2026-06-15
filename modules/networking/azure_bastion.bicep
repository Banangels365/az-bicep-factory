// modules/networking/azure_bastion.bicep
// Azure Bastion module for secure RDP/SSH access

@description('Nom Azure Bastion')
param bastionName string

@description('Région pour le bastion')
param location string

@description('SKU du bastion')
@allowed([
  'Basic'
  'Standard'
])
param sku string = 'Standard'

@description('ID du sous-réseau pour le bastion (AzureBastionSubnet)')
param subnetId string

@description('ID de ressource d\'adresse IP publique pour le bastion')
param publicIpAddressId string

@description('Activer la fonctionnalité de connexion IP (SKU Standard uniquement)')
param enableIpConnect bool = false

@description('Activer la fonctionnalité de lien partageable (SKU Standard uniquement)')
param enableShareableLink bool = false

@description('Activer la fonctionnalité de tunneling (SKU Standard uniquement)')
param enableTunneling bool = false

@description('Activer la fonctionnalité de copie de fichiers (SKU Standard uniquement)')
param enableFileCopy bool = false

@description('Unités d\'échelle (2-50, SKU Standard uniquement)')
@minValue(2)
@maxValue(50)
param scaleUnits int = 2

@description('Tags à appliquer au bastion')
param tags object = {}

@description('Activer les paramètres de diagnostic')
param enableDiagnostics bool = true

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string = ''

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// Azure Bastion Resource
resource bastion 'Microsoft.Network/bastionHosts@2023-09-01' = {
  name: bastionName
  location: resolvedLocation
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
@description('ID Azure Bastion')
output bastionId string = bastion.id

@description('Nom Azure Bastion')
output bastionName string = bastion.name

@description('Nom DNS Azure Bastion')
output dnsName string = bastion.properties.dnsName
