using '06-storageAccount.bicep'

param initiativeName = '06-StorageAccount Initiative'
param assignmentName = '06-StorageAccountAssign' //ne doit pas depasse 24 characteres

param initiativeDisplayName = '06-StorageAccount Initiative'
param assignmentDisplayName  = '06-StorageAccount Assignment'

// région pour la Managed Identity de l’assignation (utile si un effet Modify est actif).
param assignmentLocation = 'canadacentral'

// Effects au choix
param secureTransferEffect = 'Modify'   // ou 'Disabled'
param tlsEffect            = 'Audit'    // 'Audit' | 'Deny' | 'Disabled'
param minimumTlsVersion    = 'TLS1_2'   // 'TLS1_0' | 'TLS1_1' | 'TLS1_2'
param publicAccessEffect   = 'Deny'     // 'Audit' | 'Deny' | 'Disabled'
