// landing-zone/identity/main.bicep
// Identity Landing Zone orchestrator

targetScope = 'subscription'

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

@description('Région Azure pour les ressources d\'identité')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('Tags à appliquer à toutes les ressources d\'identité')
param tags object

@description('ID des groupes Entra pour les affectations RBAC')
param entraGroupIds object

@description('ID de la subscription de production')
param prodSubscriptionId string = ''

@description('ID de la subscription de logging')
param loggingSubscriptionId string = ''

@description('ID de la subscription de quarantine')
param quarantineSubscriptionId string = ''

@description('Group de ressources d\'identité (doit exister avant le déploiement)')
param identityResourceGroupName string

// Managed Identity names
var miPlatformName = 'mi-${organizationName}-${environment}-${location}-platform'
var miNetworkName = 'mi-${organizationName}-${environment}-${location}-network'
var miAppDeployName = 'mi-${organizationName}-${environment}-${location}-app-deploy'
var miBackupName = 'mi-${organizationName}-${environment}-${location}-backup'
var miMonitoringName = 'mi-${organizationName}-${environment}-${location}-monitoring'

// ============================================
// MANAGED IDENTITIES
// ============================================

// Platform MI - Utilisé pour les tâches d'automatisation et de gestion au niveau de la plateforme-lz
module miPlatform '../../modules/authorization/managed_identity.bicep' = {
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

// Network MI - Utilisé pour les opérations liées au réseau (ex: NSG, Firewall, etc.)
module miNetwork '../../modules/authorization/managed_identity.bicep' = {
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

// Application Deploy MI - Utilisé pour les déploiements d'applications
module miAppDeploy '../../modules/authorization/managed_identity.bicep' = {
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

// Backup MI - Utilisé pour les opérations de sauvegarde
module miBackup '../../modules/authorization/managed_identity.bicep' = {
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

// Monitoring MI - Utilisé pour les opérations de surveillance et d'alerting
module miMonitoring '../../modules/authorization/managed_identity.bicep' = {
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

// ---------- RBAC for Production Subscription ----------------- //

// Prod Admins - Contributor on Prod Subscription
module rbacProdAdmins '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
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
module rbacProdReaders '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-prod-readers'
  params: {
    principalId: entraGroupIds.prodReaders
    roleDefinitionIdOrName: 'Reader'
    principalType: 'Group'
    roleAssignmentDescription: 'Prod Readers - Reader on Prod Subscription'
  }
}

// Network Admins Group - Network Contributor
module rbacNetworkAdmins '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
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
module rbacSecurityAdmins '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
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
module rbacCostManagers '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-cost-managers'
  params: {
    principalId: entraGroupIds.costManagers
    roleDefinitionIdOrName: 'Cost Management Contributor'
    principalType: 'Group'
    roleAssignmentDescription: 'Cost Managers - Cost Management Contributor'
  }
}

// Billing Readers - Cost Management Reader
module rbacBillingReaders '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-billing-readers'
  params: {
    principalId: entraGroupIds.billingReaders
    roleDefinitionIdOrName: 'Cost Management Reader'
    principalType: 'Group'
    roleAssignmentDescription: 'Billing Readers - Cost Management Reader'
  }
}

// ---------- RBAC for Logging Subscription ----------------- //
// Logging Admins - Contributor on Logging Subscription
module rbacLoggingAdmins '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(loggingSubscriptionId)) {
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
module rbacLoggingContributors '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(loggingSubscriptionId)) {
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
module rbacLoggingReaders '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(loggingSubscriptionId)) {
  scope: subscription(loggingSubscriptionId)
  name: 'rbac-logging-readers'
  params: {
    principalId: entraGroupIds.loggingReaders
    roleDefinitionIdOrName: 'Reader'
    principalType: 'Group'
    roleAssignmentDescription: 'Logging Readers - Reader on Logging Subscription'
  }
}

// ---------- RBAC for Quarantine Subscription ----------------- //
// Quarantine Admins - Contributor on Quarantine Subscription
module rbacQuarantineAdmins '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(quarantineSubscriptionId)) {
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
module rbacQuarantineContributors '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(quarantineSubscriptionId)) {
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
module rbacQuarantineReaders '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(quarantineSubscriptionId)) {
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
module rbacPlatformMI '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-platform-mi'
  params: {
    principalId: miPlatform.outputs.principalId
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'Platform Managed Identity - Contributor'
  }
}

// Network MI - Network Contributor on Management Subscription
module rbacNetworkMI '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-network-mi'
  params: {
    principalId: miNetwork.outputs.principalId
    roleDefinitionIdOrName: 'Network Contributor'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'Network Managed Identity - Network Contributor'
  }
}

// App Deploy MI - Contributor on logging subscriptions
module rbacAppDeployMILog '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(loggingSubscriptionId)) {
  scope: subscription(loggingSubscriptionId)
  name: 'rbac-app-deploy-mi-logging'
  params: {
    principalId: miAppDeploy.outputs.principalId
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'App Deploy Managed Identity - Contributor on Logging'
  }
}

module rbacAppDeployMIProd '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
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
module rbacBackupMI '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-backup-mi'
  params: {
    principalId: miBackup.outputs.principalId
    roleDefinitionIdOrName: 'Backup Contributor'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'Backup Managed Identity - Backup Contributor'
  }
}

// Monitoring MI - Monitoring Reader on production subscription
module rbacMonitoringMIMgmt '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(prodSubscriptionId)) {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-monitoring-mi-mgmt'
  params: {
    principalId: miMonitoring.outputs.principalId
    roleDefinitionIdOrName: 'Monitoring Reader'
    principalType: 'ServicePrincipal'
    roleAssignmentDescription: 'Monitoring Managed Identity - Monitoring Reader'
  }
}

// Monitoring MI - Monitoring Reader on logging subscription
module rbacMonitoringMILogging '../../modules/authorization/role-assignment/rbac_sub_scope.bicep' = if (!empty(loggingSubscriptionId)) {
  scope: subscription(loggingSubscriptionId)
  name: 'rbac-monitoring-mi-logging'
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
