// platform-lz/modules/policy_definition.bicep
// Azure Policy Definition module

targetScope = 'managementGroup'

@description('Policy definition name')
param policyName string

@description('Display name for the policy')
param displayName string

@description('Description of the policy')
param policyDescription string

@description('Policy type (BuiltIn, Custom, or Static)')
@allowed([
  'BuiltIn'
  'Custom'
  'Static'
])
param policyType string = 'Custom'

@description('Policy mode (All, Indexed, or Microsoft.KeyVault.Data)')
@allowed([
  'All'
  'Indexed'
  'Microsoft.KeyVault.Data'
  'Microsoft.Kubernetes.Data'
  'Microsoft.Network.Data'
])
param mode string = 'All'

@description('Policy metadata')
param metadata object = {
  version: '1.0.0'
  category: 'Custom'
}

@description('Policy parameters')
param parameters object = {}

@description('Policy rule definition')
param policyRule object

// Policy Definition Resource
resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: policyName
  properties: {
    displayName: displayName
    description: policyDescription
    policyType: policyType
    mode: mode
    metadata: metadata
    parameters: parameters
    policyRule: policyRule
  }
}

// Outputs
@description('Policy definition ID')
output policyDefinitionId string = policyDefinition.id

@description('Policy definition name')
output policyDefinitionName string = policyDefinition.name

@description('Policy display name')
output displayName string = policyDefinition.properties.displayName
