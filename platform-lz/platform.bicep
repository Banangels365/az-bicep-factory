// platform-lz/platform.bicep
// Orchestrateur Bicep pour le déploiement de la plateforme de base (landing zone) dans Azure.

targetScope = 'managementGroup'

@description('Nom de l\'organisation')
param organizationName string

@description('Environnement')
@allowed([
  'prod' // production
  'dev' // development
  'logs' // logging/monitoring
  'quar' // quarantine
  'sbox' // sandbox
])
param environment string

@description('Région Azure pour les ressources de la plateforme. Valeurs possibles : cace (canadacentral), caea (canadaeast)')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('billing scope ID for subscription creation')
param managementSubscriptionId string

@description('Tags à appliquer aux ressources')
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  CostCenter: 'Platform'
  Owner: 'CloudOps'
}

// @description('Log Analytics retention in days')
// @minValue(30)
// @maxValue(730)
// param logRetentionDays int = 90

// @description('Activer Microsoft Sentinel')
// param enableSentinel bool = true

// Variables
// var logAnalyticsWorkspaceName = 'law-${organizationName}-platform-${environment}'

// ============================================
// MANAGEMENT GROUP HIERARCHY
// ============================================

// Root Management Group (Tenant Root Group is implicit)
module rootMg './modules/management_group.bicep' = {
  name: 'deploy-root-mg'
  scope: tenant()
  params: {
    managementGroupId: '${organizationName}-root'
    displayName: '${organizationName} Root'
    parentManagementGroupId: '' // Leave empty for root MG
    subscriptionIds: [] // No subscriptions directly under root MG
  }
}

// Production Management Group
module prodMg './modules/management_group.bicep' = {
  name: 'deploy-prod-mg'
  scope: tenant()
  params: {
    managementGroupId: '${organizationName}-prod'
    displayName: 'Production'
    parentManagementGroupId: '${organizationName}-root'
    subscriptionIds: [managementSubscriptionId] // Filter subscription IDs for prod MG
  }
  dependsOn: [
    rootMg
  ]
}

// Development Management Group
// module devMg './modules/management_group.bicep' = {
//   name: 'deploy-dev-mg'
//   scope: tenant()
//   params: {
//     managementGroupId: '${organizationName}-dev'
//     displayName: 'Development'
//     parentManagementGroupId: '${organizationName}-root'
//   }
//   dependsOn: [
//     rootMg
//   ]
// }

// Logging Management Group
module loggingMg './modules/management_group.bicep' = {
  name: 'deploy-logging-mg'
  scope: tenant()
  params: {
    managementGroupId: '${organizationName}-logging'
    displayName: 'Logging'
    parentManagementGroupId: '${organizationName}-root'
    subscriptionIds: [] // Filter subscription IDs for logging MG
  }
  dependsOn: [
    rootMg
  ]
}

// Quarantine Management Group
module quarantineMg './modules/management_group.bicep' = {
  name: 'deploy-quarantine-mg'
  scope: tenant()
  params: {
    managementGroupId: '${organizationName}-quarantine'
    displayName: 'Quarantine'
    parentManagementGroupId: '${organizationName}-root'
    subscriptionIds: [] // Filter subscription IDs for quarantine MG
  }
  dependsOn: [
    rootMg
  ]
}

// ============================================
// POLICY INITIATIVES AND ASSIGNMENTS
// ============================================

//---------------------------------
// 01-Tagging-Policy Creation
//---------------------------------

param initiativeCustomPoliciesName string
param initiativeCustomPoliciesDisplayName string
param initiativeBuiltinPoliciesName string
param initiativeBuiltinPoliciesDisplayName string
param customPoliciesTags array = []
param builtinPolicieTags array = []
module taggingPolicy './policies/01_Tagging_Policy.bicep' = {
  name: 'deploy-01-tagging-policy'
  scope: subscription(managementSubscriptionId)
  params: {
    initiativeCustomPoliciesName: initiativeCustomPoliciesName
    initiativeCustomPoliciesDisplayName: initiativeCustomPoliciesDisplayName
    initiativeBuiltinPoliciesName: initiativeBuiltinPoliciesName
    initiativeBuiltinPoliciesDisplayName: initiativeBuiltinPoliciesDisplayName
    customPoliciesTags: customPoliciesTags
    builtinPolicieTags: builtinPolicieTags
  }
}

