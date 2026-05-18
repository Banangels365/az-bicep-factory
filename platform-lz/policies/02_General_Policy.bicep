/*

02_General_Policy.bicep - Initiative regroupant des policies générales (ex: restriction de localisation)

02_General_Policy.bicep est un template de référence pour la création d’initiatives (Policy Set Definitions)
 et leur assignation au niveau de l’abonnement. 

Objectif du squelette

Créer une initiative (Policy Set Definition) au niveau de l’abonnement
Passer dynamiquement une liste de policies à inclure (avec leurs paramètres)
Assigner l’initiative à l’abonnement dans la foulée
Sans modifier le Bicep quand tu changes les policies : tu ne fais que passer des paramètres

1) Restrict location (Allowed locations +
2) Audit resource location matches resource group location)

*/
/*
02_General_Policy.bicep - Initiative regroupant des policies générales (ex: restriction de localisation)
*/

targetScope = 'subscription'

// ------------------------------------------------------------
// Paramètres
// ------------------------------------------------------------
@description('Nom interne de l\'initiative (policy set) à créer.')
param initiativeName string

@description('Nom interne de l\'assignation.')
param assignmentName string

@description('Liste des emplacements autorisés.')
param allowedLocations array

@description('Nom lisible pour l\'initiative.')
param initiativeDisplayName string

@description('Nom lisible pour l\'assignation.')
param assignmentDisplayName string

// ------------------------------------------------------------
// Initiative regroupant les policies générales
// ------------------------------------------------------------
resource initiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: initiativeName
  properties: {
    displayName: initiativeDisplayName
    description: '02-General Restrict Location'
    policyType: 'Custom'
    metadata: {
      category: 'General'
    }

    // Paramètres exposés par l’initiative
    parameters: {
      allowedLocations: {
        type: 'Array'
        metadata: {
          displayName: 'Allowed Locations'
          description: 'List of allowed locations for resource deployment.'
        }
      }
    }

    // Liste des policies incluses dans l’initiative
    policyDefinitions: [
      {
        policyDefinitionReferenceId: 'allowed-locations'
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'allowedLocations\')]'
          }
        }
      }

      {
        policyDefinitionReferenceId: 'audit-resource-location'
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a914e76-4921-4c19-b460-a2d36003525a'
      }

      // Exemple pour ajouter une autre policy built-in :
      /*
      {
        policyDefinitionReferenceId: 'allowed-vm-skus'
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
        parameters: {
          listOfAllowedSKUs: {
            value: allowedVmSkus
          }
        }
      }
      */
    ]
  }
}

// ------------------------------------------------------------
// Assignation de l’initiative
// ------------------------------------------------------------
resource initiativeAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: assignmentName
  properties: {
    displayName: assignmentDisplayName
    description: '02-General Assign to 02-General initiative'
    policyDefinitionId: initiative.id
    parameters: {
      allowedLocations: {
        value: allowedLocations
      }
    }
  }
}

// ------------------------------------------------------------
// Sorties
// ------------------------------------------------------------
output initiativeId string = initiative.id
output assignmentId string = initiativeAssignment.id
