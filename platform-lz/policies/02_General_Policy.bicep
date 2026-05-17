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

// ------------------------------------------------------------
// Déploiement au niveau de l'abonnement
// ------------------------------------------------------------
targetScope = 'subscription' // Ce template s'applique à un abonnement Azure

// ------------------------------------------------------------
// Paramètres personnalisables
// ------------------------------------------------------------

// Nom interne de l’initiative
@description('Nom de l\'initiative (policy set) à créer.')
param initiativeName string //= '02-General-Initiative' // Doit être unique dans le scope de déploiement

// Nom interne de l’assignation
///@description('Nom de l’assignation de l’initiative.')
param assignmentName string //= '02-General-Assignment'

// NOTE: This template is deployed at subscription scope. The assignment will
// be created in the same subscription as the deployment. Do not pass a
// different subscriptionId here (to target another subscription you must use
// a module deployed to that subscription).

// Emplacements autorisés (Canada Central et Canada East par défaut)
@description('Liste des emplacements autorisés.')
param allowedLocations array /*= [
  'canadacentral'
  'canadaeast'
  ]*/

//++++++++++++++++++++++++++++++++++++  DEBUT DU BLOC POUR LA POLICY  +++++++++++++++++++++++++++++++++++++++++++++++++++
/*
// SKU autorisés pour les machines virtuelles (exemple : Standard_DS1_v2, Standard_DS2_v2, Standard_B2s)
@description('Liste des SKU autorisés pour les machines virtuelles.')
param allowedVmSkus array = [
  'Standard_DS1_v2'
  'Standard_DS2_v2'
  'Standard_B2s'
]
*/
//++++++++++++++++++++++++++++++++++++  FIN DU BLOC POUR LA POLICY  +++++++++++++++++++++++++++++++++++++++++++++++++++

// Libellés lisibles
@description('Nom lisible pour l\'initiative.')
param initiativeDisplayName string //= '02-General Initiative'

@description('Nom lisible pour l\'assignation.')
param assignmentDisplayName string //= '02-General Assignment'

// @description('ID de l’abonnement cible pour l\'assignation. Doit être le même que celui du scope de déploiement.')
// param subscriptionId string = subscription().subscriptionId

// ------------------------------------------------------------
// Création de l’initiative (Policy Set Definition)
// ------------------------------------------------------------
// Cette initiative regroupe deux policies built-in :
// 1) Allowed locations
// 2) Audit resource location matches resource group location

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

      //++++++++++++++++++++++++++++++++++++  DEBUT DU BLOC POUR LA POLICY  +++++++++++++++++++++++++++++++++++++++++++++++++++
      /*allowedVmSkus: {
        type: 'Array'
        metadata: {
          displayName: '02-General'
          description: '02-General List of allowed Location'
        }
      }*/
      //++++++++++++++++++++++++++++++FIN DU BLOC ++++++++++++++++++++++++++++++++++++++++
    }
    // Liste des policies incluses
    policyDefinitions: [
      {
        policyDefinitionReferenceId: 'allowed-locations' // ✅ ADD THIS
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        parameters: {
          listOfAllowedLocations: {
            value: allowedLocations
          }
        }
      }

      {
        policyDefinitionReferenceId: 'audit-resource-location' // ✅ ADD THIS
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a914e76-4921-4c19-b460-a2d36003525a'
      }

      // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      //++++++++++++++++ DEBUT DU BLOC bloc que vous ajouter vitre builtin policy ++++++++++++++++++++++++++++++
      //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      /*{
        // Policy : Allowed virtual machine SKUs (built-in)
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
        parameters: {
          listOfAllowedSKUs: {
            value: allowedVmSkus
          }
        }
      }*/
      //++++++++++++++++++++++++++++++++++++++++  FIN DU BLOC +++++++++++++++++++++++++++++++++++++++++++++++++++
    ]
  }
}

// ------------------------------------------------------------
// Assignation de l’initiative à l’abonnement
// ------------------------------------------------------------
resource initiativeAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: assignmentName
  // scope: subscription(subscriptionId)
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
