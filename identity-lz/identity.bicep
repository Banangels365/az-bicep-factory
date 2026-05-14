// identity/main.bicep
// Identity Landing Zone orchestrator

targetScope = 'subscription'

@description('Organization name')
param organizationName string

@description('Environment')
@allowed([
  'prod' // production
  'logs' // logging/monitoring
  'quar' // quarantine
  'sbox' // sandbox
])
param environment string

@description('Azure region')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('Tags to apply to all resources')
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  Purpose: 'Identity'
}

@description('Group IDs from Entra ID creation (loaded from JSON file)')
param entraGroupIds object

@description('Management subscription ID')
param managementSubscriptionId string

@description('Prod subscription ID')
param prodSubscriptionId string

@description('Logging subscription ID')
param loggingSubscriptionId string

@description('Quarantine subscription ID')
param quarantineSubscriptionId string

@description('Identity Resource Group (must exist prior to deployment)')
param identityResourceGroupName string

// Variables
// var resourceGroupName = 'rg-${organizationName}-identity-${environment}-${location}'

// Managed Identity names
var miPlatformName = 'mi-${organizationName}-platform-${environment}'
var miNetworkName = 'mi-${organizationName}-network-${environment}'
var miAppDeployName = 'mi-${organizationName}-app-deploy-${environment}'
var miBackupName = 'mi-${organizationName}-backup-${environment}'
var miMonitoringName = 'mi-${organizationName}-monitoring-${environment}'

// ============================================
// RESOURCE GROUP
// ============================================

// resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
//   name: resourceGroupName
//   location: location
//   tags: tags
// }

// ============================================
// MANAGED IDENTITIES
// ============================================

module miPlatform './modules/managed_identity.bicep' = {
  scope: resourceGroup(identityResourceGroupName)
  name: 'deploy-mi-platform'
  params: {
    managedIdentityName: miPlatformName
    location: location
    tags: union(tags, {
      Purpose: 'Platform-Management'
    })
  }
}

module miNetwork './modules/managed_identity.bicep' = {
  scope: resourceGroup(identityResourceGroupName)
  name: 'deploy-mi-network'
  params: {
    managedIdentityName: miNetworkName
    location: location
    tags: union(tags, {
      Purpose: 'Network-Management'
    })
  }
}

module miAppDeploy './modules/managed_identity.bicep' = {
  scope: resourceGroup(identityResourceGroupName)
  name: 'deploy-mi-app-deploy'
  params: {
    managedIdentityName: miAppDeployName
    location: location
    tags: union(tags, {
      Purpose: 'Application-Deployment'
    })
  }
}

module miBackup './modules/managed_identity.bicep' = {
  scope: resourceGroup(identityResourceGroupName)
  name: 'deploy-mi-backup'
  params: {
    managedIdentityName: miBackupName
    location: location
    tags: union(tags, {
      Purpose: 'Backup-Operations'
    })
  }
}

module miMonitoring './modules/managed_identity.bicep' = {
  scope: resourceGroup(identityResourceGroupName)
  name: 'deploy-mi-monitoring'
  params: {
    managedIdentityName: miMonitoringName
    location: location
    tags: union(tags, {
      Purpose: 'Monitoring-Alerting'
    })
  }
}

// ============================================
// RBAC ASSIGNMENTS - SUBSCRIPTION LEVEL
// ============================================

// Platform Admins Group - Contributor on Management Subscription
module rbacPlatformAdmins './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(managementSubscriptionId)
  name: 'rbac-platform-admins-mgmt'
  params: {
    principalId: entraGroupIds.platformAdmins
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'Group'
    roleAssignmentDescription: 'Platform Admins - Contributor on Management Subscription'
  }
}

// Network Admins Group - Network Contributor
module rbacNetworkAdmins './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-network-admins-mgmt'
  params: {
    principalId: entraGroupIds.networkAdmins
    roleDefinitionIdOrName: 'Network Contributor'
    principalType: 'Group'
    roleAssignmentDescription: 'Network Admins - Network Contributor'
  }
}

// Security Admins Group - Security Admin
module rbacSecurityAdmins './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-security-admins-mgmt'
  params: {
    principalId: entraGroupIds.securityAdmins
    roleDefinitionIdOrName: 'Security Admin'
    principalType: 'Group'
    roleAssignmentDescription: 'Security Admins - Security Admin'
  }
}

// Cost Managers - Cost Management Contributor
module rbacCostManagers './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(managementSubscriptionId)
  name: 'rbac-cost-managers'
  params: {
    principalId: entraGroupIds.costManagers
    roleDefinitionIdOrName: 'Cost Management Contributor'
    principalType: 'Group'
    roleAssignmentDescription: 'Cost Managers - Cost Management Contributor'
  }
}

// Billing Readers - Cost Management Reader
module rbacBillingReaders './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(managementSubscriptionId)
  name: 'rbac-billing-readers'
  params: {
    principalId: entraGroupIds.billingReaders
    roleDefinitionIdOrName: 'Cost Management Reader'
    principalType: 'Group'
    roleAssignmentDescription: 'Billing Readers - Cost Management Reader'
  }
}

// Prod Admins - Contributor on Prod Subscription
module rbacProdAdmins './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-prod-admins'
  params: {
    principalId: entraGroupIds.prodAdmins
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'Group'
    roleAssignmentDescription: 'Prod Admins - Contributor on Prod Subscription'
  }
}

