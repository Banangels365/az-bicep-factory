// modules/compute/avd/application.bicep
// Azure Virtual Desktop — Application
// Permet de créer une application RemoteApp dans un groupe d'applications AVD existant.

targetScope = 'resourceGroup'

@description('Nom du groupe d\'applications parent.')
param applicationGroupName string

@description('Nom de l\'application RemoteApp.')
param name string

@description('Nom convivial de l\'application RemoteApp.')
param friendlyName string

@description('Description de l\'application RemoteApp.')
param applicationDescription string = ''

@description('Chemin de l\'exécutable publié.')
param filePath string

@description('Politique des arguments de ligne de commande.')
@allowed([
  'Allow'
  'DoNotAllow'
  'Require'
])
param commandLineSetting string = 'DoNotAllow'

@description('Arguments de ligne de commande.')
param commandLineArguments string = ''

@description('Affiche l\'application dans le portail / feed.')
param showInPortal bool = true

@description('Chemin de l\'icône.')
param iconPath string = ''

@description('Index de l\'icône.')
param iconIndex int = 0

@description('Type d\'application.')
@allowed([
  'InBuilt'
  'MsixApplication'
])
param applicationType string = 'InBuilt'

@description('Application ID MSIX.')
param msixPackageApplicationId string = ''

@description('Package family name MSIX.')
param msixPackageFamilyName string = ''

// Création des ressources
resource applicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2025-03-01-preview' existing = {
  name: applicationGroupName
}

resource application 'Microsoft.DesktopVirtualization/applicationGroups/applications@2025-03-01-preview' = {
  parent: applicationGroup
  name: name
  properties: union(
    {
      friendlyName: friendlyName
      filePath: filePath
      commandLineSetting: commandLineSetting
      showInPortal: showInPortal
      iconIndex: iconIndex
      applicationType: applicationType
    },
    !empty(applicationDescription) ? { description: applicationDescription } : {},
    !empty(commandLineArguments) ? { commandLineArguments: commandLineArguments } : {},
    !empty(iconPath) ? { iconPath: iconPath } : {},
    !empty(msixPackageApplicationId) ? { msixPackageApplicationId: msixPackageApplicationId } : {},
    !empty(msixPackageFamilyName) ? { msixPackageFamilyName: msixPackageFamilyName } : {}
  )
}

// Outputs
@description('Resource ID de l\'application.')
output resourceId string = application.id

@description('Nom de l\'application.')
output applicationName string = application.name

@description('Nom du groupe d\'applications parent.')
output applicationGroupNameOut string = applicationGroup.name
