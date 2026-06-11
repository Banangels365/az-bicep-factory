// connectivity-lz/modules/private_dns_zone.bicep
// Private DNS Zone module for Private Endpoints

@description('Nom de la Zone Private DNS')
param privateDnsZoneName string

@description('IDs des Réseaux Virtuels à lier à la zone DNS')
param vnetLinksVnetIds array = []

@description('Activer l\'enregistrement automatique des VMs. Limité à un seul VNet par zone DNS privée.')
param enableAutoRegistration bool = false

@description('Tags à appliquer à la zone DNS privée')
param tags object = {}

// Private DNS Zone Resource
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
  tags: tags
  properties: {}
}

// Virtual Network Links
resource vnetLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [
  for (vnetId, i) in vnetLinksVnetIds: {
    parent: privateDnsZone
    name: 'link-${uniqueString(vnetId)}'
    location: 'global'
    tags: tags
    properties: {
      registrationEnabled: enableAutoRegistration
      virtualNetwork: {
        id: vnetId
      }
    }
  }
]

// Outputs
@description('ID de la Zone Private DNS')
output privateDnsZoneId string = privateDnsZone.id

@description('Nom de la Zone Private DNS')
output privateDnsZoneName string = privateDnsZone.name

@description('IDs des Liens de Réseau Virtuel')
output vnetLinkIds array = [for (vnetId, i) in vnetLinksVnetIds: vnetLinks[i].id]
