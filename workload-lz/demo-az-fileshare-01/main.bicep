// workloads/application-1/main.bicep
// Demo project: Application avec Storage Account et Key Vault sécurisés par Private Endpoint

targetScope = 'subscription'

@description('Nom du Workload')
param workloadName string = 'myapp'

@description('Environnement')
@allowed([
  'prod' // production
  'dev' // développement
  'logs' // logging/monitoring
  'quar' // quarantine
  'sbox' // sandbox
])
param environment string

@description('Région de déploiement')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('Préfixe d\'adresse du workload VNet')
param workloadVnetAddressPrefix string = '10.1.0.0/16'

@description('Préfixe d\'adresse du subnet du workload (doit être un sous-réseau du préfixe du VNet)')
param workloadSubnetAddressPrefix string = '10.1.1.0/24'

@description('ID de la subscription du hub VNet pour le peering')
param hubSubscriptionId string

@description('ID du VNet hub pour le peering')
param hubVnetId string

@description('Nom du VNet hub (extrait de hubVnetId si non fourni)')
param hubVnetName string = last(split(hubVnetId, '/'))

@description('Resource Group du hub VNet pour le peering')
param hubVnetResourceGroup string

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string

@description('ID de la zone DNS privée pour les endpoints blob (obligatoire si enablePrivateEndpoint est true)')
param privateDnsZoneIdBlob string

@description('IDs des groupes Azure AD pour les accès workload')
param workloadGroupIds object = {
  workloadAdmins: '00000000-0000-0000-0000-000000000000' // à remplacer par l'ID du groupe Azure AD des admins du workload
  workloadContributors: '00000000-0000-0000-0000-000000000000' // à remplacer par l'ID du groupe Azure AD des contributeurs du workload
  workloadReaders: '00000000-0000-0000-0000-000000000000' // à remplacer par l'ID du groupe Azure AD des lecteurs du workload
}

@description('Tags à appliquer à toutes les ressources du workload')
param tags object = {
  Application: workloadName
  Environnement: environment
  CreeLe: '2024-05-18'
  CreePar: 'CloudOps-Team'
  Criticite: 'Moyen'
  Responsable: 'CloudOps-Team'
  ResponsableEmail: 'cloudops@acmy.com'
  ManagedBy: 'Bicep'
}

// =================================
// VARIABLES GLOBALES
// =================================
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

var workloadResourceGroupName = 'rg-${environment}-${location}-${workloadName}'
var workloadVnetName = 'vnet-${environment}-${location}-${workloadName}'
var workloadSubnetName = 'snet-${environment}-${location}-${workloadName}'
var nsgWorkloadName = 'nsg-${environment}-${location}-${workloadName}'
var nsgPeSubnetName = 'nsg-pe-${environment}-${location}-${workloadName}'
var keyVaultName = 'kv-${environment}-${location}-${workloadName}'
var storageAccountName = toLower(replace('st${workloadName}${environment}${uniqueString(subscription().id)}', '-', ''))

// ==================================
// CREATION DU GROUPE DE RESSOURCES
// ==================================

module workloadResourceGroup '../../platform-lz/modules/resource_group.bicep' = {
  name: 'deploy-spoke-rg'
  scope: subscription(hubSubscriptionId) // scope de la subscription cible
  params: {
    resourceGroupName: workloadResourceGroupName
    location: location
    tags: tags
  }
}

// ==================================
// GESTION DES ACCÈS RBAC
// ==================================

module workloadAdmins '../../identity-lz/modules/rbac_assignment.bicep' = {
  scope: resourceGroup(workloadResourceGroupName) // scope du resource group du workload
  name: 'rbac-workload-admins'
  params: {
    principalId: workloadGroupIds.workloadAdmins
    roleDefinitionIdOrName: 'Owner'
    principalType: 'Group'
    roleAssignmentDescription: 'Workload Admins - Owner on Workload resource group'
  }
}

