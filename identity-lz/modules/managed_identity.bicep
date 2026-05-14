// identity-lz/modules/managed_identity.bicep
// Managed Identity module (User-Assigned)

@description('Managed Identity name')
param managedIdentityName string

@description('Location for the managed identity')
param location string = resourceGroup().location

@description('Tags to apply to the managed identity')
param tags object = {}

// User-Assigned Managed Identity Resource
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: tags
}

// Outputs
@description('Managed Identity resource ID')
output managedIdentityId string = managedIdentity.id

@description('Managed Identity name')
output managedIdentityName string = managedIdentity.name

@description('Managed Identity principal ID')
output principalId string = managedIdentity.properties.principalId

@description('Managed Identity client ID')
output clientId string = managedIdentity.properties.clientId

@description('Managed Identity tenant ID')
output tenantId string = managedIdentity.properties.tenantId
