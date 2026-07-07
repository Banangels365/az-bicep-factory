// modules/authorization/managed_identity.bicep
// Managed Identity module (User-Assigned)

@description('Nom de l\'identité managée')
param managedIdentityName string

@description('Emplacement pour l\'identité managée')
param location string = resourceGroup().location

@description('Tags à associer à l\'identité managée')
param tags object = {}

// User-Assigned Managed Identity Resource
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: tags
}

// Outputs
@description('ID de l\'identité managée')
output managedIdentityId string = managedIdentity.id

@description('Nom de l\'identité managée')
output managedIdentityName string = managedIdentity.name

@description('ID principal de l\'identité managée')
output principalId string = managedIdentity.properties.principalId

@description('ID client de l\'identité managée')
output clientId string = managedIdentity.properties.clientId

@description('ID tenant de l\'identité managée')
output tenantId string = managedIdentity.properties.tenantId
