/*
01_Tagging_Policy.bicep - Initiative regroupant des policies de tagging pour les Resource Groups

Ce BICEP créer 2 initiative qui force des tags sur des resources groups.

- La première initiative (initiativeCustomPoliciesTags) utilise des policy definitions custom
  - Chaque policy definition valide la présence d'un tag avec des valeurs autorisées
  - La liste des tags à valider est passée en paramètre (customPoliciesTags)

- La deuxième initiative (initiativeBuiltinPoliciesTags) utilise des policy definitions built-in
  - Deux types de policy definitions built-in sont utilisées:
    - "Require a tag on resource groups" (871b6d14-10aa-478d-b590-94f262ecfa99)
    - "Inherit a tag from the resource group if missing" (ea3f2387-9b95-492a-a190-fcdc54f7b070)

*/

targetScope = 'subscription'

@description('Région utilisée pour assignation des politiques au niveau du management group')
param location string = deployment().location

// -------------------------------
// Typage strict des paramètres
// -------------------------------
type CustomTagPolicy = {
  name: string
  displayName: string
  field: string
  allowedValues: array
  nonComplianceMessage: string
}

type BuiltinTagPolicy = {
  Name: string
  type: string // "requiredOnResourceGroup" ou "inheritFromResourceGroup"
}

param initiativeCustomPoliciesName string
param initiativeCustomPoliciesDisplayName string
param initiativeBuiltinPoliciesName string
param initiativeBuiltinPoliciesDisplayName string

param customPoliciesTags array = [] // array<CustomTagPolicy>
param builtinPoliciesTags array = [] // array<BuiltinTagPolicy>

// -------------------------------
// Built-in Policy Definition IDs
// -------------------------------
var requireTagOnResourceGroupsId = '/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025'
var inheritTagFromResourceGroupIfMissingId = '/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070'

// ======================================================================
// 1) Policy Definitions Custom
// ======================================================================
resource policyDefinitionsResources 'Microsoft.Authorization/policyDefinitions@2021-06-01' = [
  for (policy, index) in customPoliciesTags: {
    name: policy.name
    properties: {
      displayName: policy.displayName
      metadata: {
        category: 'Tags'
        version: '1.0.0'
      }
      policyType: 'Custom'
      mode: 'All'
      parameters: {}
      policyRule: {
        if: {
          allOf: [
            {
              field: 'type'
              equals: 'Microsoft.Resources/subscriptions/resourceGroups'
            }
            {
              field: policy.field
              notIn: policy.allowedValues
            }
          ]
        }
        then: {
          effect: 'deny'
        }
      }
    }
  }
]

// ======================================================================
// 2) Initiative Custom regroupant les Policy Definitions Custom
// ======================================================================
resource initiativeCustomPoliciesTags 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: initiativeCustomPoliciesName
  properties: {
    policyType: 'Custom'
    displayName: initiativeCustomPoliciesDisplayName
    metadata: {
      category: 'Tags'
      version: '1.0.0'
    }
    policyDefinitions: [
      for (policy, index) in customPoliciesTags: {
        policyDefinitionReferenceId: 'require-${policy.name}'
        policyDefinitionId: policyDefinitionsResources[index].id
        parameters: {}
      }
    ]
  }
}

// ======================================================================
// 3) Initiative Built-in regroupant les Policy Definitions Built-in
// ======================================================================
resource initiativeBuiltinPoliciesTags 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: initiativeBuiltinPoliciesName
  properties: {
    policyType: 'Custom'
    displayName: initiativeBuiltinPoliciesDisplayName
    metadata: {
      category: 'Tags'
      version: '1.0.0'
    }
    policyDefinitions: [
      for (tag, index) in builtinPoliciesTags: {
        policyDefinitionReferenceId: tag.type == 'requiredOnResourceGroup'
          ? 'require-${tag.Name}-tag-on-rg'
          : 'inherit-${tag.Name}-tag-from-rg'

        policyDefinitionId: tag.type == 'requiredOnResourceGroup'
          ? requireTagOnResourceGroupsId
          : inheritTagFromResourceGroupIfMissingId

        parameters: {
          tagName: {
            value: tag.Name
          }
        }
      }
    ]
  }
}

// ======================================================================
// 4) Messages de non-conformité dynamiques (Custom uniquement)
// ======================================================================
var dynamicMessages = [
  for policy in customPoliciesTags: {
    policyDefinitionReferenceId: 'require-${policy.name}'
    message: policy.nonComplianceMessage
  }
]

var allMessagesdynamicMessagesCustomPoliciesTags = union(
  [
    {
      message: 'Message général de non-conformité de Tags avec validation (Resource Groups).'
    }
  ],
  dynamicMessages
)

// ======================================================================
// 5) Assignations des initiatives
// ======================================================================
resource initiativeCustomPoliciesTagsAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Sol-AssInit-CTag-v6.1'
  location: location
  properties: {
    displayName: initiativeCustomPoliciesDisplayName
    policyDefinitionId: initiativeCustomPoliciesTags.id
    nonComplianceMessages: allMessagesdynamicMessagesCustomPoliciesTags
  }
}

resource initiativeBuiltinPoliciesTagsAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Sol-AssInit-BTag-v6.1'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: initiativeBuiltinPoliciesDisplayName
    policyDefinitionId: initiativeBuiltinPoliciesTags.id
  }
}

// ======================================================================
// 6) Outputs
// ======================================================================
output initiativeCustomPoliciesTagsId string = initiativeCustomPoliciesTags.id
output initiativeBuiltinPoliciesTagsId string = initiativeBuiltinPoliciesTags.id
output initiativeCustomPoliciesTagsAssignmentId string = initiativeCustomPoliciesTagsAssignment.id
output initiativeBuiltinPoliciesTagsAssignmentId string = initiativeBuiltinPoliciesTagsAssignment.id
