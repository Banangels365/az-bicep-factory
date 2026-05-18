using './05-vm.bicep'

// Noms techniques
param initiativeName = '05-VM-Initiative'
param assignmentName  = '05-VM-Assignment' //ne doit pas depasse 24 characteres

// Libellés
param initiativeDisplayName = '05-VM Initiative'
param assignmentDisplayName = '05-VM Assignment'

// Liste d’exemple des SKUs autorisés
param allowedVmSkus = [
  'Standard_B2s'
  'Standard_DS1_v2'
  'Standard_DS2_v2'
]

// Azure Backup (Audit) — tu peux commenter cette ligne pour utiliser la defaultValue de l’initiative
param backupEffect = 'AuditIfNotExists'
// Pour désactiver l’audit (temporairement) :
// param backupEffect = 'Disabled'
