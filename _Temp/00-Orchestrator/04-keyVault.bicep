/*
04-KeyVault.bicep
Ce template crée une initiative (Policy Set Definition) au niveau de l'abonnement
et l’assigne à l’abonnement. 

Contenu de l’initiative :
- 1) Azure Key Vault should use RBAC permission model (built-in)

*/

targetScope = 'managementGroup'

// ------------------------------------------------------------
// Paramètres
// ------------------------------------------------------------

// Nom interne de l’initiative
@description('Nom de l’initiative (policy set) à créer.')
param initiativeName string // = '04-Keyvault-RBAC-Initiative'

// Nom interne de l’assignation
@description('Nom de l’assignation de l’initiative.')
param assignmentName string // = '04-Keyvault-RBAC-Assignment'

// Libellés lisibles
@description('Nom lisible pour l’initiative.')
param initiativeDisplayName string // = '04-Keyvault-RBAC-Initiative'

@description('Nom lisible pour l’assignation.')
param assignmentDisplayName string // = '04-Keyvault-RBAC-Assignment'

// Param. de comportement de la policy Key Vault RBAC
@description('Effet de la policy "Azure Key Vault should use RBAC permission model".')
@allowed([
  'Audit'
  'Deny'
  'Disabled'
])
param kvRbacEffect string // = 'Audit'

// ------------------------------------------------------------
// Création de l’initiative (Policy Set Definition)
// ------------------------------------------------------------
// Cette initiative contient uniquement :
// - Azure Key Vault should use RBAC permission model (built‑in)
resource initiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: initiativeName
  properties: {
    displayName: initiativeDisplayName
    description: '04-Keyvault : Initiative contenant la policy Key Vault RBAC .'
    policyType: 'Custom'
    metadata: {
      category: 'General'
    }

    // Expose les paramètres pertinents des policies incluses (ici: l\'effect de la KV RBAC)
    parameters: {
      kvRbacEffect: {
        type: 'String'
        metadata: {
          displayName: 'Effect pour la policy Key Vault RBAC'
          description: 'Audit, Deny ou Disabled'
        }
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: kvRbacEffect
      }
    }

    // Liste des policies incluses (seulement la KV RBAC)
    policyDefinitions: [
      {
        // Built-in: Azure Key Vault should use RBAC permission model
        // ID officiel confirmé
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/12d4fa5e-1f9f-4c21-97a9-b99b3c6611b5'
        policyDefinitionReferenceId: 'kv-should-use-rbac'
        // Mappe le paramètre "effect" de la policy à un paramètre de l'initiative
        parameters: {
          effect: {
            value: '[parameters(\'kvRbacEffect\')]'
          }
        }
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
    description: 'Assignation de l’initiative Key Vault RBAC (sans autres policies).'
    policyDefinitionId: initiative.id
    // Passe la valeur du paramètre d’initiative lors de l’assignation
    parameters: {
      kvRbacEffect: {
        value: kvRbacEffect
      }
    }
  }
}

// ------------------------------------------------------------
// Sorties
// ------------------------------------------------------------
output initiativeId string = initiative.id
output assignmentId string = initiativeAssignment.id
