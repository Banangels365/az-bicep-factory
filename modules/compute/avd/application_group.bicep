// workload-lz/modules/avd/application_group.bicep
// Azure Virtual Desktop — Application Group
// Permet de créer un groupe d'applications AVD, qui peut être de type Desktop ou RemoteApp. 
// Le groupe d'applications est associé à un Host Pool existant et peut contenir une liste d'applications à publier (pour les RemoteApp).

targetScope = 'resourceGroup'

@description('Nom du groupe d\'applications AVD.')
@minLength(3)
param name string

@description('Région Azure. Par défaut : région du resource group.')
param location string = resourceGroup().location

@description('Type du groupe d\'applications.')
@allowed([
  'Desktop'
  'RemoteApp'
])
param applicationGroupType string

@description('Nom du Host Pool existant auquel rattacher le groupe.')
param hostPoolName string

@description('Affiche le groupe dans le feed utilisateur.')
param showInFeed bool = true

@description('Nom convivial du groupe d\'applications.')
param friendlyName string = name

@description('Description du groupe d\'applications.')
param applicationGroupDescription string = ''

@description('Liste des applications à publier. Utilisée uniquement si applicationGroupType = RemoteApp.')
param applications array = []

@description('Tags à appliquer à la ressource.')
param tags object = {}

@description('Liste des paramètres de diagnostic à créer sur le groupe.')
param diagnosticSettings array = []

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2025-03-01-preview' existing = {
  name: hostPoolName
}

resource applicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2025-03-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: union(
    {
      applicationGroupType: applicationGroupType
      hostPoolArmPath: hostPool.id
      friendlyName: friendlyName
      showInFeed: showInFeed
    },
    !empty(applicationGroupDescription) ? { description: applicationGroupDescription } : {}
  )
}

module applicationsModules './application.bicep' = [
  for app in applications: if (applicationGroupType == 'RemoteApp') {
    name: 'app-${uniqueString(applicationGroup.id, app.name)}'
    params: {
      applicationGroupName: applicationGroup.name
      name: app.name
      friendlyName: app.?friendlyName ?? app.?displayName ?? app.name
      applicationDescription: app.?description ?? ''
      filePath: app.filePath
      commandLineSetting: app.?commandLineSetting ?? 'DoNotAllow'
      commandLineArguments: app.?commandLineArguments
      showInPortal: app.?showInPortal ?? true
      iconPath: app.?iconPath ?? app.filePath
      iconIndex: app.?iconIndex ?? 0
      applicationType: app.?applicationType ?? 'InBuilt'
      msixPackageApplicationId: app.?msixPackageApplicationId
      msixPackageFamilyName: app.?msixPackageFamilyName
    }
  }
]

resource applicationGroupDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in diagnosticSettings: {
    name: !empty(diagnosticSetting.?name) ? diagnosticSetting.name : '${name}-diag-${index + 1}'
    scope: applicationGroup
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

@description('Resource ID du groupe d\'applications.')
output resourceId string = applicationGroup.id

@description('Nom du groupe d\'applications.')
output applicationGroupName string = applicationGroup.name

@description('Région du groupe d\'applications.')
output locationOut string = applicationGroup.location

@description('Type du groupe d\'applications.')
output applicationGroupTypeOut string = applicationGroup.properties.applicationGroupType

@description('Indique si le groupe est affiché dans le feed.')
output showInFeedOut bool = applicationGroup.properties.showInFeed

@description('Liste des noms des applications créées via le module enfant.')
var remoteAppNames = [for app in applications: app.name]
output applicationNames array = applicationGroupType == 'RemoteApp' ? remoteAppNames : []