//---------------------------------
// 02-General-Policy Creation
//---------------------------------

param initiativeName02 string //= '02-General Initiative'
param assignmentName02 string //= '02-General-Assignment'
param initiativeDisplayName02 string //= '02-General Initiative'
param assignmentDisplayName02 string //= '02-General Assignment'
param allowedLocations array = []

module generalPolicy './policies/02_General_Policy.bicep' = {
  name: 'deploy-02-general-policy'
  scope: subscription(managementSubscriptionId)
  params: {
    initiativeName: initiativeName02
    assignmentName: assignmentName02
    initiativeDisplayName: initiativeDisplayName02
    assignmentDisplayName: assignmentDisplayName02
    allowedLocations: allowedLocations
  }
}

// ---------------------------
// 03-network-Policy Creation
// ---------------------------

param initiativeName03 string //='03-network-Initiative'
param assignmentName03 string //='03-network-Assignment' //ne doit pas depasse 24 
param assignmentDisplayName03 string //= '03-network-Assignment'
param initiativeDisplayName03 string //= '03-network-Initiative'
param initiativeCategory string //=  'General'
param enforcementMode string //= 'Default'

module networkPolicy './policies/03_Network_Policy.bicep' = {
  name: 'deploy-03-network-policy'
  //scope: subscription(managementSubscriptionId)
  params: {
    initiativeName: initiativeName03
    assignmentName: assignmentName03
    initiativeDisplayName: initiativeDisplayName03
    assignmentDisplayName: assignmentDisplayName03
    initiativeCategory: initiativeCategory
    enforcementMode: enforcementMode
  }
}

// ---------------------------
// 04-keyVault-Policy Creation
// ---------------------------

param initiativeName04 string //= '04-Keyvault-RBAC-Initiative'
param assignmentName04 string //= '04-Key-RBAC-Assignment' //ne doit pas depasse 24 characteres
param initiativeDisplayName04 string //= '04-Keyvault-RBAC-Initiative'
param assignmentDisplayName04 string //= '04-Keyvault-RBAC-Assignment'
param kvRbacEffect string //= 'Audit'

module keyVaultPolicy './policies/04_KeyVault_Policy.bicep' = {
  name: 'deploy-04-keyVault-policy'
  //scope: subscription(managementSubscriptionId)
  params: {
    initiativeName: initiativeName04
    assignmentName: assignmentName04
    initiativeDisplayName: initiativeDisplayName04
    assignmentDisplayName: assignmentDisplayName04
    kvRbacEffect: kvRbacEffect
  }
}

// ---------------------------
// 05-VM-Policy Creation
// ---------------------------

param initiativeName05 string //= '05-VM-Initiative'
param assignmentName05 string //= '05-VM-Assignment' //ne doit pas depasse 24 characteres
param initiativeDisplayName05 string //= '05-VM Initiative'
param assignmentDisplayName05 string //= '05-VM Assignment'

// Liste d’exemple des SKUs autorisés
param allowedVmSkus array /*= [
  'Standard_B2s'
  'Standard_DS1_v2'
  'Standard_DS2_v2'
]*/

// Azure Backup (Audit) — tu peux commenter cette ligne pour utiliser la defaultValue de l’initiative
// param backupEffect = 'AuditIfNotExists'
// Pour désactiver l’audit (temporairement) :
param backupEffect string = 'Disabled'

module vmPolicy './policies/05_VM_Policy.bicep' = {
  name: 'deploy-05-vm-policy'
  //scope: subscription(managementSubscriptionId)
  params: {
    initiativeName: initiativeName05
    assignmentName: assignmentName05
    initiativeDisplayName: initiativeDisplayName05
    assignmentDisplayName: assignmentDisplayName05
    allowedVmSkus: allowedVmSkus
    backupEffect: backupEffect
  }
}

// ----------------------------------
// 06-StorageAccount-Policy Creation
// ----------------------------------

param initiativeName06 string //= '06-StorageAccountInitiative'
param assignmentName06 string //= '06-StorageAccountAssign' //ne doit pas depasse 24 characteres
param initiativeDisplayName06 string //= '06-StorageAccount Initiative' // The policy assignment name length must not exceed '24' characters
param assignmentDisplayName06 string //= '06-StorageAccount Assignment'

