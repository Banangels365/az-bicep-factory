/*
.bicep
02-General.bicepparam

02-SquelettePolicies.bicep :

squelette de base pour créer une initiative qui contient un definition builtin et l’assigner à un abonnement.
Cette definition policy est mon squellette que je prend pour ajpouter mes policis dans une 
initiative policy et ensuite assigner cette initiative a un scope (ici un abonnement)

1) Je prend cette policy  qui possede une definition builit policy (allow Location)
et je lui ajouter une nouvelle definition Policy que je veu ajouter

2) J'enlève la built-in policy qui y etait la a la base (allow location) parce que j'en ai pas de besoin.
elle est la car nous ne pouvons pas faire de initiatitive policy sans au moins une defition policy ,

3) J'ajoute d'autres policies si besoin

4) Creer le parameter file

5) Faire la correction des commantaires

6) Faire un commit dans VSCode

7) Prendre une copie et le mettre dans Onedrive Solulan comme backup 


*/

targetScope = 'managementGroup'

// ------------------------------------------------------------
// Paramètres
// ------------------------------------------------------------
@description('Nom de l’initiative (policy set) à créer.')
param initiativeName string

@description('Nom de l’assignation de l’initiative.')
param assignmentName string

@description('Liste des emplacements autorisés.')
param allowedLocations array

@description('Nom lisible pour l’initiative.')
param initiativeDisplayName string

@description('Nom lisible pour l’assignation.')
param assignmentDisplayName string

// ------------------------------------------------------------
// Initiative (sans la policy Audit resource location…)
// ------------------------------------------------------------
resource initiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: initiativeName
  properties: {
    displayName: initiativeDisplayName
    description: '02-General Restrict Location'
    policyType: 'Custom'
    metadata: {
      category: 'General'
    }

    parameters: {
      allowedLocations: {
        type: 'Array'
        metadata: {
          displayName: 'Allowed Locations'
          description: 'List of allowed locations for resource deployment.'
        }
      }
    }

    policyDefinitions: [
      {
        // Policy : Allowed locations (built‑in)
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'allowedLocations\')]'
          }
        }
      }

      // <<< La policy suivante a été retirée >>>
      // {
      //   policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a914e76-4921-4c19-b460-a2d36003525a'
      // }
      // <<< Fin de suppression >>>

      // Bloc optionnel pour d’autres builtin policies
      /*
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
        parameters: {
          listOfAllowedSKUs: {
            value: '[parameters(\'allowedVmSkus\')]'
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
  //scope: subscription()
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
