// workload-lz/workload.bicepparam
using './workload.bicep'

// Organization and workload
param organizationName = 'acmy'
param workloadName = 'crm'
param environment = 'prod'
param location = 'canadacentral'

// ============================================
// NETWORKING CONFIGURATION
// ============================================

// Spoke VNet addressing (10.3.0.0/20 for this workload)
param spokeVnetAddressPrefix = '10.3.0.0/20'
param webSubnetAddressPrefix = '10.3.0.0/24'
param appSubnetAddressPrefix = '10.3.1.0/24'
param dataSubnetAddressPrefix = '10.3.2.0/24'
param privateEndpointsSubnetAddressPrefix = '10.3.4.0/24'

// Hub VNet information (from Connectivity deployment)
param hubVnetId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-acmy-hub-prod-canadacentral/providers/Microsoft.Network/virtualNetworks/vnet-acmy-hub-prod-canadacentral'
param hubVnetResourceGroupName = 'rg-acmy-hub-prod-canadacentral'
param hubVnetSubscriptionId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
param azureFirewallPrivateIp = '10.0.1.4'

// ============================================
// APPLICATION CONFIGURATION
// ============================================

param appServicePlanSku = 'P1v3'
param appServiceRuntimeStack = 'dotnetcore'
param appServiceRuntimeVersion = '8'

// ============================================
// DATABASE CONFIGURATION
// ============================================

param sqlDatabaseSku = 'GP_Gen5_2'
param sqlAdminLogin = 'sqladmin'
param sqlAdminPassword = 'P@ssw0rd123!' // CHANGEZ CECI! Utilisez Key Vault ou des secrets Azure DevOps
param sqlAzureADAdminObjectId = '11111111-1111-1111-1111-111111111111' // Group ID from Identity deployment
param sqlAzureADAdminLogin = 'contoso-DB-Admins'

// ============================================
// IDENTITY CONFIGURATION
// ============================================

// Managed Identity for the application (from Identity deployment)
param managedIdentityId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-contoso-identity-prod-canadacentral/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-contoso-app-deploy-prod'

// ============================================
// SHARED RESOURCES
// ============================================

// Log Analytics (from Platform deployment)
param logAnalyticsWorkspaceId = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-platform-management-prod/providers/Microsoft.OperationalInsights/workspaces/law-contoso-platform-prod'

// Private DNS Zones (should be created in Hub)
param privateDnsZoneIdSites = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-contoso-hub-prod-canadacentral/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net'
param privateDnsZoneIdSql = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-contoso-hub-prod-canadacentral/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net'
param privateDnsZoneIdBlob = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-contoso-hub-prod-canadacentral/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'
param privateDnsZoneIdKeyVault = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-contoso-hub-prod-canadacentral/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net'

// DDoS Protection (optional, from Hub deployment)
param enableDdosProtection = false
param ddosProtectionPlanId = ''

// ============================================
// TAGGING
// ============================================

param tags = {
  Environment: 'Production'
  ManagedBy: 'Bicep'
  CostCenter: 'Sales'
  Owner: 'CRM-Team'
  Workload: 'CRM'
  Criticality: 'High'
  DataClassification: 'Confidential'
}
