// main.bicep (orchestrateur)
targetScope = 'managementGroup'

// ---------------------------
// Paramètres globaux (exposables via .bicepparam)
// ---------------------------
@description('Locations autorisées pour 02-General.')
param allowedLocations array /*= [

  'canadacentral'
  'canadaeast'
]*/

@description('Enforcement mode global pour 03-network.')
@allowed([
  'Default'
  'DoNotEnforce'
])


 

param initiativeName02 string //= '02-General Initiative'
param assignmentName02 string //= '02-General-Assignment'
param initiativeDisplayName02 string //= '02-General Initiative'
param assignmentDisplayName02 string //= '02-General Assignment'

// ---------------------------
// Module 02-General (ton template 02-General.bicep)
// ---------------------------
module general './02-general.bicep' = {
  name: 'mod-02-general'
  //scope: managementGroup()
  params: {
    initiativeName:  initiativeName02
    assignmentName: assignmentName02
    initiativeDisplayName: assignmentDisplayName02
    assignmentDisplayName: assignmentDisplayName02
    allowedLocations: allowedLocations
  }
}

// ---------------------------
// Module 03-network (ton template 03-network.bicep)
// ---------------------------

param initiativeName03 string //='03-network-Initiative'
param assignmentName03 string //='03-network-Assignment' //ne doit pas depasse 24 characteres
param initiativeDisplayName03 string //= '03-network-Initiative'
param assignmentDisplayName03 string //= '03-network-Assignment'
param initiativeCategory string //=  'General'
param enforcementMode  string //= 'Default'

module network './03-network.bicep' = {
  name: 'mod-03-network'
  //scope: subscription()
  params: {
    initiativeName: initiativeName03
    assignmentName: assignmentName03
    initiativeDisplayName: assignmentDisplayName03
    assignmentDisplayName: assignmentDisplayName03
    initiativeCategory:initiativeCategory
    enforcementMode: enforcementMode
  }
}




// ---------------------------
// Module 04-keyVault (ton template 04-keyVault.bicep)
// ---------------------------


param initiativeName04 string //= '04-Keyvault-RBAC-Initiative'
param assignmentName04 string //= '04-Key-RBAC-Assignment' //ne doit pas depasse 24 characteres
param initiativeDisplayName04 string //= '04-Keyvault-RBAC-Initiative'
param assignmentDisplayName04 string //='04-Keyvault-RBAC-Assignment'
param kvRbacEffect string //= 'Audit'


module keyVault './04-keyVault.bicep' = {
  name: 'mod-04-keyVault'
  //scope: subscription()
  params: {
    initiativeName: initiativeName04
    assignmentName: assignmentName04
    initiativeDisplayName: initiativeDisplayName04
    assignmentDisplayName: assignmentDisplayName04
    //initiativeCategory: 'Key Vault'
    kvRbacEffect:kvRbacEffect
    
  }
}



// ---------------------------
// Module 05-VM (ton template 05-vm.bicep)
// ---------------------------

// Noms techniques
param initiativeName05 string //= '05-VM-Initiative'
param assignmentName05  string //= '05-VM-Assignment' //ne doit pas depasse 24 characteres

// Libellés
param initiativeDisplayName05 string //= '05-VM Initiative'
param assignmentDisplayName05 string //= '05-VM Assignment'


// Liste d’exemple des SKUs autorisés
param allowedVmSkus array /*= [
  'Standard_B2s'
  'Standard_DS1_v2'
  'Standard_DS2_v2'
]*/

// Azure Backup (Audit) — tu peux commenter cette ligne pour utiliser la defaultValue de l’initiative
//param backupEffect = 'AuditIfNotExists'
// Pour désactiver l’audit (temporairement) :
// param backupEffect = 'Disabled'



module vm './05-VM.bicep' = {
  name: 'mod-05-vm'
  //scope: subscription()
  params: {
    initiativeName:   initiativeName05
    assignmentName:  assignmentName05
    initiativeDisplayName:  initiativeDisplayName05
    assignmentDisplayName: assignmentDisplayName05
    //initiativeCategory: 'Key Vault'
    allowedVmSkus:allowedVmSkus
    backupEffect:'AuditIfNotExists'
  
    
  }
}



// ---------------------------
// Module Storage Account (ton template 06-storageAccount.bicep)
// ---------------------------

param initiativeName06 string //= '06-StorageAccountInitiative'
param assignmentName06 string //= '06-StorageAccountAssign' //ne doit pas depasse 24 characteres

param initiativeDisplayName06 string //= '06-StorageAccount Initiative' // The policy assignment name length must not exceed '24' characters
param assignmentDisplayName06 string  //= '06-StorageAccount Assignment'

// région pour la Managed Identity de l’assignation (utile si un effet Modify est actif).
param assignmentLocation string //= 'canadacentral'

// Effects au choix
param secureTransferEffect string //= 'Modify'   // ou 'Disabled'
param tlsEffect            string //= 'Audit'    // 'Audit' | 'Deny' | 'Disabled'
param minimumTlsVersion    string //= 'TLS1_2'   // 'TLS1_0' | 'TLS1_1' | 'TLS1_2'
param publicAccessEffect   string //= 'Deny'     // 'Audit' | 'Deny' | 'Disabled'



module storageAccount './06-storageAccount.bicep' = {
  name: 'mod-06-storageaccount'
  //scope: subscription()
  params: {
    initiativeName: initiativeName06
    assignmentName: assignmentName06
    initiativeDisplayName: initiativeDisplayName06 
    assignmentDisplayName: assignmentDisplayName06 
    //initiativeCategory: 'Key Vault'
   minimumTlsVersion: minimumTlsVersion
    publicAccessEffect:publicAccessEffect
    secureTransferEffect:secureTransferEffect
    tlsEffect:tlsEffect
  }
}




