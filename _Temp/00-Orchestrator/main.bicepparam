using 'main.bicep'


param initiativeName02 = '02-General Initiative'
param assignmentName02 = '02-General Assignment'
param allowedLocations = [
  'canadacentral'
  'canadaeast'
]
param initiativeDisplayName02 = '02-General Initiative'
param assignmentDisplayName02 = '02-General Assignment'


param initiativeName03 = '03-network-Initiative'
param assignmentName03 = '03-network-Assignment' //ne doit pas depasse 24 characteres
param initiativeDisplayName03 = '03-network-Initiative'
param assignmentDisplayName03 = '03-network-Assignment'
param initiativeCategory = 'General'
param enforcementMode = 'Default'



param initiativeName04 = '04-Keyvault-RBAC-Initiative'
param assignmentName04 = '04-Key-RBAC-Assignment' //ne doit pas depasse 24 characteres
param initiativeDisplayName04 = '04-Keyvault-RBAC-Initiative'
param assignmentDisplayName04 = '04-Keyvault-RBAC-Assignment'
param kvRbacEffect = 'Audit'




// Noms techniques
param initiativeName05 = '05-VM-Initiative'
param assignmentName05  = '05-VM-Assignment' //ne doit pas depasse 24 characteres

// Libellés
param initiativeDisplayName05 = '05-VM Initiative'
param assignmentDisplayName05 = '05-VM Assignment'

// Liste d’exemple des SKUs autorisés
param allowedVmSkus = [
  'Standard_B2s'
  'Standard_DS1_v2'
  'Standard_DS2_v2'
]

// Azure Backup (Audit) — tu peux commenter cette ligne pour utiliser la defaultValue de l’initiative
//param backupEffect = 'AuditIfNotExists'
// Pour désactiver l’audit (temporairement) :
param backupEffect = 'Default'



param initiativeName06 = '06-StorageAccountInitiative'
param assignmentName06 = '06-StorageAccountAssign' //ne doit pas depasse 24 characteres

param initiativeDisplayName06 = '06-StorageAccount Initiative' // The policy assignment name length must not exceed '24' characters
param assignmentDisplayName06  = '06-StorageAccount Assignment'

// région pour la Managed Identity de l’assignation (utile si un effet Modify est actif).
param assignmentLocation = 'canadacentral'

// Effects au choix
param secureTransferEffect  = 'Modify'   // ou 'Disabled'
param tlsEffect            = 'Audit'    // 'Audit' | 'Deny' | 'Disabled'
param minimumTlsVersion    = 'TLS1_2'   // 'TLS1_0' | 'TLS1_1' | 'TLS1_2'
param publicAccessEffect   = 'Deny'     // 'Audit' | 'Deny' | 'Disabled'

