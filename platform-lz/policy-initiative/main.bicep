// platform-lz/policy-initiative/main.bicep
// Azure Policy Initiative (Policy Set Definition) module

targetScope = 'managementGroup'

@description('Initiative name')
param initiativeName string

@description('Display name for the initiative')
param displayName string

@description('Description of the initiative')
param initiativeDescription string

@description('Initiative type (BuiltIn or Custom)')
@allowed([
  'BuiltIn'
  'Custom'
])
param policyType string = 'Custom'

@description('Initiative metadata')
param metadata object = {
  version: '1.0.0'
  category: 'Custom'
}

@description('Initiative parameters')
param parameters object = {}

@description('Array of policy definitions to include in the initiative')
param policyDefinitions array

@description('Policy definition groups for organization')
param policyDefinitionGroups array = []

// Policy Set Definition (Initiative) Resource
resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: initiativeName
  properties: {
    displayName: displayName
    description: initiativeDescription
    policyType: policyType
    metadata: metadata
    parameters: parameters
    policyDefinitions: policyDefinitions
    policyDefinitionGroups: !empty(policyDefinitionGroups) ? policyDefinitionGroups : null
  }
}

// Outputs
@description('Policy initiative ID')
output initiativeId string = policySetDefinition.id

@description('Policy initiative name')
output initiativeName string = policySetDefinition.name

@description('Policy initiative display name')
output displayName string = policySetDefinition.properties.displayName