// Workload Contributors - Contributor on Workload Subscription
module workloadContributors '../../identity-lz/modules/rbac_assignment.bicep' = {
  scope: resourceGroup(workloadResourceGroupName) // scope du resource group du workload
  name: 'rbac-workload-contributors'
  params: {
    principalId: workloadGroupIds.workloadContributors
    roleDefinitionIdOrName: 'Contributor'
    principalType: 'Group'
    roleAssignmentDescription: 'Workload Contributors - Contributor on Workload resource group'
  }
}

// Workload Readers - Reader on Workload Subscription
module workloadReaders '../../identity-lz/modules/rbac_assignment.bicep' = {
  scope: resourceGroup(workloadResourceGroupName) // scope du resource group du workload
  name: 'rbac-workload-readers'
  params: {
    principalId: workloadGroupIds.workloadReaders
    roleDefinitionIdOrName: 'Reader'
    principalType: 'Group'
    roleAssignmentDescription: 'Workload Readers - Reader on Workload resource group'
  }
}

// ==================================
// NETWORK SECURITY GROUP + NSG RULES
// ==================================

// NSG pour le subnet du workload (Application Tier) - règles d'exemple à adapter selon les besoins de l'application
module nsgWorkload '../../connectivity-lz/modules/network_security_group.bicep' = {
  scope: resourceGroup(workloadResourceGroupName)
  name: 'deploy-nsg-${workloadName}'
  params: {
    nsgName: nsgWorkloadName
    location: resolvedLocation
    securityRules: [
      {
        name: 'AllowWebTierInbound'
        description: 'Allow traffic from Web tier'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: workloadSubnetAddressPrefix
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 100
        direction: 'Inbound'
      }
      {
        name: 'DenyAllInbound'
        description: 'Deny all other inbound traffic'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
        access: 'Deny'
        priority: 4096
        direction: 'Inbound'
      }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    enableFlowLogs: true
    tags: tags
  }
}

// NSG pour le subnet du Private Endpoint - règles très restrictives car c'est un subnet dédié aux endpoints privés
module nsgPe '../../connectivity-lz/modules/network_security_group.bicep' = {
  scope: resourceGroup(workloadResourceGroupName)
  name: 'deploy-nsg-${workloadName}-pe'
  params: {
    nsgName: nsgPeSubnetName
    location: resolvedLocation
    securityRules: [
      {
        name: 'AllowVnetInbound'
        description: 'Allow traffic from VNet'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: 'VirtualNetwork'
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 100
        direction: 'Inbound'
      }
      {
        name: 'DenyAllInbound'
        description: 'Deny all other inbound traffic'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'
        access: 'Deny'
        priority: 4096
        direction: 'Inbound'
      }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
}

// =====================================
// RESEAU VIRTUEL + PEERING AVEC LE HUB
// =====================================

module workloadVnet '../../connectivity-lz/modules/virtual_network.bicep' = {
  scope: resourceGroup(workloadResourceGroupName) // scope du resource group du workload
  name: '${workloadName}-vnet-deployment'
  params: {
    vnetName: workloadVnetName
    location: location
    addressPrefixes: [workloadVnetAddressPrefix]
    subnets: [
      {
        name: workloadSubnetName
        addressPrefix: workloadSubnetAddressPrefix
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.KeyVault'
          }
        ]
      }
    ]
    tags: tags
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
}

// Peering Spoke → Hub
module peeringSpokeToHub '../../connectivity-lz/modules/virtual_network_peering.bicep' = {
  scope: resourceGroup(workloadResourceGroupName) // scope du spoke (courant)
  name: 'peering-${workloadName}-${workloadVnetName}-to-${hubVnetName}'
  params: {
    localVnetName: workloadVnetName
    remoteVnetId: hubVnetId
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
  }
  dependsOn: [
    workloadVnet
  ]
}

// Peering Hub → Spoke (cross-RG / cross-subscription)
module peeringHubToSpoke '../../connectivity-lz/modules/virtual_network_peering.bicep' = {
  scope: resourceGroup(hubVnetResourceGroup) // scope du hub
  name: 'peering-${hubVnetName}-to-${workloadName}-${workloadVnetName}'
  params: {
    localVnetName: last(split(hubVnetId, '/'))
    remoteVnetId: workloadVnet.outputs.vnetId
    allowForwardedTraffic: true
    allowGatewayTransit: true // offre la gateway aux spokes
    useRemoteGateways: false
  }
}

// ====================================================
// COMPTE DE STOCKAGE + PRIVATE ENDPOINT + DIAGNOSTICS
// ====================================================

module storageAccount '../modules/storage_account.bicep' = {
  scope: resourceGroup(workloadResourceGroupName)
  name: '${workloadName}-storage-deployment'
  params: {
    storageAccountName: storageAccountName
    location: location
    skuName: environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    requireInfrastructureEncryption: true
    networkAclsDefaultAction: 'Deny'
    subnetIds: [
      '${workloadVnet.outputs.vnetId}/subnets/snet-${environment}-${location}-${workloadName}'
    ]
    enableBlobSoftDelete: true
    blobSoftDeleteRetentionDays: environment == 'prod' ? 30 : 7
    enableContainerSoftDelete: true
    containerSoftDeleteRetentionDays: environment == 'prod' ? 30 : 7
    enableVersioning: environment == 'prod'
    enablePrivateEndpoint: true
    privateEndpointSubnetId: '${workloadVnet.outputs.vnetId}/subnets/snet-${environment}-${location}-${workloadName}'
    privateDnsZoneIdBlob: privateDnsZoneIdBlob
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics: true
    tags: tags
  }
}

// ============================================
// KEY VAULT + PRIVATE ENDPOINT + DIAGNOSTICS
// ============================================

module keyVault '../modules/key_vault.bicep' = {
  scope: resourceGroup(workloadResourceGroupName)
  name: '${workloadName}-keyvault-deployment'
  params: {
    keyVaultName: keyVaultName
    location: location
    skuName: environment == 'prod' ? 'premium' : 'standard'
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enablePurgeProtection: environment == 'prod'
    networkAclsDefaultAction: 'Deny'
    subnetIds: [
      '${workloadVnet.outputs.vnetId}/subnets/snet-${environment}-${location}-${workloadName}'
    ]
    enablePrivateEndpoint: true
    privateEndpointSubnetId: '${workloadVnet.outputs.vnetId}/subnets/snet-data-${environment}-${location}-${workloadName}'
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    tags: tags
  }
}

// ==================================
// OUTPUTS
// ==================================
@description('ID du VNet pour le workload')
output workloadVnetId string = workloadVnet.outputs.vnetId

@description('Nom du VNet pour le workload')
output workloadVnetName string = workloadVnet.outputs.vnetName

@description('Préfixe d\'adresse du VNet pour le workload')
output workloadVnetAddressPrefix string = workloadVnetAddressPrefix

@description('IDs des subnets créés')
output workloadSubnetId string = '${workloadVnet.outputs.vnetId}/subnets/${workloadSubnetName}'

@description('ID du peering Spoke → Hub')
output peeringSpokeToHubId string = peeringSpokeToHub.outputs.peeringId

@description('État du peering Spoke → Hub')
output peeringState string = peeringSpokeToHub.outputs.peeringState

@description('Nom du Resource Group du workload')
output resourceGroupName string = workloadResourceGroup.outputs.resourceGroupName

@description('ID du Storage Account')
output storageAccountId string = storageAccount.outputs.storageAccountId

@description('Nom du Storage Account')
output storageAccountName string = storageAccount.outputs.storageAccountName

@description('ID du Key Vault')
output keyVaultId string = keyVault.outputs.keyVaultId
