/*
Initiative : sécurité des comptes de stockage
06-storageAccount.bicep
06-storageAccount.bicepparam


Objectif :
- Créer une initiative (Policy Set Definition) au niveau de l’abonnement
- Passer dynamiquement une liste de policies à inclure (avec leurs paramètres)
- Assigner l’initiative à l’abonnement dans la foulée
- Sans modifier le Bicep quand tu changes les policies : tu ne fais que passer des paramètres

Policies incluses :
1) Configure secure transfer of data on a storage account (Configure HTTPS)
2) Storage accounts should have the specified minimum TLS version
3) Storage account public access should be disallowed
*/

// ------------------------------------------------------------
// Déploiement au niveau de l'abonnement
// ------------------------------------------------------------
targetScope = 'managementGroup'

// ------------------------------------------------------------
// Paramètres personnalisables
// ------------------------------------------------------------

// Nom interne de l’initiative
@description('Nom de l’initiative (policy set) à créer.')
param initiativeName string

// Nom interne de l’assignation
@description('Nom de l’assignation de l’initiative.')
param assignmentName string

// --- Paramètre pour la policy "Secure transfer on Storage account" (f81e3117-...) ---
@description('Effet à appliquer pour la policy Secure Transfer. "Modify" (par défaut) ou "Disabled".')
@allowed([
  'Modify'
  'Disabled'
])
param secureTransferEffect string = 'Modify'

// --- Paramètres pour la policy "Minimum TLS version" (fe83a0eb-a853-422d-aac2-1bffd182c5d0) ---
@description('Effet à appliquer pour la policy Minimum TLS Version. "Audit", "Deny" ou "Disabled".')
@allowed([
  'Audit'
  'Deny'
  'Disabled'
])
param tlsEffect string = 'Audit'

@description('Version TLS minimale requise pour les comptes de stockage.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

// --- Paramètre pour la policy "Storage account public access should be disallowed" (4fa4b6c0-...) ---
@description('Effet à appliquer pour la policy "Public access disallowed". "Audit", "Deny" ou "Disabled".')
@allowed([
  'Audit'
  'Deny'
  'Disabled'
])
param publicAccessEffect string = 'Audit'

// Localisation (région) pour la managed identity de l’assignation (requis pour Modify/DeployIfNotExists)
@description('Région utilisée pour créer la managed identity de l’assignation.')
param assignmentLocation string = deployment().location

// Libellés lisibles
@description('Nom lisible pour l’initiative.')
param initiativeDisplayName string

@description('Nom lisible pour l’assignation.')
param assignmentDisplayName string

// ------------------------------------------------------------
// Création de l’initiative (Policy Set Definition)
// ------------------------------------------------------------
resource initiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: initiativeDisplayName
  properties: {
    displayName: initiativeDisplayName
    description: '06-storageAccount: Secure Transfer + Minimum TLS version + Disallow public access'
    policyType: 'Custom'
    metadata: {
      category: 'General'
    }

    // Paramètres exposés par l’initiative
    parameters: {
      // ---- Secure Transfer (built-in f81e3117-0093-4b17-8a60-82363134f0eb)
      secureTransferEffect: {
        type: 'String'
        metadata: {
          displayName: 'Secure Transfer Effect'
          description: 'Effect for the built-in policy "Configure secure transfer of data on a storage account".'
        }
        allowedValues: [
          'Modify'
          'Disabled'
        ]
        defaultValue: 'Modify'
      }

      // ---- Minimum TLS version (built-in fe83a0eb-a853-422d-aac2-1bffd182c5d0)
      tlsEffect: {
        type: 'String'
        metadata: {
          displayName: 'TLS Minimum Version - Effect'
          description: 'Effect for the built-in policy "Storage accounts should have the specified minimum TLS version".'
        }
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Audit'
      }
      minimumTlsVersion: {
        type: 'String'
        metadata: {
          displayName: 'TLS Minimum Version'
          description: 'Minimum TLS version required on storage accounts.'
        }
        allowedValues: [
          'TLS1_0'
          'TLS1_1'
          'TLS1_2'
        ]
        defaultValue: 'TLS1_2'
      }

      // ---- Public access disallowed (built-in 4fa4b6c0-31ca-4c0d-b10d-24b96f62a751)
      publicAccessEffect: {
        type: 'String'
        metadata: {
          displayName: 'Public Access - Effect'
          description: 'Effect for the built-in policy "Storage account public access should be disallowed".'
        }
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Audit'
      }
    }

    // Liste des policies incluses dans l’initiative
    policyDefinitions: [
      // 1) Secure transfer (Configure HTTPS)
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/f81e3117-0093-4b17-8a60-82363134f0eb'
        parameters: {
          effect: {
            // Mappe le paramètre d’initiative vers le paramètre 'effect' de la built-in
            value: '[parameters(\'secureTransferEffect\')]'
          }
        }
      }

      // 2) Minimum TLS version
      {
        // Built-in "Storage accounts should have the specified minimum TLS version"
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/fe83a0eb-a853-422d-aac2-1bffd182c5d0'
        parameters: {
          effect: {
            value: '[parameters(\'tlsEffect\')]'
          }
          minimumTlsVersion: {
            value: '[parameters(\'minimumTlsVersion\')]'
          }
        }
      }

      // 3) Public access disallowed
      {
        // Built-in "Storage account public access should be disallowed"
        // Id confirmé : 4fa4b6c0-31ca-4c0d-b10d-24b96f62a751
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751'
        parameters: {
          effect: {
            value: '[parameters(\'publicAccessEffect\')]'
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
  identity: {
    // Requis si une policy utilise Modify / DeployIfNotExists (ici, Secure Transfer = Modify possible)
    type: 'SystemAssigned'
  }
  location: assignmentLocation
  properties: {
    displayName: assignmentDisplayName
    description: '06-storageAccount: assign initiative (Secure Transfer + Minimum TLS + Disallow public access)'
    policyDefinitionId: initiative.id

    // Passage des paramètres d’initiative au moment de l’assignation
    parameters: {
      secureTransferEffect: {
        value: secureTransferEffect
      }
      tlsEffect: {
        value: tlsEffect
      }
      minimumTlsVersion: {
        value: minimumTlsVersion
      }
      publicAccessEffect: {
        value: publicAccessEffect
      }
    }
  }
}

// ------------------------------------------------------------
// Sorties pratiques
// ------------------------------------------------------------
output initiativeId string = initiative.id
output assignmentId string = initiativeAssignment.id
