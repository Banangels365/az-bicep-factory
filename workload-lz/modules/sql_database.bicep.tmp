// modules/data/sql-database/main.bicep
// Azure SQL Server and Database module with Private Endpoint

@description('SQL Server name')
param sqlServerName string

@description('SQL Database name')
param sqlDatabaseName string

@description('Location for the resources')
param location string = resourceGroup().location

@description('SQL Server administrator login')
@secure()
param administratorLogin string

@description('SQL Server administrator password')
@secure()
param administratorLoginPassword string

@description('Enable Azure AD authentication')
param enableAzureADAuthentication bool = true

@description('Azure AD administrator object ID')
param azureADAdminObjectId string = ''

@description('Azure AD administrator login name')
param azureADAdminLogin string = ''

@description('Database SKU')
@allowed([
  'Basic'
  'S0'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P4'
  'GP_Gen5_2'
  'GP_Gen5_4'
  'GP_Gen5_8'
  'BC_Gen5_2'
  'BC_Gen5_4'
])
param databaseSku string = 'GP_Gen5_2'

@description('Database max size in GB')
param maxSizeGb int = 32

@description('Enable zone redundancy')
param zoneRedundant bool = false

@description('Database backup retention in days')
@minValue(7)
@maxValue(35)
param backupRetentionDays int = 7

@description('Enable long-term backup retention')
param enableLongTermRetention bool = false

@description('Enable public network access')
param publicNetworkAccess bool = false

@description('Minimum TLS version')
@allowed([
  '1.0'
  '1.1'
  '1.2'
])
param minimalTlsVersion string = '1.2'

@description('Enable Private Endpoint')
param enablePrivateEndpoint bool = true

@description('Subnet ID for Private Endpoint')
param privateEndpointSubnetId string = ''

@description('Private DNS Zone ID for SQL')
param privateDnsZoneIdSql string = ''

@description('Allowed subnet IDs for firewall rules')
param allowedSubnetIds array = []

@description('Enable Advanced Threat Protection')
param enableAdvancedThreatProtection bool = true

@description('Enable auditing')
param enableAuditing bool = true

@description('Storage Account ID for audit logs')
param auditStorageAccountId string = ''

@description('Enable Transparent Data Encryption')
param enableTde bool = true

@description('Tags to apply to resources')
param tags object = {}

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

@description('Log Analytics Workspace ID')
param logAnalyticsWorkspaceId string = ''

// SQL Server
resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
    minimalTlsVersion: minimalTlsVersion
    publicNetworkAccess: publicNetworkAccess ? 'Enabled' : 'Disabled'
    administrators: enableAzureADAuthentication && !empty(azureADAdminObjectId) ? {
      administratorType: 'ActiveDirectory'
      principalType: 'Group'
      login: azureADAdminLogin
      sid: azureADAdminObjectId
      tenantId: subscription().tenantId
      azureADOnlyAuthentication: false
    } : null
  }
}

// Virtual Network Rules for SQL Server
resource virtualNetworkRules 'Microsoft.Sql/servers/virtualNetworkRules@2023-05-01-preview' = [for (subnetId, i) in allowedSubnetIds: {
  parent: sqlServer
  name: 'vnet-rule-${i}'
  properties: {
    virtualNetworkSubnetId: subnetId
    ignoreMissingVnetServiceEndpoint: false
  }
}]

// SQL Database
resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  tags: tags
  sku: {
    name: databaseSku
    tier: startsWith(databaseSku, 'GP') ? 'GeneralPurpose' : 
          startsWith(databaseSku, 'BC') ? 'BusinessCritical' : 
          startsWith(databaseSku, 'P') ? 'Premium' : 
          startsWith(databaseSku, 'S') ? 'Standard' : 'Basic'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: maxSizeGb * 1024 * 1024 * 1024
    zoneRedundant: zoneRedundant
    licenseType: 'LicenseIncluded'
    readScale: startsWith(databaseSku, 'BC') || startsWith(databaseSku, 'P') ? 'Enabled' : 'Disabled'
  }
}

