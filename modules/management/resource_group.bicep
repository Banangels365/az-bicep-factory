// modules/management/resource_group.bicep
// Module de groupe de ressources pour la création de groupes de ressources dans une subscription

targetScope = 'subscription'

@description('Nom du groupe de ressources')
param resourceGroupName string

@description('Région pour le groupe de ressources')
param location string

@description('Tags')
param tags object = {}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// Outputs

@description('ID du groupe de ressources créé')
output resourceGroupId string = resourceGroup.id

@description('Nom du groupe de ressources créé')
output resourceGroupName string = resourceGroup.name
