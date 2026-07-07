/*
05_VM_Policy.bicep - Initiative regroupant des policies liées aux machines virtuelles (ex: SKU autorisés, Azure Backup)

Objectif du squelette :
- Créer une initiative (Policy Set Definition) au niveau de l’abonnement
- Passer dynamiquement une liste de policies à inclure (avec leurs paramètres)
- Assigner l’initiative à l’abonnement dans la foulée
- Sans modifier le Bicep quand tu changes les policies : tu ne fais que passer des paramètres

Policies incluses :
- 1) Allowed virtual machine SKUs (built-in ID : cccc23c7-8427-4f53-ad12-b6a63eb452b3)
- 2) Azure Backup should be enabled for Virtual Machines (built-in ID : 013e242c-8828-4970-87b3-ab247555486d)  // ID vérifié
*/

// ------------------------------------------------------------
// Déploiement au niveau de l'abonnement
// ------------------------------------------------------------
targetScope = 'managementGroup'

// ------------------------------------------------------------
// Paramètres personnalisables (template scope)
// ------------------------------------------------------------

// Nom interne de l’initiative (policy set)
@description('Nom de l\'initiative (policy set) à créer.')
param initiativeName string //= '05-VM-Initiative'

// Nom interne de l’assignation
@description('Nom de l\'assignation de l\'initiative.')
param assignmentName string //= '05-VM-Assignment'

// SKU autorisés pour les machines virtuelles (ex.: Standard_DS1_v2, Standard_DS2_v2, Standard_B2s)
@description('Liste des SKU autorisés pour les machines virtuelles.')
param allowedVmSkus array /*= [
  'Standard_B2s'
  'Standard_DS1_v2'
  'Standard_DS2_v2'
]*/

// Azure Backup (Audit)
@description('Effet pour la policy "Azure Backup should be enabled for Virtual Machines". Valeurs: AuditIfNotExists ou Disabled.')
param backupEffect string //= 'AuditIfNotExists'

// Libellés lisibles
@description('Nom lisible pour l\'initiative.')
param initiativeDisplayName string //= '05-VM Initiative'

@description('Nom lisible pour l\'assignation.')
param assignmentDisplayName string //= '05-VM Assignment'

// ------------------------------------------------------------
// Création de l’initiative (Policy Set Definition)
// ------------------------------------------------------------
resource initiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: initiativeName
  properties: {
    displayName: initiativeDisplayName
    description: '05-VM: Limit VM SKUs + Audit Azure Backup.'
    policyType: 'Custom'
    metadata: {
      category: 'General'
    }

    // Paramètres exposés par l’initiative (clé de l’Option A : defaultValue sur tout nouveau paramètre)
    parameters: {
      allowedVmSkus: {
        type: 'Array'
        metadata: {
          displayName: '05-VM Allowed VM SKUs'
          description: '05-VM List of allowed virtual machine SKUs.'
        }
      }

      // *** Nouveau paramètre ajouté à une initiative existante : il DOIT avoir un defaultValue ***
      backupEffect: {
        type: 'String'
        metadata: {
          displayName: '05-VM Azure Backup - effet'
          description: 'Choix de l\'effet (AuditIfNotExists ou Disabled) pour la policy Azure Backup sur les VMs.'
        }
        // Valeur par défaut pour compatibilité ascendante lors d’une mise à jour in-place
        defaultValue: 'AuditIfNotExists'
      }
    }

    // Liste des policies incluses
    policyDefinitions: [
      {
        // Azure Backup should be enabled for Virtual Machines (AuditIfNotExists/Disabled)
        // Built-in Policy ID confirmée : 013e242c-8828-4970-87b3-ab247555486d
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/013e242c-8828-4970-87b3-ab247555486d'
        parameters: {
          effect: {
            value: '[parameters(\'backupEffect\')]'
          }
        }
      }
      {
        // Allowed virtual machine SKUs
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
        parameters: {
          listOfAllowedSKUs: {
            value: '[parameters(\'allowedVmSkus\')]'
          }
        }
      }

      // --- Exemple de bloc "Allowed locations" (optionnel) ---
      /*
      ,{
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'allowedLocations\')]'
          }
        }
      }
      */
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
    description: '05-VM Assign to 05-VM initiative'
    policyDefinitionId: initiative.id
    parameters: {
      allowedVmSkus: {
        value: allowedVmSkus
      }
      // On peut OUI conserver ce mapping (pour forcer une valeur à l’assignation)
      // ou bien le retirer pour qu’Azure Policy consomme la defaultValue de l’initiative.
      backupEffect: {
        value: backupEffect
      }
    }
  }
}

// ------------------------------------------------------------
// Sorties
// ------------------------------------------------------------
output initiativeId string = initiative.id
output assignmentId string = initiativeAssignment.id