// Transparent Data Encryption
resource tde 'Microsoft.Sql/servers/databases/transparentDataEncryption@2023-05-01-preview' = if (enableTde) {
  parent: sqlDatabase
  name: 'current'
  properties: {
    state: 'Enabled'
  }
}

// Backup Short-term Retention Policy
resource backupShortTermRetention 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2023-05-01-preview' = {
  parent: sqlDatabase
  name: 'default'
  properties: {
    retentionDays: backupRetentionDays
  }
}

// Backup Long-term Retention Policy
resource backupLongTermRetention 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2023-05-01-preview' = if (enableLongTermRetention) {
  parent: sqlDatabase
  name: 'default'
  properties: {
    weeklyRetention: 'P4W'
    monthlyRetention: 'P12M'
    yearlyRetention: 'P5Y'
    weekOfYear: 1
  }
}

// Advanced Threat Protection
resource advancedThreatProtection 'Microsoft.Sql/servers/securityAlertPolicies@2023-05-01-preview' = if (enableAdvancedThreatProtection) {
  parent: sqlServer
  name: 'Default'
  properties: {
    state: 'Enabled'
    emailAccountAdmins: true
  }
}

// Auditing
resource auditing 'Microsoft.Sql/servers/auditingSettings@2023-05-01-preview' = if (enableAuditing && !empty(auditStorageAccountId)) {
  parent: sqlServer
  name: 'default'
  properties: {
    state: 'Enabled'
    storageEndpoint: !empty(auditStorageAccountId) ? 'https://${split(auditStorageAccountId, '/')[8]}.blob.${environment().suffixes.storage}' : ''
    storageAccountAccessKey: ''
    storageAccountSubscriptionId: subscription().subscriptionId
    isStorageSecondaryKeyInUse: false
    retentionDays: 90
  }
}

// Private Endpoint for SQL Server
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId)) {
  name: '${sqlServerName}-pe'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${sqlServerName}-pe-connection'
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
}

// Private DNS Zone Group
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = if (enablePrivateEndpoint && !empty(privateDnsZoneIdSql)) {
  parent: privateEndpoint
  name: 'sql-dns-zone-group'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'sql-config'
        properties: {
          privateDnsZoneId: privateDnsZoneIdSql
        }
      }
    ]
  }
}

// Diagnostic Settings for SQL Database
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: sqlDatabase
  name: '${sqlDatabaseName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'SQLInsights'
        enabled: true
      }
      {
        category: 'AutomaticTuning'
        enabled: true
      }
      {
        category: 'QueryStoreRuntimeStatistics'
        enabled: true
      }
      {
        category: 'QueryStoreWaitStatistics'
        enabled: true
      }
      {
        category: 'Errors'
        enabled: true
      }
      {
        category: 'DatabaseWaitStatistics'
        enabled: true
      }
      {
        category: 'Timeouts'
        enabled: true
      }
      {
        category: 'Blocks'
        enabled: true
      }
      {
        category: 'Deadlocks'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'Basic'
        enabled: true
      }
      {
        category: 'InstanceAndAppAdvanced'
        enabled: true
      }
      {
        category: 'WorkloadManagement'
        enabled: true
      }
    ]
  }
}

// Outputs
@description('SQL Server resource ID')
output sqlServerId string = sqlServer.id

@description('SQL Server name')
output sqlServerName string = sqlServer.name

@description('SQL Server fully qualified domain name')
output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName

@description('SQL Database resource ID')
output sqlDatabaseId string = sqlDatabase.id

@description('SQL Database name')
output sqlDatabaseName string = sqlDatabase.name

@description('SQL Server principal ID (System-Assigned MI)')
output principalId string = sqlServer.identity.principalId

@description('Private Endpoint ID')
output privateEndpointId string = enablePrivateEndpoint ? privateEndpoint.id : ''

@description('Private Endpoint private IP address')
output privateEndpointIpAddress string = enablePrivateEndpoint ? privateEndpoint.properties.customDnsConfigs[0].ipAddresses[0] : ''

@description('Connection string (without password)')
output connectionString string = 'Server=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${sqlDatabaseName};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'