// workload-lz/modules/avd/workspace.bicep
// Azure Virtual Desktop — Workspace
// Point d'entrée pour les utilisateurs finaux — agrège les Application Groups.
// Le Workspace est ce que les utilisateurs voient dans le client AVD (Windows App).

targetScope = 'resourceGroup'

@description('Nom du Workspace AVD.')
param name string

@description('Région Azure du Workspace. Par défaut : région du resource group.')
param location string = resourceGroup().location

@description('Liste des IDs des Application Groups à associer au Workspace.')
param applicationGroupReferences array = []

@description('Description du Workspace.')
param workspaceDescription string = ''

@description('Nom convivial du Workspace.')
param friendlyName string = name

@description('Contrôle l\'accès réseau public au Workspace.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Active la création d\'un Private Endpoint pour le flux feed du Workspace.')
param enablePrivateEndpoint bool = false

@description('ID du sous-réseau du Private Endpoint.')
param privateEndpointSubnetId string = ''

@description('ID de la zone DNS privée à associer au Private Endpoint du Workspace.')
param privateDnsZoneIdWorkspace string = ''

@description('Nom du groupId Private Link du Workspace. Par défaut : feed.')
@allowed([
  'feed'
  'global'
])
param privateEndpointGroupId string = 'feed'

@description('Nom de la connexion Private Link. Par défaut : généré à partir du nom du Workspace.')
param privateLinkServiceConnectionName string = ''

@description('Tags à appliquer à la ressource.')
param tags object = {}

@description('Liste des paramètres de diagnostic à créer sur le Workspace.')
param diagnosticSettings array = []

var deployPrivateEndpoint = enablePrivateEndpoint && !empty(privateEndpointSubnetId) && !empty(privateDnsZoneIdWorkspace)
var resolvedPrivateLinkServiceConnectionName = !empty(privateLinkServiceConnectionName)
  ? privateLinkServiceConnectionName
  : '${name}-pe-connection'

resource workspace 'Microsoft.DesktopVirtualization/workspaces@2025-10-10' = {
  name: name
  location: location
  tags: tags
  properties: union(
    {
      applicationGroupReferences: applicationGroupReferences
      friendlyName: friendlyName
      publicNetworkAccess: publicNetworkAccess
    },
    !empty(workspaceDescription) ? { description: workspaceDescription } : {}
  )
}

resource workspacePrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = if (deployPrivateEndpoint) {
  name: '${name}-pe'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: resolvedPrivateLinkServiceConnectionName
        properties: {
          privateLinkServiceId: workspace.id
          groupIds: [
            privateEndpointGroupId
          ]
        }
      }
    ]
  }
}

resource workspacePrivateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = if (deployPrivateEndpoint) {
  parent: workspacePrivateEndpoint
  name: 'workspace-dns-zone-group'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'workspace-config'
        properties: {
          privateDnsZoneId: privateDnsZoneIdWorkspace
        }
      }
    ]
  }
}

resource workspaceDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in diagnosticSettings: {
    name: !empty(diagnosticSetting.?name) ? diagnosticSetting.name : '${name}-diag-${index + 1}'
    scope: workspace
    properties: {
      workspaceId: diagnosticSetting.?workspaceResourceId
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
      logs: [
        for logItem in (empty(diagnosticSetting.?logCategoriesAndGroups)
          ? [
              {
                categoryGroup: 'allLogs'
                enabled: true
              }
            ]
          : diagnosticSetting.logCategoriesAndGroups): {
          category: logItem.?category
          categoryGroup: logItem.?categoryGroup
          enabled: logItem.?enabled ?? true
        }
      ]
    }
  }
]

@description('Resource ID du Workspace.')
output resourceId string = workspace.id

@description('Nom du Workspace.')
output workspaceName string = workspace.name

@description('Région du Workspace.')
output workspaceLocation string = workspace.location

@description('IDs des Application Groups associés au Workspace.')
output workspaceApplicationGroupReferences array = applicationGroupReferences

@description('Mode d\'accès réseau public du Workspace.')
output workspacePublicNetworkAccess string = workspace.properties.publicNetworkAccess

@description('ID du Private Endpoint du Workspace.')
output privateEndpointId string = deployPrivateEndpoint ? workspacePrivateEndpoint.id : ''

@description('Sous-ressource Private Link utilisée.')
output privateEndpointGroupIdOut string = deployPrivateEndpoint ? privateEndpointGroupId : ''