// Prod Readers - Reader on Prod Subscription
module rbacProdReaders './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-prod-readers'
  params: {
    principalId: entraGroupIds.prodReaders
    roleDefinitionIdOrName: 'Reader'
    principalType: 'Group'
    roleAssignmentDescription: 'Prod Readers - Reader on Prod Subscription'
  }
}

// Logging Admins - Contributor on Logging Subscription
module rbacLoggingAdmins './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(loggingSubscriptionId)
  name: 'rbac-logging-admins'
  params: {
    principalId: entraGroupIds.loggingAdmins
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'Group'
    roleAssignmentDescription: 'Logging Admins - Contributor on Logging Subscription'
  }
}

// Logging Contributors - Contributor on Logging Subscription
module rbacLoggingContributors './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(loggingSubscriptionId)
  name: 'rbac-logging-contributors'
  params: {
    principalId: entraGroupIds.loggingContributors
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'Group'
    roleAssignmentDescription: 'Logging Contributors - Contributor on Logging Subscription'
  }
}

// Logging Readers - Reader on Logging Subscription
module rbacLoggingReaders './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(loggingSubscriptionId)
  name: 'rbac-logging-readers'
  params: {
    principalId: entraGroupIds.loggingReaders
    roleDefinitionIdOrName: 'Reader'
    principalType: 'Group'
    roleAssignmentDescription: 'Logging Readers - Reader on Logging Subscription'
  }
}

// Quarantine Admins - Contributor on Quarantine Subscription
module rbacQuarantineAdmins './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(quarantineSubscriptionId)
  name: 'rbac-quarantine-admins'
  params: {
    principalId: entraGroupIds.quarantineAdmins
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'Group'
    roleAssignmentDescription: 'Quarantine Admins - Contributor on Quarantine Subscription'
  }
}

// Quarantine Contributors - Contributor on Quarantine Subscription
module rbacQuarantineContributors './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(quarantineSubscriptionId)
  name: 'rbac-quarantine-contributors'
  params: {
    principalId: entraGroupIds.quarantineContributors
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'Group'
    roleAssignmentDescription: 'Quarantine Contributors - Contributor on Quarantine Subscription'
  }
}

// Quarantine Readers - Reader on Quarantine Subscription
module rbacQuarantineReaders './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(quarantineSubscriptionId)
  name: 'rbac-quarantine-readers'
  params: {
    principalId: entraGroupIds.quarantineReaders
    roleDefinitionIdOrName: 'Reader'
    principalType: 'Group'
    roleAssignmentDescription: 'Quarantine Readers - Reader on Quarantine Subscription'
  }
}

// ============================================
// RBAC FOR MANAGED IDENTITIES
// ============================================

// Platform MI - Contributor on Management Subscription
module rbacPlatformMI './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(managementSubscriptionId)
  name: 'rbac-platform-mi'
  params: {
    principalId: miPlatform.outputs.principalId
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'Platform Managed Identity - Contributor'
  }
}

// Network MI - Network Contributor on Management Subscription
module rbacNetworkMI './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(managementSubscriptionId)
  name: 'rbac-network-mi'
  params: {
    principalId: miNetwork.outputs.principalId
    roleDefinitionIdOrName: 'Network Contributor'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'Network Managed Identity - Network Contributor'
  }
}

// App Deploy MI - Contributor on logging subscriptions
module rbacAppDeployMILog './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(loggingSubscriptionId)
  name: 'rbac-app-deploy-mi-logging'
  params: {
    principalId: miAppDeploy.outputs.principalId
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'App Deploy Managed Identity - Contributor on Logging'
  }
}

module rbacAppDeployMIProd './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-app-deploy-mi-prod'
  params: {
    principalId: miAppDeploy.outputs.principalId
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'App Deploy Managed Identity - Contributor on Prod'
  }
}

// Backup MI - Backup Contributor
module rbacBackupMI './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(managementSubscriptionId)
  name: 'rbac-backup-mi'
  params: {
    principalId: miBackup.outputs.principalId
    roleDefinitionIdOrName: 'Backup Contributor'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'Backup Managed Identity - Backup Contributor'
  }
}

// Monitoring MI - Monitoring Reader on all subscriptions
module rbacMonitoringMIMgmt './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(managementSubscriptionId)
  name: 'rbac-monitoring-mi-mgmt'
  params: {
    principalId: miMonitoring.outputs.principalId
    roleDefinitionIdOrName: 'Monitoring Reader'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'Monitoring Managed Identity - Monitoring Reader'
  }
}

// ============================================
// OUTPUTS
// ============================================

// output resourceGroupName string = resourceGroup.name
// output resourceGroupId string = resourceGroup.id

output managedIdentities object = {
  platform: {
    id: miPlatform.outputs.managedIdentityId
    principalId: miPlatform.outputs.principalId
    clientId: miPlatform.outputs.clientId
  }
  network: {
    id: miNetwork.outputs.managedIdentityId
    principalId: miNetwork.outputs.principalId
    clientId: miNetwork.outputs.clientId
  }
  appDeploy: {
    id: miAppDeploy.outputs.managedIdentityId
    principalId: miAppDeploy.outputs.principalId
    clientId: miAppDeploy.outputs.clientId
  }
  backup: {
    id: miBackup.outputs.managedIdentityId
    principalId: miBackup.outputs.principalId
    clientId: miBackup.outputs.clientId
  }
  monitoring: {
    id: miMonitoring.outputs.managedIdentityId
    principalId: miMonitoring.outputs.principalId
    clientId: miMonitoring.outputs.clientId
  }
}
