// landing-zone/workload-lz/demo-avd-01/main.bicep
// Déploiement d'une infrastructure Azure Virtual Desktop complète avec un Host Pool, deux groupes d'applications (Desktop et RemoteApp), un Workspace et un Scaling Plan.
// Ce déploiement inclut également des paramètres pour les diagnostics et la configuration du Private Endpoint du Workspace.

targetScope = 'resourceGroup'

@description('Région Azure de déploiement.')
param location string = resourceGroup().location

@description('Préfixe de nommage des ressources AVD.')
param namePrefix string = 'avd-sbox'

@description('Tags communs.')
param tags object = {
  environnement: 'sbox'
  workload: 'avd'
  managedBy: 'bicep'
}

@description('Description commune des ressources AVD.')
param avdResourceDescription string = 'Azure Virtual Desktop workload'

@description('ID du Log Analytics Workspace pour les diagnostics.')
param logAnalyticsWorkspaceId string = ''

@description('Active les diagnostics sur les ressources compatibles.')
param enableDiagnostics bool = true

@description('Active le Private Endpoint sur le Workspace.')
param enableWorkspacePrivateEndpoint bool = false

@description('ID du subnet pour le Private Endpoint du Workspace.')
param privateEndpointSubnetId string = ''

@description('ID de la Private DNS Zone du Workspace AVD.')
param privateDnsZoneIdWorkspace string = ''

@description('Nom du Host Pool.')
param hostPoolName string = '${namePrefix}-hp'

@description('Nom du Desktop Application Group.')
param desktopApplicationGroupName string = '${namePrefix}-dag'

@description('Nom du RemoteApp Application Group.')
param remoteApplicationGroupName string = '${namePrefix}-rag'

@description('Nom du Workspace.')
param workspaceName string = '${namePrefix}-ws'

@description('Nom du Scaling Plan.')
param scalingPlanName string = '${namePrefix}-sp'

@description('Applications publiées dans le RemoteApp Application Group.')
param remoteApplications array = [
  {
    name: 'notepad'
    friendlyName: 'Notepad'
    description: 'Bloc-notes'
    filePath: 'C:\\Windows\\System32\\notepad.exe'
    commandLineSetting: 'DoNotAllow'
    showInPortal: true
    iconPath: 'C:\\Windows\\System32\\notepad.exe'
    iconIndex: 0
    applicationType: 'InBuilt'
  }
  {
    name: 'calc'
    friendlyName: 'Calculator'
    description: 'Calculatrice'
    filePath: 'C:\\Windows\\System32\\calc.exe'
    commandLineSetting: 'DoNotAllow'
    showInPortal: true
    iconPath: 'C:\\Windows\\System32\\calc.exe'
    iconIndex: 0
    applicationType: 'InBuilt'
  }
]

var diagnosticSettings = enableDiagnostics && !empty(logAnalyticsWorkspaceId)
  ? [
      {
        name: 'to-law'
        workspaceResourceId: logAnalyticsWorkspaceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
            enabled: true
          }
        ]
      }
    ]
  : []

module hostPool '../../../modules/compute/avd/host_pool.bicep' = {
  name: 'hostPoolDeployment'
  params: {
    name: hostPoolName
    location: location
    friendlyName: hostPoolName
    hostPoolDescription: avdResourceDescription
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    maxSessionLimit: 10
    preferredAppGroupType: 'Desktop'
    startVMOnConnect: true
    validationEnvironment: false
    managementType: 'Standard'
    tokenValidityLength: 'PT24H'
    publicNetworkAccess: 'Enabled'
    customRdpProperty: 'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:0;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'
    tags: tags
    diagnosticSettings: diagnosticSettings
  }
}

module desktopApplicationGroup '../../../modules/compute/avd/application_group.bicep' = {
  name: 'desktopApplicationGroupDeployment'
  params: {
    name: desktopApplicationGroupName
    location: location
    applicationGroupType: 'Desktop'
    hostPoolName: hostPool.outputs.hostPoolName
    showInFeed: true
    friendlyName: desktopApplicationGroupName
    applicationGroupDescription: 'Desktop Application Group for ${hostPoolName}'
    applications: []
    tags: tags
    diagnosticSettings: diagnosticSettings
  }
}

module remoteApplicationGroup '../../../modules/compute/avd/application_group.bicep' = {
  name: 'remoteApplicationGroupDeployment'
  params: {
    name: remoteApplicationGroupName
    location: location
    applicationGroupType: 'RemoteApp'
    hostPoolName: hostPool.outputs.hostPoolName
    showInFeed: true
    friendlyName: remoteApplicationGroupName
    applicationGroupDescription: 'RemoteApp Application Group for ${hostPoolName}'
    applications: remoteApplications
    tags: tags
    diagnosticSettings: diagnosticSettings
  }
}

module workspace '../../../modules/compute/avd/workspace.bicep' = {
  name: 'workspaceDeployment'
  params: {
    name: workspaceName
    location: location
    applicationGroupReferences: [
      desktopApplicationGroup.outputs.resourceId
      remoteApplicationGroup.outputs.resourceId
    ]
    workspaceDescription: avdResourceDescription
    friendlyName: workspaceName
    publicNetworkAccess: enableWorkspacePrivateEndpoint ? 'Disabled' : 'Enabled'
    enablePrivateEndpoint: enableWorkspacePrivateEndpoint
    privateEndpointSubnetId: privateEndpointSubnetId
    privateDnsZoneIdWorkspace: privateDnsZoneIdWorkspace
    privateEndpointGroupId: 'feed'
    tags: tags
    diagnosticSettings: diagnosticSettings
  }
}

module scalingPlan '../../../modules/compute/avd/scaling_plan.bicep' = {
  name: 'scalingPlanDeployment'
  params: {
    name: scalingPlanName
    location: location
    friendlyName: scalingPlanName
    scalingPlanDescription: avdResourceDescription
    timeZone: 'Eastern Standard Time'
    hostPoolType: 'Pooled'
    exclusionTag: 'ScalingPlanExclusion'
    hostPoolReferences: [
      {
        hostPoolResourceId: hostPool.outputs.resourceId
        scalingPlanEnabled: true
      }
    ]
    tags: tags
    diagnosticSettings: diagnosticSettings
  }
}

@description('Resource ID du Host Pool.')
output hostPoolResourceId string = hostPool.outputs.resourceId

@description('Nom du Host Pool.')
output hostPoolOutputName string = hostPool.outputs.hostPoolName

@description('Token d\'enregistrement du Host Pool.')
@secure()
output hostPoolRegistrationToken string = hostPool.outputs.registrationToken

@description('Resource ID du Desktop Application Group.')
output desktopApplicationGroupResourceId string = desktopApplicationGroup.outputs.resourceId

@description('Resource ID du RemoteApp Application Group.')
output remoteApplicationGroupResourceId string = remoteApplicationGroup.outputs.resourceId

@description('Applications publiées dans le RemoteApp Application Group.')
output remoteApplicationNames array = remoteApplicationGroup.outputs.applicationNames

@description('Resource ID du Workspace.')
output workspaceResourceId string = workspace.outputs.resourceId

@description('Resource ID du Scaling Plan.')
output scalingPlanResourceId string = scalingPlan.outputs.resourceId