// région pour la Managed Identity de l’assignation (utile si un effet Modify est actif).
param assignmentLocation string //= 'canadacentral'

// Effects au choix
param secureTransferEffect string //= 'Modify'   // ou 'Disabled'
param tlsEffect string //= 'Audit'    // 'Audit' | 'Deny' | 'Disabled'
param minimumTlsVersion string //= 'TLS1_2'   // 'TLS1_0' | 'TLS1_1' | 'TLS1_2'
param publicAccessEffect string //= 'Deny'     // 'Audit' | 'Deny' | 'Disabled'

module storageAccount './policies/06_StorageAccount_Policy.bicep' = {
  name: 'deploy-06-storageaccount-policy'
  //scope: subscription(managementSubscriptionId)
  params: {
    initiativeName: initiativeName06
    assignmentName: assignmentName06
    initiativeDisplayName: initiativeDisplayName06
    assignmentDisplayName: assignmentDisplayName06
    assignmentLocation: assignmentLocation
    minimumTlsVersion: minimumTlsVersion
    publicAccessEffect: publicAccessEffect
    secureTransferEffect: secureTransferEffect
    tlsEffect: tlsEffect
  }
}

// ============================================
// RESOURCES GROUP CREATION
// ============================================

// Resource Group for Platform Management Resources (e.g. Log Analytics, policies, etc.)
module managementRg './modules/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-management-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-management'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// Resource Groups for identity and access management (e.g. Privileged Identity Management, etc.)
module identityRg './modules/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-identity-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-identity'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// Resource Group for networking resources (e.g. Virtual Networks, Subnets, etc.)
module networkingRg './modules/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-networking-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-networking'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// Resource Group for Monitoring resources (e.g. Azure Monitor, Log Analytics, etc.)
module monitoringRg './modules/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-monitoring-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-monitoring'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// ============================================
// PLATFORM RESOURCES (Logging)
// ============================================

// Log Analytics Workspace
// module logAnalytics 'log-analytics-workspace/main.bicep' = {
//   name: 'deploy-log-analytics'
//   scope: resourceGroup(managementSubscriptionId, resourceGroupName)
//   params: {
//     workspaceName: logAnalyticsWorkspaceName
//     location: location
//     sku: 'PerGB2018'
//     retentionInDays: logRetentionDays
//     dailyQuotaGb: 0
//     enableSentinel: enableSentinel
//     solutions: [
//       'SecurityCenterFree'
//       'Updates'
//       'VMInsights'
//       'ChangeTracking'
//       'AzureActivity'
//       'AgentHealthAssessment'
//     ]
//     tags: tags
//   }
//   dependsOn: [
//     managementRg
//   ]
// }

// ============================================
// OUTPUTS
// ============================================

output managementGroupIds object = {
  root: rootMg.outputs.managementGroupId
  prod: prodMg.outputs.managementGroupId
  logging: loggingMg.outputs.managementGroupId
  quarantine: quarantineMg.outputs.managementGroupId
}

output resourceGroupIds object = {
  management: managementRg.?outputs.resourceGroupId ?? ''
  identity: identityRg.?outputs.resourceGroupId ?? ''
  networking: networkingRg.?outputs.resourceGroupId ?? ''
  monitoring: monitoringRg.?outputs.resourceGroupId ?? ''
}

output policyInitiatives object = {
  taggingCustom: taggingPolicy.outputs.initiativeCustomPoliciesTagsId
  taggingBuiltin: taggingPolicy.outputs.initiativeBuiltinPoliciesTagsId
  general: generalPolicy.outputs.initiativeId
  network: networkPolicy.outputs.initiativeId
  keyVault: keyVaultPolicy.outputs.initiativeId
  vm: vmPolicy.outputs.initiativeId
  storageAccount: storageAccount.outputs.initiativeId
}

// output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId
// output logAnalyticsWorkspaceName string = logAnalytics.outputs.workspaceName
// output logAnalyticsCustomerId string = logAnalytics.outputs.customerId

// output policyInitiativeId string = lzBaselineInitiative.outputs.initiativeId
// output prodPolicyAssignmentId string = prodPolicyAssignment.outputs.assignmentId
// output devPolicyAssignmentId string = devPolicyAssignment.outputs.assignmentId
