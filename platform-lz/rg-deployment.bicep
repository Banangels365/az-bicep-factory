// rg-deployment.bicep
// Separate template to create resource groups in a specific subscription
// Deploy after main.bicep to add RGs to new subscriptions

targetScope = 'subscription'

@description('Environment (used for tagging and naming)')
@allowed([
  'prod'
  'dev'
  'logging'
  'quarantine'
  'sandbox'
])
param environment string = 'sandbox'

@description('Azure region for resources')
@allowed([
  'canadacentral'
  'canadaeast'
  'eastus'
  'westus'
])
param location string = 'canadacentral'

@description('Tags to apply to all resources')
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  CostCenter: 'Platform'
  Owner: 'CloudOps'
}

// Resource Groups
resource networkingRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environment}-${location}-networking'
  location: location
  tags: tags
}

resource identityRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environment}-${location}-identity'
  location: location
  tags: tags
}

resource securityRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environment}-${location}-security'
  location: location
  tags: tags
}

resource operationsRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environment}-${location}-operations'
  location: location
  tags: tags
}

// Outputs
output networkingRgId string = networkingRg.id
output identityRgId string = identityRg.id
output securityRgId string = securityRg.id
output operationsRgId string = operationsRg.id
