// workload-lz/workload.bicep
// Complete Workload Landing Zone orchestrator for a 3-tier application

targetScope = 'subscription'

@description('Organization name')
param organizationName string

@description('Workload name')
param workloadName string

@description('Environment')
@allowed([
  'prod'
  'logging'
  'quarantine'
  'sandbox'
])
param environment string

@description('Azure region')
param location string = 'canadacentral'

// ============================================
// NETWORKING PARAMETERS
// ============================================

@description('Spoke VNet address prefix')
param spokeVnetAddressPrefix string

@description('Web tier subnet address prefix')
param webSubnetAddressPrefix string

@description('App tier subnet address prefix')
param appSubnetAddressPrefix string

@description('Data tier subnet address prefix')
param dataSubnetAddressPrefix string

@description('Private endpoints subnet address prefix')
param privateEndpointsSubnetAddressPrefix string

@description('Hub VNet resource ID')
param hubVnetId string

@description('Hub VNet resource group name')
param hubVnetResourceGroupName string

@description('Hub VNet subscription ID')
param hubVnetSubscriptionId string

@description('Azure Firewall private IP')
param azureFirewallPrivateIp string

// ============================================
// APPLICATION PARAMETERS
// ============================================

@description('App Service Plan SKU')
@allowed([
  'B1'
  'B2'
  'P1v3'
  'P2v3'
  'P3v3'
])
param appServicePlanSku string = 'P1v3'

@description('App Service runtime stack')
@allowed([
  'dotnet'
  'dotnetcore'
  'node'
  'python'
])
param appServiceRuntimeStack string = 'dotnetcore'

@description('App Service runtime version')
param appServiceRuntimeVersion string = '8'

// ============================================
// DATABASE PARAMETERS
// ============================================

@description('SQL Database SKU')
@allowed([
  'Basic'
  'S0'
  'S1'
  'GP_Gen5_2'
  'GP_Gen5_4'
  'BC_Gen5_2'
])
param sqlDatabaseSku string = 'GP_Gen5_2'

@description('SQL Server administrator login')
@secure()
param sqlAdminLogin string

@description('SQL Server administrator password')
@secure()
param sqlAdminPassword string

@description('Azure AD admin object ID for SQL')
param sqlAzureADAdminObjectId string

@description('Azure AD admin login for SQL')
param sqlAzureADAdminLogin string

// ============================================
// IDENTITY PARAMETERS
// ============================================

@description('Managed Identity resource ID for the application')
param managedIdentityId string

// ============================================
// SHARED RESOURCES PARAMETERS
// ============================================

@description('Log Analytics Workspace ID')
param logAnalyticsWorkspaceId string

@description('Private DNS Zone ID for Web Apps')
param privateDnsZoneIdSites string

@description('Private DNS Zone ID for SQL')
param privateDnsZoneIdSql string

@description('Private DNS Zone ID for Storage')
param privateDnsZoneIdBlob string

@description('Private DNS Zone ID for Key Vault')
param privateDnsZoneIdKeyVault string

@description('Enable DDoS Protection')
param enableDdosProtection bool = false

@description('DDoS Protection Plan ID')
param ddosProtectionPlanId string = ''

@description('Tags to apply to all resources')
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  Workload: workloadName
}

// ============================================
// VARIABLES
// ============================================

var resourceGroupName = 'rg-${organizationName}-${workloadName}-${environment}-${location}'
var appServicePlanName = 'asp-${organizationName}-${workloadName}-${environment}'
var appServiceName = 'app-${organizationName}-${workloadName}-${environment}'
var sqlServerName = 'sql-${organizationName}-${workloadName}-${environment}'
var sqlDatabaseName = '${workloadName}-db-${environment}'
var storageAccountName = toLower(replace(
  'st${organizationName}${workloadName}${environment}${uniqueString(subscription().id)}',
  '-',
  ''
))
var keyVaultName = 'kv-${workloadName}-${environment}-${uniqueString(subscription().id)}'
var appInsightsName = 'appi-${organizationName}-${workloadName}-${environment}'

// ============================================
// RESOURCE GROUP
// ============================================

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// ============================================
// SPOKE NETWORK (3-TIER)
// ============================================

