// workload-lz/modules/storage/storage_account.bicep
// Ce module définit un compte de stockage Azure, qui est une ressource de base pour stocker des données dans Azure. 
// Le compte de stockage peut être configuré avec différents types de services (Blob, File, Queue, Table) et options de sécurité, de performance et de gestion.

targetScope = 'resourceGroup'

import { roleAssignmentType } from './types.bicep'

@description('Nom du compte de stockage.')
@minLength(3)
@maxLength(24)
param name string

@description('Région de déploiement.')
param location string = resourceGroup().location

@allowed([
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
@description('Type de compte de stockage.')
param kind string = 'StorageV2'

@allowed([
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'PremiumV2_LRS'
  'PremiumV2_ZRS'
])
@description('SKU du compte de stockage.')
param skuName string = 'Standard_LRS'

@allowed([
  'Hot'
  'Cool'
  'Cold'
  'Premium'
])
@description('Tier d\'accès, surtout utile pour BlobStorage.')
param accessTier string = 'Hot'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Activation des large file shares.')
param largeFileSharesState string = 'Disabled'

@description('Autorise l\'accès Shared Key.')
param allowSharedKeyAccess bool = false

@description('Utilise OAuth par défaut.')
param defaultToOAuthAuthentication bool = true

@description('Configuration d\'authentification Azure Files.')
param azureFilesIdentityBasedAuthentication object = {}

@description('ACL réseau du compte.')
param networkAcls object = {}

@description('Règles de cycle de vie / management policy.')
param managementPolicyRules array = []

@description('Tags à appliquer.')
param tags object = {}

@description('Role assignments au niveau du compte.')
param roleAssignments roleAssignmentType[] = []

@description('Configuration du blob service.')
param blobService object = {}

@description('Configuration du file service.')
param fileService object = {}

@description('Configuration du queue service.')
param queueService object = {}

@description('Configuration du table service.')
param tableService object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: name
  location: location
  kind: kind
  sku: {
    name: skuName
  }
  tags: tags
  properties: {
    accessTier: contains(
        [
          'BlobStorage'
          'BlockBlobStorage'
        ],
        kind
      )
      ? accessTier
      : null
    allowSharedKeyAccess: allowSharedKeyAccess
    defaultToOAuthAuthentication: defaultToOAuthAuthentication
    largeFileSharesState: kind == 'FileStorage' ? null : largeFileSharesState
    azureFilesIdentityBasedAuthentication: azureFilesIdentityBasedAuthentication
    networkAcls: networkAcls
  }
}

resource storageAccountRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in roleAssignments: {
    name: roleAssignment.?name ?? guid(storageAccount.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    scope: storageAccount
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      principalType: roleAssignment.?principalType
      description: roleAssignment.?description
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
  }
]

resource managementPolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2025-01-01' = if (!empty(managementPolicyRules)) {
  name: 'default'
  parent: storageAccount
  properties: {
    policy: {
      rules: managementPolicyRules
    }
  }
}

module blobServiceModule './storage_blob_service.bicep' = if (blobService != null) {
  name: '${deployment().name}-blobService'
  params: {
    storageAccountName: storageAccount.name
    service: blobService
  }
}

module fileServiceModule './storage_file_service.bicep' = if (fileService != null) {
  name: '${deployment().name}-fileService'
  params: {
    storageAccountName: storageAccount.name
    service: fileService
  }
}

module queueServiceModule './storage_queue_service.bicep' = if (queueService != null) {
  name: '${deployment().name}-queueService'
  params: {
    storageAccountName: storageAccount.name
    service: queueService
  }
}

module tableServiceModule './storage_table_service.bicep' = if (tableService != null) {
  name: '${deployment().name}-tableService'
  params: {
    storageAccountName: storageAccount.name
    service: tableService
  }
}

output name string = storageAccount.name
output resourceId string = storageAccount.id
