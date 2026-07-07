/*

02-General.bicep
02-General.bicepparam

02-General.bicep est un template de référence pour la création d’initiatives (Policy Set Definitions)
 et leur assignation au niveau de l’abonnement. 

Objectif du squelette

Créer une initiative (Policy Set Definition) au niveau de l’abonnement
Passer dynamiquement une liste de policies à inclure (avec leurs paramètres)
Assigner l’initiative à l’abonnement dans la foulée
Sans modifier le Bicep quand tu changes les policies : tu ne fais que passer des paramètres

1) Restrict location (Allowed locations +
2) Audit resource location matches resource group location)


*/

// ------------------------------------------------------------
// Déploiement au niveau de l'abonnement
// ------------------------------------------------------------
targetScope = 'managementGroup' // Ce template s'applique à un abonnement Azure

// ------------------------------------------------------------
// Paramètres personnalisables
// ------------------------------------------------------------

// Nom interne de l’initiative
@description('Nom de l’initiative (policy set) à créer.')
param initiativeName string //= '05-VM Initiative'

// Nom interne de l’assignation
///@description('Nom de l’assignation de l’initiative.')
param assignmentName string //= '05-VM Assignment'

// Emplacements autorisés (Canada Central et Canada East par défaut)
@description('Liste des emplacements autorisés.')
param allowedLocations array /*= [
  'canadacentral'
  'canadaeast'
  ]*/


// Libellés lisibles
@description('Nom lisible pour l’initiative.')
param initiativeDisplayName string //= '02-General Initiative'

@description('Nom lisible pour l’assignation.')
param assignmentDisplayName string //= '02-General Assignment'

// ------------------------------------------------------------
// Création de l’initiative (Policy Set Definition)
// ------------------------------------------------------------
// Cette initiative regroupe deux policies built-in :
// 1) Allowed locations
// 2) Audit resource location matches resource group location

resource initiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
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
    // Liste des policies incluses
    policyDefinitions: [
      {
        // Policy : Allowed locations (built-in)
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'allowedLocations\')]'
          }
        }
      }
      
      {
        // Aucun paramètre requis, effet = audit
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a914e76-4921-4c19-b460-a2d36003525a'
      }
     
    ]
  }
}

// ------------------------------------------------------------
// Assignation de l’initiative à l’abonnement
// ------------------------------------------------------------
resource initiativeAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: assignmentName
  //scope: subscription()
  properties: {
    displayName: assignmentDisplayName
    description: '02-General Assign to 02-General initiative'
    policyDefinitionId: initiative.id
    parameters: {
      // Allowed locations pour la policy correspondante
      allowedLocations: {
        value: allowedLocations
      }
      /*
      allowedVmSkus: {
        value: allowedVmSkus
      }*/
    }
  }
}

// ------------------------------------------------------------
// Sorties pratiques
// ------------------------------------------------------------
output initiativeId string = initiative.id
output assignmentId string = initiativeAssignment.id