module spokeNetwork './modules/spoke_vnet.bicep' = {
  name: 'deploy-spoke-network'
  params: {
    organizationName: organizationName
    workloadName: workloadName
    environment: environment
    location: location
    spokeVnetAddressPrefix: spokeVnetAddressPrefix
    webSubnetAddressPrefix: webSubnetAddressPrefix
    appSubnetAddressPrefix: appSubnetAddressPrefix
    dataSubnetAddressPrefix: dataSubnetAddressPrefix
    privateEndpointsSubnetAddressPrefix: privateEndpointsSubnetAddressPrefix
    hubVnetId: hubVnetId
    hubVnetResourceGroupName: hubVnetResourceGroupName
    hubVnetSubscriptionId: hubVnetSubscriptionId
    azureFirewallPrivateIp: azureFirewallPrivateIp
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDdosProtection: enableDdosProtection
    ddosProtectionPlanId: ddosProtectionPlanId
    tags: tags
  }
}

// ============================================
// APPLICATION INSIGHTS
// ============================================

module applicationInsights './modules/application_insights.bicep' = {
  scope: resourceGroup
  name: 'deploy-app-insights'
  params: {
    appInsightsName: appInsightsName
    location: location
    applicationType: 'web'
    workspaceResourceId: logAnalyticsWorkspaceId
    retentionInDays: environment == 'prod' ? 90 : 30
    tags: tags
  }
}

// ============================================
// KEY VAULT
// ============================================

