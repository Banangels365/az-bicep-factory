// connectivity-lz/modules/private_dns_zone.bicep
// Private DNS Zone module for Private Endpoints

@description('Private DNS Zone name')
param privateDnsZoneName string

@description('Virtual Network IDs to link to the DNS zone')
param vnetLinksVnetIds array = []

@description('Enable auto-registration for VNet links')
param enableAutoRegistration bool = false

@description('Tags to apply to the private DNS zone')
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
@description('Private DNS Zone resource ID')
output privateDnsZoneId string = privateDnsZone.id

@description('Private DNS Zone name')
output privateDnsZoneName string = privateDnsZone.name

@description('Virtual Network Link IDs')
output vnetLinkIds array = [for (vnetId, i) in vnetLinksVnetIds: vnetLinks[i].id]
