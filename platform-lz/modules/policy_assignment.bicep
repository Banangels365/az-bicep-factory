// platform-lz/modules/ppolicy_assignment.bicep
// Azure Policy Assignment module (management group scope)

targetScope = 'managementGroup'

@description('Policy assignment name')
param assignmentName string

@description('Display name for the assignment')
param displayName string

@description('Description of the assignment')
param assignmentDescription string = ''

@description('Policy definition ID or Initiative (Policy Set) ID')
param policyDefinitionId string

@description('Policy assignment parameters')
param parameters object = {}

@description('Policy assignment identity type (None, SystemAssigned, or UserAssigned)')
@allowed([
  'None'
  'SystemAssigned'
  'UserAssigned'
])
param identityType string = 'SystemAssigned'

@description('Location for the managed identity (required if identityType is SystemAssigned)')
param location string = 'canadacentral'

@description('Enforcement mode (Default or DoNotEnforce)')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

@description('Resource selectors to scope the assignment')
param resourceSelectors array = []

@description('Non-compliance messages')
param nonComplianceMessages array = []

@description('Metadata for the assignment')
param metadata object = {}

// ======================================================================
// Policy Assignment Resource
// ======================================================================
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: assignmentName

  // L'identité doit être conditionnelle
  location: identityType == 'SystemAssigned' ? location : null

  identity: identityType == 'None'
    ? null
    : {
        type: identityType
      }

  properties: {
    displayName: displayName
    description: assignmentDescription
    policyDefinitionId: policyDefinitionId
    parameters: parameters
    enforcementMode: enforcementMode

    // Ces propriétés doivent être null si vides
    resourceSelectors: resourceSelectors == [] ? null : resourceSelectors
    nonComplianceMessages: nonComplianceMessages == [] ? null : nonComplianceMessages
    metadata: metadata == {} ? null : metadata
  }
}

// ======================================================================
// Outputs
// ======================================================================
@description('Policy assignment ID')
output assignmentId string = policyAssignment.id

@description('Policy assignment name')
output assignmentName string = policyAssignment.name

@description('Policy assignment display name')
output displayName string = policyAssignment.properties.displayName

@description('Managed identity principal ID (if SystemAssigned)')
output principalId string = identityType == 'SystemAssigned' ? policyAssignment.identity.principalId : ''

@description('Managed identity tenant ID (if SystemAssigned)')
output tenantId string = identityType == 'SystemAssigned' ? policyAssignment.identity.tenantId : ''