module keyVault './modules/key_vault.bicep' = {
  scope: resourceGroup
  name: 'deploy-key-vault'
  params: {
    keyVaultName: keyVaultName
    location: location
    skuName: environment == 'prod' ? 'premium' : 'standard'
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enablePurgeProtection: environment == 'prod'
    publicNetworkAccess: false
    networkAclsDefaultAction: 'Deny'
    subnetIds: [
      spokeNetwork.outputs.appSubnetId
    ]
    enablePrivateEndpoint: true
    privateEndpointSubnetId: spokeNetwork.outputs.privateEndpointsSubnetId
    privateDnsZoneIdKeyVault: privateDnsZoneIdKeyVault
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  dependsOn: [
    spokeNetwork
  ]
}

// ============================================
// STORAGE ACCOUNT
// ============================================

module storageAccount './modules/storage_account.bicep' = {
  scope: resourceGroup
  name: 'deploy-storage-account'
  params: {
    storageAccountName: storageAccountName
    location: location
    skuName: environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAclsDefaultAction: 'Deny'
    subnetIds: [
      spokeNetwork.outputs.appSubnetId
      spokeNetwork.outputs.dataSubnetId
    ]
    enableBlobSoftDelete: true
    blobSoftDeleteRetentionDays: environment == 'prod' ? 30 : 7
    enableContainerSoftDelete: true
    containerSoftDeleteRetentionDays: environment == 'prod' ? 30 : 7
    enableVersioning: environment == 'prod'
    enablePrivateEndpoint: true
    privateEndpointSubnetId: spokeNetwork.outputs.privateEndpointsSubnetId
    privateDnsZoneIdBlob: privateDnsZoneIdBlob
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  dependsOn: [
    spokeNetwork
  ]
}

// ============================================
// SQL DATABASE
// ============================================

module sqlDatabase './modules/sql_database.bicep' = {
  scope: resourceGroup
  name: 'deploy-sql-database'
  params: {
    sqlServerName: sqlServerName
    sqlDatabaseName: sqlDatabaseName
    location: location
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    enableAzureADAuthentication: true
    azureADAdminObjectId: sqlAzureADAdminObjectId
    azureADAdminLogin: sqlAzureADAdminLogin
    databaseSku: sqlDatabaseSku
    maxSizeGb: environment == 'prod' ? 256 : 32
    zoneRedundant: environment == 'prod'
    backupRetentionDays: environment == 'prod' ? 35 : 7
    enableLongTermRetention: environment == 'prod'
    publicNetworkAccess: false
    minimalTlsVersion: '1.2'
    enablePrivateEndpoint: true
    privateEndpointSubnetId: spokeNetwork.outputs.privateEndpointsSubnetId
    privateDnsZoneIdSql: privateDnsZoneIdSql
    allowedSubnetIds: [
      spokeNetwork.outputs.appSubnetId
      spokeNetwork.outputs.dataSubnetId
    ]
    enableAdvancedThreatProtection: true
    enableAuditing: true
    auditStorageAccountId: storageAccount.outputs.storageAccountId
    enableTde: true
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  dependsOn: [
    spokeNetwork
    storageAccount
  ]
}

// Store SQL connection string in Key Vault
module sqlConnectionStringSecret './modules/key_vault.bicep' = {
  scope: resourceGroup
  name: 'store-sql-connection-string'
  params: {
    keyVaultName: keyVaultName
    location: location
    skuName: 'standard'
    enableRbacAuthorization: true
    secrets: [
      {
        name: 'SqlConnectionString'
        value: 'Server=tcp:${sqlDatabase.outputs.sqlServerFqdn},1433;Initial Catalog=${sqlDatabaseName};Authentication=Active Directory Managed Identity;Encrypt=True;'
        contentType: 'connection-string'
      }
    ]
    publicNetworkAccess: false
    enablePrivateEndpoint: false
    tags: tags
  }
  dependsOn: [
    keyVault
    sqlDatabase
  ]
}

// ============================================
// APP SERVICE
// ============================================

module appService './modules/app_service.bicep' = {
  scope: resourceGroup
  name: 'deploy-app-service'
  params: {
    appServicePlanName: appServicePlanName
    appServiceName: appServiceName
    location: location
    skuName: appServicePlanSku
    skuCapacity: environment == 'prod' ? 3 : 1
    runtimeStack: appServiceRuntimeStack
    runtimeVersion: appServiceRuntimeVersion
    alwaysOn: true
    httpsOnly: true
    minTlsVersion: '1.2'
    publicNetworkAccess: false
    enableVNetIntegration: true
    vnetIntegrationSubnetId: spokeNetwork.outputs.appSubnetId
    enablePrivateEndpoint: true
    privateEndpointSubnetId: spokeNetwork.outputs.privateEndpointsSubnetId
    privateDnsZoneIdSites: privateDnsZoneIdSites
    appInsightsInstrumentationKey: applicationInsights.outputs.instrumentationKey
    appInsightsConnectionString: applicationInsights.outputs.connectionString
    managedIdentityId: managedIdentityId
    keyVaultName: keyVaultName
    appSettings: {
      'ASPNETCORE_ENVIRONMENT': environment == 'prod'
        ? 'Production'
        : environment == 'staging' ? 'Staging' : 'Development'
      'KeyVaultUri': keyVault.outputs.keyVaultUri
      'StorageAccountName': storageAccountName
    }
    connectionStrings: [
      {
        name: 'DefaultConnection'
        connectionString: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=SqlConnectionString)'
        type: 'SQLAzure'
      }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
  dependsOn: [
    spokeNetwork
    applicationInsights
    keyVault
    sqlDatabase
  ]
}

// ============================================
// RBAC ASSIGNMENTS
// ============================================

// App Service Managed Identity -> Key Vault Secrets User
module rbacKeyVaultSecretsUser '../identity-lz/modules/rbac_assignment.bicep' = {
  scope: resourceGroup
  name: 'rbac-keyvault-secrets-user'
  params: {
    principalId: appService.outputs.principalId
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
    description: 'Allow App Service to read secrets from Key Vault'
  }
  dependsOn: [
    keyVault
    appService
  ]
}

// App Service Managed Identity -> Storage Blob Data Contributor
module rbacStorageBlobContributor '../identity-lz/modules/rbac_assignment.bicep' = {
  scope: resourceGroup
  name: 'rbac-storage-blob-contributor'
  params: {
    principalId: appService.outputs.principalId
    roleDefinitionIdOrName: 'Storage Blob Data Contributor'
    principalType: 'ServicePrincipal'
    description: 'Allow App Service to read/write blobs in Storage Account'
  }
  dependsOn: [
    storageAccount
    appService
  ]
}

// ============================================
// OUTPUTS
// ============================================

output resourceGroupName string = spokeNetwork.outputs.resourceGroupName
output resourceGroupId string = spokeNetwork.outputs.resourceGroupId

output spokeVnetId string = spokeNetwork.outputs.spokeVnetId
output spokeVnetName string = spokeNetwork.outputs.spokeVnetName

output appServiceId string = appService.outputs.appServiceId
output appServiceName string = appService.outputs.appServiceName
output appServiceUrl string = 'https://${appService.outputs.appServiceDefaultHostname}'

output sqlServerId string = sqlDatabase.outputs.sqlServerId
output sqlServerName string = sqlDatabase.outputs.sqlServerName
output sqlDatabaseName string = sqlDatabase.outputs.sqlDatabaseName

output keyVaultId string = keyVault.outputs.keyVaultId
output keyVaultName string = keyVault.outputs.keyVaultName
output keyVaultUri string = keyVault.outputs.keyVaultUri

output storageAccountId string = storageAccount.outputs.storageAccountId
output storageAccountName string = storageAccount.outputs.storageAccountName

output appInsightsId string = applicationInsights.outputs.appInsightsId
output appInsightsName string = applicationInsights.outputs.appInsightsName
output appInsightsConnectionString string = applicationInsights.outputs.connectionString
