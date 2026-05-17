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

targetScope = 'managementGroup'

@description('Région utilisée pour assignation des politiques au niveau du management group')
param location string = deployment().location

param initiativeCustomPoliciesName string
param initiativeCustomPoliciesDisplayName string
param initiativeBuiltinPoliciesName string
param initiativeBuiltinPoliciesDisplayName string
param customPoliciesTags array = []
param builtinPolicieTags array = []

// var requireTagOnResourcesId      = '/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99'
var requireTagOnResourceGroupsId = '/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025'
var inheritTagFromResourceGroupIfMissingId = '/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070'

// 

/*
  1) Définition des Policy Definitions
     - Ajout de la contrainte sur le type pour viser uniquement les Resource Groups
*/
resource policyDefinitionsResources 'Microsoft.Authorization/policyDefinitions@2021-06-01' = [
  for policy in customPoliciesTags: {
    name: policy.name
    properties: {
      displayName: policy.displayName
      metadata: { category: 'Tags', version: '1.0.0' }
      policyType: 'Custom'
      mode: 'All'
      parameters: {}
      policyRule: {
        if: {
          allOf: [
            // Filtre: n'évaluer que les groupes de ressources
            {
              field: 'type'
              equals: 'Microsoft.Resources/subscriptions/resourceGroups'
            }
            // Validation du tag
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

/*
  2) Initiative qui regroupe les policy definitions ci-dessus
*/
resource initiativeCustomPoliciesTags 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: initiativeCustomPoliciesName
  properties: {
    displayName: initiativeCustomPoliciesDisplayName
    metadata: { category: 'Tags', version: '1.0.0' }
    policyDefinitions: [
      for policy in customPoliciesTags: {
        policyDefinitionReferenceId: 'require-${policy.name}'
        policyDefinitionId: ('/providers/Microsoft.Management/managementGroups/4e504624-9abd-4371-aa47-31f0626f32d0/providers/Microsoft.Authorization/policyDefinitions/${policy.name}')
        parameters: {}
      }
    ]
  }
}

resource initiativeBuiltinPoliciesTags 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: initiativeBuiltinPoliciesName
  properties: {
    policyType: 'Custom'
    displayName: initiativeBuiltinPoliciesDisplayName
    metadata: { category: 'Tags', version: '1.0.0' }
    // 👇 Aucun 'parameters' de niveau initiative
    policyDefinitions: [
      for tag in builtinPolicieTags: {
        policyDefinitionReferenceId: tag.type == 'requiredOnResourceGroup'
          ? 'require-${tag.Name}-tag-on-rg'
          : 'Inherit-${tag.Name}-tag-from-rg'
        policyDefinitionId: tag.type == 'requiredOnResourceGroup'
          ? requireTagOnResourceGroupsId
          : inheritTagFromResourceGroupIfMissingId
        parameters: {
          tagName: {
            value: tag.name
          }
        }
      }
    ]
  }
}

// /providers/Microsoft.Management/managementGroups/4e504624-9abd-4371-aa47-31f0626f32d0/providers/Microsoft.Authorization/policyDefinitions/tagEnvironnement

/*
  3) Messages de non-conformité dynamiques
*/
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

/*
Assignation de l’initiative au niveau ABONNEMENT
*/
resource initiativeCustomPoliciesTagsAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Sol-AssInit-CTag-v6.1'
  location: location
  properties: {
    displayName: initiativeCustomPoliciesDisplayName
    policyDefinitionId: initiativeCustomPoliciesTags.id
    nonComplianceMessages: allMessagesdynamicMessagesCustomPoliciesTags
  }
}

// Assignation de l’initiative Built-in au niveau ABONNEMENT
resource initiativeBuiltinPoliciesTagsAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Sol-AssInit-BTag-v6.1'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: initiativeBuiltinPoliciesDisplayName
    policyDefinitionId: initiativeBuiltinPoliciesTags.id
    // ***  Il y a présentement un problème avec les messages de non-conformité pour les policies built-in dans une initiative, c'Est popur cette raison qu'on l'a mis en commentaire  ***
    // nonComplianceMessages: allMessagesdynamicMessagesBuiltinPoliciesTags
  }
}

// ------------------------------------------------------------
// Sorties pratiques
// ------------------------------------------------------------
output initiativeCustomPoliciesTagsId string = initiativeCustomPoliciesTags.id
output initiativeBuiltinPoliciesTagsId string = initiativeBuiltinPoliciesTags.id
output initiativeCustomPoliciesTagsAssignmentId string = initiativeCustomPoliciesTagsAssignment.id
output initiativeBuiltinPoliciesTagsAssignmentId string = initiativeBuiltinPoliciesTagsAssignment.id
