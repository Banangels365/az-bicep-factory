// modules/data/storage-account/main.bicep
// Storage Account module following Azure Landing Zone best practices

@description('The name of the storage account (must be globally unique)')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Location for the storage account')
param location string = resourceGroup().location

@description('Storage account SKU')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param skuName string = 'Standard_LRS'

@description('Storage account kind')
@allowed([
  'Storage'
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
param kind string = 'StorageV2'

@description('Access tier for the storage account')
@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

@description('Enable hierarchical namespace (Data Lake Gen2)')
param enableHierarchicalNamespace bool = false

@description('Enable HTTPS traffic only')
param supportsHttpsTrafficOnly bool = true

@description('Minimum TLS version')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

@description('Allow blob public access')
param allowBlobPublicAccess bool = false

@description('Allow shared key access')
param allowSharedKeyAccess bool = true

@description('Enable infrastructure encryption')
param requireInfrastructureEncryption bool = true

@description('Default action for network rules')
@allowed([
  'Allow'
  'Deny'
])
param networkAclsDefaultAction string = 'Deny'

@description('Array of allowed IP addresses or CIDR blocks')
param allowedIpAddresses array = []

@description('Array of subnet resource IDs for virtual network rules')
param subnetIds array = []

@description('Enable blob soft delete')
param enableBlobSoftDelete bool = true

@description('Number of days to retain deleted blobs')
param blobSoftDeleteRetentionDays int = 7

@description('Enable container soft delete')
param enableContainerSoftDelete bool = true

@description('Number of days to retain deleted containers')
param containerSoftDeleteRetentionDays int = 7

@description('Enable versioning for blobs')
param enableVersioning bool = true

@description('Enable change feed')
param enableChangeFeed bool = false

@description('Tags to apply to the storage account')
param tags object = {}

@description('Enable private endpoint')
param enablePrivateEndpoint bool = false

@description('Subnet ID for private endpoint')
param privateEndpointSubnetId string = ''

@description('Private DNS Zone ID for blob')
param privateDnsZoneIdBlob string = ''

@description('Diagnostic settings - Log Analytics workspace ID')
param logAnalyticsWorkspaceId string = ''

@description('Enable diagnostic settings')
param enableDiagnostics bool = true

// Storage Account Resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    accessTier: accessTier
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    minimumTlsVersion: minimumTlsVersion
    allowBlobPublicAccess: allowBlobPublicAccess
    allowSharedKeyAccess: allowSharedKeyAccess
    isHnsEnabled: enableHierarchicalNamespace
    encryption: {
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: requireInfrastructureEncryption
    }
    networkAcls: {
      defaultAction: networkAclsDefaultAction
      bypass: 'AzureServices'
      ipRules: [for ip in allowedIpAddresses: {
        value: ip
        action: 'Allow'
      }]
      virtualNetworkRules: [for subnetId in subnetIds: {
        id: subnetId
        action: 'Allow'
      }]
    }
  }
}

// Blob Service with soft delete and versioning
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    deleteRetentionPolicy: {
      enabled: enableBlobSoftDelete
      days: blobSoftDeleteRetentionDays
    }
    containerDeleteRetentionPolicy: {
      enabled: enableContainerSoftDelete
      days: containerSoftDeleteRetentionDays
    }
    isVersioningEnabled: enableVersioning
    changeFeed: {
      enabled: enableChangeFeed
    }
  }
}

// Private Endpoint for Blob
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = if (enablePrivateEndpoint && !empty(privateEndpointSubnetId)) {
  name: '${storageAccountName}-blob-pe'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${storageAccountName}-blob-pe-connection'
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

// Private DNS Zone Group for Blob
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = if (enablePrivateEndpoint && !empty(privateDnsZoneIdBlob)) {
  parent: privateEndpoint
  name: 'blob-dns-zone-group'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'blob-config'
        properties: {
          privateDnsZoneId: privateDnsZoneIdBlob
        }
      }
    ]
  }
}

// Diagnostic Settings
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: storageAccount
  name: '${storageAccountName}-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

// Blob Diagnostic Settings
resource blobDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(logAnalyticsWorkspaceId)) {
  scope: blobService
  name: '${storageAccountName}-blob-diagnostics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

// Outputs
@description('Storage account resource ID')
output storageAccountId string = storageAccount.id

@description('Storage account name')
output storageAccountName string = storageAccount.name

@description('Primary blob endpoint')
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob

@description('Primary file endpoint')
output fileEndpoint string = storageAccount.properties.primaryEndpoints.file

@description('Primary queue endpoint')
output queueEndpoint string = storageAccount.properties.primaryEndpoints.queue

@description('Primary table endpoint')
output tableEndpoint string = storageAccount.properties.primaryEndpoints.table

@description('Private endpoint ID')
output privateEndpointId string = enablePrivateEndpoint ? privateEndpoint.id : ''