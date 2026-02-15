// az-platform-lz/resource-group/main.bicep
// Resource Group module for centralized resource management

targetScope = 'subscription'

@description('Resource Group name')
param resourceGroupName string

@description('Location')
param location string

@description('Tags')
param tags object = {}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

output resourceGroupId string = resourceGroup.id
output resourceGroupName string = resourceGroup.name
