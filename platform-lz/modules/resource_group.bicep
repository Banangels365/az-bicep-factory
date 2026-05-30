// platform-lz/modules/resource_group.bicep
// Resource Group module for centralized resource management

targetScope = 'subscription'

@description('Nom du groupe de ressources')
param resourceGroupName string

@description('Région pour le groupe de ressources')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('Tags')
param tags object = {}

// Variables
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resolvedLocation
  tags: tags
}

output resourceGroupId string = resourceGroup.id
output resourceGroupName string = resourceGroup.name
