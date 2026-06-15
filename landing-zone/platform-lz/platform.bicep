// landing-zone/platform-lz/platform.bicep
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

@description('Région Azure de déploiement des ressources de la plateforme.')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('billing scope ID for subscription creation')
param managementSubscriptionId string

@description('Tags à appliquer aux ressources')
param tags object = {}

@description('Log Analytics retention in days')
@minValue(30)
@maxValue(730)
param logRetentionDays int = 90

@description('Activer Microsoft Sentinel')
param enableSentinel bool = false

// Variables
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// =================================================
// HIERARCHIE DE MANAGEMENT GROUPS ET SUBSCRIPTIONS
// =================================================

// Root Management Group (Tenant Root Group is implicit)
module rootMg '../../modules/management/management_group.bicep' = {
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
module prodMg '../../modules/management/management_group.bicep' = {
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
// module devMg '../../modules/management/management_group.bicep' = {
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
module loggingMg '../../modules/management/management_group.bicep' = {
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
module quarantineMg '../../modules/management/management_group.bicep' = {
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

// 01-Tagging-Policy Creation
module taggingPolicy '../../modules/authorization/policy-assignment/01_Tagging_Policy.bicep' = {
  name: 'deploy-01-tagging-policy'
  scope: subscription(managementSubscriptionId)
  params: {
    initiativeCustomPoliciesName: '01-Tag'
    initiativeCustomPoliciesDisplayName: '01-Tag'
    initiativeBuiltinPoliciesName: '01-Tag-Assignment'
    initiativeBuiltinPoliciesDisplayName: '01-Tag-Assignment'
    customPoliciesTags: [
      {
        name: 'Environnement'
        displayName: 'Tag - Environnement'
        field: 'tags.Environnement'
        allowedValues: [
          'prod' // production
          'dev' // development
          'logs' // logging/monitoring
          'quar' // quarantine
          'sbox' // sandbox
        ]
        nonComplianceMessage: 'Le tag Environnement doit être conforme aux valeurs acceptées : prod, dev, logs, quar ou sbox.'
      }
      {
        name: 'Criticite'
        displayName: 'Tag - Criticite'
        field: 'tags.Criticite'
        allowedValues: [
          'Eleve'
          'Moyen'
          'Bas'
        ]
        nonComplianceMessage: 'Le tag Criticite doit être conforme aux valeurs acceptées. Soit Eleve, Moyen ou Bas.'
      }
    ]
    builtinPoliciesTags: [
      {
        name: 'Application'
        type: 'requiredOnResourceGroup'
        nonComplianceMessage: 'Le tag FournisseurApp est obligatoire sur les Resource Groups.'
      }
      {
        name: 'Responsable'
        type: 'requiredOnResourceGroup'
        nonComplianceMessage: 'Le tag Responsable est obligatoire sur les Resource Groups.'
      }
      {
        name: 'ResponsableEmail'
        type: 'requiredOnResourceGroup'
        nonComplianceMessage: 'Le tag ResponsableEmail est obligatoire sur les Resource Groups.'
      }
      {
        name: 'CreePar'
        type: 'requiredOnResourceGroup'
        nonComplianceMessage: 'Le tag CreePar est obligatoire sur les Resource Groups.'
      }
      {
        name: 'CreeLe'
        type: 'requiredOnResourceGroup'
        nonComplianceMessage: 'Le tag CreeLe est obligatoire sur les Resource Groups.'
      }
    ]
  }
}

// 02-General-Policy Creation
module generalPolicy '../../modules/authorization/policy-assignment/02_General_Policy.bicep' = {
  name: 'deploy-02-general-policy'
  scope: subscription(managementSubscriptionId)
  params: {
    initiativeName: '02-General Initiative'
    assignmentName: '02-General Assignment'
    initiativeDisplayName: '02-General Initiative'
    assignmentDisplayName: '02-General Assignment'
    allowedLocations: [
      'canadacentral'
      'canadaeast'
    ]
  }
}

// 03-network-Policy Creation
module networkPolicy '../../modules/authorization/policy-assignment/03_Network_Policy.bicep' = {
  name: 'deploy-03-network-policy'
  params: {
    initiativeName: '03-network-Initiative'
    assignmentName: '03-network-Assignment' //ne doit pas depasse 24 
    initiativeDisplayName: '03-network-Assignment'
    assignmentDisplayName: '03-network-Assignment'
    initiativeCategory: 'General'
    enforcementMode: 'Default'
  }
}

// 04-keyVault-Policy Creation
module keyVaultPolicy '../../modules/authorization/policy-assignment/04_KeyVault_Policy.bicep' = {
  name: 'deploy-04-keyVault-policy'
  params: {
    initiativeName: '04-Keyvault-RBAC-Initiative'
    assignmentName: '04-Key-RBAC-Assignment'
    initiativeDisplayName: '04-Keyvault-RBAC-Initiative'
    assignmentDisplayName: '04-Keyvault-RBAC-Assignment'
    kvRbacEffect: 'Audit'
  }
}

// 05-VM-Policy Creation
module vmPolicy '../../modules/authorization/policy-assignment/05_VM_Policy.bicep' = {
  name: 'deploy-05-vm-policy'
  params: {
    initiativeName: '05-VM-Initiative'
    assignmentName: '05-VM-Assignment'
    initiativeDisplayName: '05-VM Initiative'
    assignmentDisplayName: '05-VM Assignment'
    allowedVmSkus: [
      'Standard_B2s'
      'Standard_DS1_v2'
      'Standard_DS2_v2'
    ]
    backupEffect: 'Disabled' // Utiliser 'AuditIfNotExists' pour activer l’audit, ou 'Disabled' pour désactiver temporairement l’audit
  }
}

// 06-StorageAccount-Policy Creation
module storageAccount '../../modules/authorization/policy-assignment/06_StorageAccount_Policy.bicep' = {
  name: 'deploy-06-storageaccount-policy'
  params: {
    initiativeName: '06-StorageAccountInitiative'
    assignmentName: '06-StorageAccountAssign' //ne doit pas depasse 24 characteres
    initiativeDisplayName: '06-StorageAccount Initiative' // Ne doit pas depasse 24 characteres
    assignmentDisplayName: '06-StorageAccount Assignment'
    assignmentLocation: deployment().location
    minimumTlsVersion: 'TLS1_2' // Utiliser 'TLS1_2' pour exiger TLS 1.2, ou 'Disabled' pour ne pas appliquer cette règle
    publicAccessEffect: 'Deny' // Utiliser 'Deny' pour bloquer les comptes de stockage qui permettent l’accès public, 'Audit' pour auditer les comptes de stockage qui permettent l’accès public, ou 'Disabled' pour ne pas appliquer cette règle
    secureTransferEffect: 'Modify' // Utiliser 'Modify' pour forcer le secure transfer, ou 'Disabled' pour ne pas appliquer cette règle
    tlsEffect: 'Audit' // Utiliser 'Audit' pour auditer les comptes de stockage qui n’utilisent pas TLS 1.2, 'Deny' pour bloquer la création de comptes de stockage qui n’utilisent pas TLS 1.2, ou 'Disabled' pour ne pas appliquer cette règle
  }
}

// ============================================
// CREATION DES GROUPES DE RESSOURCES 
// ============================================

// Resource Group for Platform Management Resources (e.g. Log Analytics, policies, etc.)
module managementRg '../../modules/management/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-management-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-management'
    location: resolvedLocation
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// Resource Groups for identity and access management (e.g. Privileged Identity Management, etc.)
module identityRg '../../modules/management/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-identity-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-identity'
    location: resolvedLocation
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// Resource Group for networking resources (e.g. Virtual Networks, Subnets, etc.)
module networkingRg '../../modules/management/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-networking-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-networking'
    location: resolvedLocation
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// Resource Group for Monitoring resources (e.g. Azure Monitor, Log Analytics, etc.)
module monitoringRg '../../modules/management/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-monitoring-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-monitoring'
    location: resolvedLocation
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// ========================================
// JOURNALISATION DES RESOURCES (LOGGING)
// ========================================

// Log Analytics Workspace
module logAnalytics '../../modules/logging/log_analytics_workspace.bicep' = {
  name: 'deploy-log-analytics'
  scope: resourceGroup(managementSubscriptionId, 'rg-${organizationName}-${environment}-${location}-monitoring')
  params: {
    workspaceName: 'law-${organizationName}-${environment}-${location}'
    location: resolvedLocation
    sku: 'PerGB2018'
    retentionInDays: logRetentionDays
    dailyQuotaGb: -1 // -1 = pas de limite quotidienne (recommandé pour sandbox). Valeur minimale acceptée par Azure : > 0.023
    enableSentinel: enableSentinel
    solutions: [
      'SecurityCenterFree'
      'Updates'
      'VMInsights'
      'ChangeTracking'
      'AzureActivity'
      'AgentHealthAssessment'
    ]
    tags: tags
  }
  dependsOn: [
    monitoringRg
  ]
}

// ========================================
// OUTPUTS
// ========================================

output managementGroupIds object = {
  root: rootMg.outputs.managementGroupId
  prod: prodMg.outputs.managementGroupId
  logging: loggingMg.outputs.managementGroupId
  quarantine: quarantineMg.outputs.managementGroupId
  // dev: devMg.outputs.managementGroupId
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

output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId
output logAnalyticsWorkspaceName string = logAnalytics.outputs.workspaceName
output logAnalyticsCustomerId string = logAnalytics.outputs.customerId
