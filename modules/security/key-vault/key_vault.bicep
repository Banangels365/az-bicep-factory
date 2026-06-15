// modules/security/key-vault/key_vault.bicep
// Ce module déploie un Key Vault avec des configurations flexibles, incluant les access policies, secrets, clés, private endpoints, et plus encore. 
// Il est conçu pour être réutilisable et adaptable à divers scénarios de sécurité et de gestion des clés dans Azure.

targetScope = 'resourceGroup'

@description('Nom du Key Vault. Doit être globalement unique.')
@minLength(3)
@maxLength(24)
param keyVaultName string

@description('Région de déploiement.')
param location string = resourceGroup().location

@description('Toutes les access policies à créer.')
param accessPolicies array = []

@description('Tous les secrets à créer.')
param secrets array

@description('Toutes les clés à créer.')
param keys array = []

@description('Active l\'usage du vault pour les déploiements.')
param enableVaultForDeployment bool = true

@description('Active l\'usage du vault pour les déploiements de templates.')
param enableVaultForTemplateDeployment bool = true

@description('Active l\'usage du vault pour le chiffrement disque.')
param enableVaultForDiskEncryption bool = true

@description('Active la suppression douce.')
param enableSoftDelete bool = true

@description('Durée de rétention de la suppression douce.')
@minValue(7)
@maxValue(90)
param softDeleteRetentionInDays int = 90

@description('Active l\'autorisation RBAC pour les data actions.')
param enableRbacAuthorization bool = true

@description('Mode de création du vault.')
@allowed([
  'default'
  'recover'
])
param createMode string = 'default'

@description('Active la purge protection.')
param enablePurgeProtection bool = true

@description('SKU du Key Vault.')
@allowed([
  'premium'
  'standard'
])
param skuName string = 'standard'

@description('Règles réseau du Key Vault.')
param networkAcls object = {}

@description('Accès réseau public. Si vide, la valeur est calculée selon la présence de private endpoints.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Configuration du lock.')
param lock object = {}

@description('Role assignments sur le vault.')
param roleAssignments array = []

@description('Configuration des private endpoints.')
param privateEndpoints array = []

@description('Tags à appliquer au key vault.')
param tags object = {}

@description('Paramètres de diagnostic.')
param diagnosticSettings array = []

var formattedAccessPolicies = [
  for accessPolicy in accessPolicies: {
    applicationId: accessPolicy.?applicationId ?? ''
    objectId: accessPolicy.objectId
    permissions: accessPolicy.permissions
    tenantId: accessPolicy.?tenantId ?? tenant().tenantId
  }
]

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    enabledForDeployment: enableVaultForDeployment
    enabledForTemplateDeployment: enableVaultForTemplateDeployment
    enabledForDiskEncryption: enableVaultForDiskEncryption
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enableRbacAuthorization: enableRbacAuthorization
    createMode: createMode
    enablePurgeProtection: enablePurgeProtection ? true : null
    tenantId: subscription().tenantId
    accessPolicies: formattedAccessPolicies
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: !empty(networkAcls)
      ? {
          bypass: networkAcls.?bypass
          defaultAction: networkAcls.?defaultAction
          virtualNetworkRules: networkAcls.?virtualNetworkRules ?? []
          ipRules: networkAcls.?ipRules ?? []
        }
      : null
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? publicNetworkAccess
      : ((!empty(privateEndpoints) && empty(networkAcls)) ? 'Disabled' : null)
  }
}

resource keyVaultLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${keyVaultName}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: keyVault
}

resource keyVaultRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in roleAssignments: {
    name: roleAssignment.?name ?? guid(keyVault.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: keyVault
  }
]

resource keyVaultDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for diagnosticSetting in diagnosticSettings: {
    name: diagnosticSetting.?name ?? '${keyVaultName}-diagnosticSettings'
    scope: keyVault
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
  }
]

module keyVaultAccessPolicies './key_vault_access_policy.bicep' = if (!empty(accessPolicies)) {
  name: '${uniqueString(deployment().name, location)}-kv-access-policies'
  params: {
    keyVaultName: keyVault.name
    accessPolicies: accessPolicies
  }
}

