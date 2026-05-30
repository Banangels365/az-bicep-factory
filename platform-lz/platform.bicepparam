// platform-lz/platform.bicepparam
using './platform.bicep'

// Organization configuration
param organizationName = 'acmy'
param environment = 'sbox' // prod, dev, logs, quar, sbox
param location = 'caea' // canadacentral ou canadaeast

// billing scope ID for subscription creation
param managementSubscriptionId = '0061dc3e-7704-4778-bcda-b566d000d486'

// liste des tags à appliquer à toutes les ressources
param tags = {
  Application: 'Platform-LZ'
  Environnement: 'sbox'
  CreeLe: '2024-05-18'
  CreePar: 'CloudOps-Team'
  Criticite: 'Moyen'
  Responsable: 'CloudOps-Team'
  ResponsableEmail: 'cloudops@acmy.com'
}

// Logging configuration
// param logRetentionDays = 90
// param enableSentinel = true

// Policy configuration

// Liste des
// param initiativeCustomPoliciesName = '01-Tag'
// param initiativeCustomPoliciesDisplayName = '01-Tag'
// param initiativeBuiltinPoliciesName = '01-Tag-Assignment'
// param initiativeBuiltinPoliciesDisplayName = '01-Tag-Assignment'

/*
Liste des policies custom pour les tags
On peut ajouter autant de tags que nécessaire dans cette liste, avec les propriétés suivantes :
- name : le nom interne de la policy definition (sera utilisé dans l'initiative)
- displayName : le nom affiché de la policy definition  (sera affiché dans le portail Azure)
- field : le champ de la resource sur lequel la policy sera appliquée (ex: tags.NomDuTag)
- allowedValues : la liste des valeurs autorisées pour ce tag
*/

// param customPoliciesTags = [
//   {
//     name: 'Environnement'
//     displayName: 'Tag - Environnement'
//     field: 'tags.Environnement'
//     allowedValues: [
//       'Dev'
//       'Preprod'
//       'Prod'
//     ]
//     nonComplianceMessage: 'Le tag Environnement doit être conforme aux valeurs acceptées. Soit Dev, Preprod ou Prod.'
//   }
//   {
//     name: 'Criticite'
//     displayName: 'Tag - Criticite'
//     field: 'tags.Criticite'
//     allowedValues: [
//       'Eleve'
//       'Moyen'
//       'Bas'
//     ]
//     nonComplianceMessage: 'Le tag Criticite doit être conforme aux valeurs acceptées. Soit Eleve, Moyen ou Bas.'
//   }
// ]

/*
Liste des policies builtin pour les tags
On peut ajouter autant de tags que nécessaire dans cette liste, avec les propriétés suivantes :
- name : le nom du tag (sera utilisé dans l'initiative)
- type : le type de la policy builtin (ex: requiredOnResourceGroup, inheritFromParent, etc.)
- nonComplianceMessage : le message de non-conformité affiché lorsque la policy n'est pas respectée
*/

// param builtinPoliciesTags = [
//   {
//     name: 'Application'
//     type: 'requiredOnResourceGroup'
//     nonComplianceMessage: 'Le tag FournisseurApp est obligatoire sur les Resource Groups.'
//   }
//   {
//     name: 'Responsable'
//     type: 'requiredOnResourceGroup'
//     nonComplianceMessage: 'Le tag Responsable est obligatoire sur les Resource Groups.'
//   }
//   {
//     name: 'ResponsableEmail'
//     type: 'requiredOnResourceGroup'
//     nonComplianceMessage: 'Le tag ResponsableEmail est obligatoire sur les Resource Groups.'
//   }
//   {
//     name: 'CreePar'
//     type: 'requiredOnResourceGroup'
//     nonComplianceMessage: 'Le tag CreePar est obligatoire sur les Resource Groups.'
//   }
//   {
//     name: 'CreeLe'
//     type: 'requiredOnResourceGroup'
//     nonComplianceMessage: 'Le tag CreeLe est obligatoire sur les Resource Groups.'
//   }
//   // Tags hérités du parent
//   {
//     name: 'Environnement'
//     type: 'inheritFromParent'
//     nonComplianceMessage: 'Le tag Environnement doit être hérité du parent.'
//   }
//   {
//     name: 'Application'
//     type: 'inheritFromParent'
//     nonComplianceMessage: 'Le tag Application doit être hérité du parent.'
//   }
//   {
//     name: 'Criticite'
//     type: 'inheritFromParent'
//     nonComplianceMessage: 'Le tag Criticite doit être hérité du parent.'
//   }
// ]

// param initiativeName02 = '02-General Initiative'
// param assignmentName02 = '02-General Assignment'
// param allowedLocations = [
//   'canadacentral'
//   'canadaeast'
// ]
// param initiativeDisplayName02 = '02-General Initiative'
// param assignmentDisplayName02 = '02-General Assignment'

// param initiativeName03 = '03-network-Initiative'
// param assignmentName03 = '03-network-Assignment' //ne doit pas depasse 24 characteres
// param initiativeDisplayName03 = '03-network-Initiative'
// param assignmentDisplayName03 = '03-network-Assignment'
// param initiativeCategory = 'General'
// param enforcementMode = 'Default'

// param initiativeName04 = '04-Keyvault-RBAC-Initiative'
// param assignmentName04 = '04-Key-RBAC-Assignment' //ne doit pas depasse 24 characteres
// param initiativeDisplayName04 = '04-Keyvault-RBAC-Initiative'
// param assignmentDisplayName04 = '04-Keyvault-RBAC-Assignment'
// param kvRbacEffect = 'Audit'

// Noms techniques
// param initiativeName05 = '05-VM-Initiative'
// param assignmentName05 = '05-VM-Assignment' //ne doit pas depasse 24 characteres

// // Libellés
// param initiativeDisplayName05 = '05-VM Initiative'
// param assignmentDisplayName05 = '05-VM Assignment'

// // Liste d’exemple des SKUs autorisés
// param allowedVmSkus = [
//   'Standard_B2s'
//   'Standard_DS1_v2'
//   'Standard_DS2_v2'
// ]

// Azure Backup (Audit) — tu peux commenter cette ligne pour utiliser la defaultValue de l’initiative
// param backupEffect = 'AuditIfNotExists'
// Pour désactiver l’audit (temporairement) :
// param backupEffect = 'Default'

// param initiativeName06 = '06-StorageAccountInitiative'
// param assignmentName06 = '06-StorageAccountAssign' //ne doit pas depasse 24 characteres

// param initiativeDisplayName06 = '06-StorageAccount Initiative' // The policy assignment name length must not exceed '24' characters
// param assignmentDisplayName06 = '06-StorageAccount Assignment'

// // région pour la Managed Identity de l’assignation (utile si un effet Modify est actif).
// param assignmentLocation = 'canadacentral'

// // Effects au choix
// param secureTransferEffect = 'Modify' // ou 'Disabled'
// param tlsEffect = 'Audit' // 'Audit' | 'Deny' | 'Disabled'
// param minimumTlsVersion = 'TLS1_2' // 'TLS1_0' | 'TLS1_1' | 'TLS1_2'
// param publicAccessEffect = 'Deny' // 'Audit' | 'Deny' | 'Disabled'