module keyVaultSecrets './key_vault_secret.bicep' = [
  for (secret, index) in secrets: {
    name: '${uniqueString(deployment().name, location)}-kv-secret-${index}'
    params: {
      keyVaultName: keyVault.name
      name: secret.name
      value: secret.value
      contentType: secret.?contentType
      attributesEnabled: secret.?attributes.?enabled ?? true
      attributesExp: secret.?attributes.?exp
      attributesNbf: secret.?attributes.?nbf
      tags: secret.?tags ?? tags
      roleAssignments: secret.?roleAssignments ?? []
    }
  }
]

module keyVaultKeys './key_vault_key.bicep' = [
  for (key, index) in keys: {
    name: '${uniqueString(deployment().name, location)}-kv-key-${index}'
    params: {
      keyVaultName: keyVault.name
      name: key.name
      attributesEnabled: key.?attributes.?enabled ?? true
      attributesExp: key.?attributes.?exp
      attributesNbf: key.?attributes.?nbf
      curveName: (key.?kty != 'RSA' && key.?kty != 'RSA-HSM') ? (key.?curveName ?? 'P-256') : null
      keyOps: key.?keyOps
      keySize: (key.?kty == 'RSA' || key.?kty == 'RSA-HSM') ? (key.?keySize ?? 4096) : null
      kty: key.?kty ?? 'EC'
      releasePolicy: key.?releasePolicy ?? {}
      rotationPolicy: key.?rotationPolicy
      tags: key.?tags ?? tags
      roleAssignments: key.?roleAssignments ?? []
    }
  }
]

resource privateEndpointResources 'Microsoft.Network/privateEndpoints@2023-09-01' = [
  for (privateEndpoint, index) in privateEndpoints: {
    name: privateEndpoint.?name ?? 'pep-${keyVault.name}-${privateEndpoint.?service ?? 'vault'}-${index}'
    location: privateEndpoint.?location ?? location
    tags: privateEndpoint.?tags ?? tags
    properties: {
      subnet: {
        id: privateEndpoint.subnetResourceId
      }
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${keyVault.name}-${privateEndpoint.?service ?? 'vault'}-${index}'
              properties: {
                privateLinkServiceId: keyVault.id
                groupIds: [
                  privateEndpoint.?service ?? 'vault'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${keyVault.name}-${privateEndpoint.?service ?? 'vault'}-${index}'
              properties: {
                privateLinkServiceId: keyVault.id
                groupIds: [
                  privateEndpoint.?service ?? 'vault'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

resource privateDnsZoneGroups 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = [
  for (privateEndpoint, index) in privateEndpoints: if (!empty(privateEndpoint.?privateDnsZoneGroup ?? {})) {
    name: privateEndpoint.privateDnsZoneGroup.?name ?? 'default'
    parent: privateEndpointResources[index]
    properties: {
      privateDnsZoneConfigs: [
        for zone in (privateEndpoint.privateDnsZoneGroup.?privateDnsZoneConfigs ?? []): {
          name: zone.name
          properties: {
            privateDnsZoneId: zone.privateDnsZoneId
          }
        }
      ]
    }
  }
]

@description('ID du Key Vault.')
output resourceId string = keyVault.id

@description('Nom du resource group.')
output resourceGroupName string = resourceGroup().name

@description('Nom du Key Vault.')
output name string = keyVault.name

@description('URI du Key Vault.')
output uri string = keyVault.properties.vaultUri

@description('Région réelle de déploiement.')
output deployedLocation string = keyVault.location

@description('Private endpoints créés.')
output privateEndpointOutputs array = [
  for (item, index) in privateEndpoints: {
    name: privateEndpointResources[index].name
    resourceId: privateEndpointResources[index].id
    customDnsConfigs: privateEndpointResources[index].properties.customDnsConfigs ?? []
  }
]

@description('Secrets créés.')
output secretOutputs array = [
  for index in range(0, length(secrets)): {
    resourceId: keyVaultSecrets[index].outputs.resourceId
    uri: keyVaultSecrets[index].outputs.secretUri
    uriWithVersion: keyVaultSecrets[index].outputs.secretUriWithVersion
  }
]

@description('Clés créées.')
output keyOutputs array = [
  for index in range(0, length(keys)): {
    resourceId: keyVaultKeys[index].outputs.resourceId
    uri: keyVaultKeys[index].outputs.keyUri
    uriWithVersion: keyVaultKeys[index].outputs.keyUriWithVersion
  }
]
