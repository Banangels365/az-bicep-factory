// workload-lz/modules/vm/virtual_machine_extension.bicep
// Ce module déploie une extension sur une machine virtuelle existante.

targetScope = 'resourceGroup'

@description('Nom de la machine virtuelle parente.')
param virtualMachineName string

@description('Nom de l\'extension.')
param name string

@description('Localisation de l\'extension.')
param location string = resourceGroup().location

@description('Nom du publisher de l\'extension.')
param publisher string

@description('Type de l\'extension.')
param type string

@description('Version du handler.')
param typeHandlerVersion string

@description('Active l\'upgrade mineur automatique.')
param autoUpgradeMinorVersion bool

@description('Force une mise à jour même si la configuration n\'a pas changé.')
param forceUpdateTag string?

@description('Paramètres publics de l\'extension.')
param settings object?

@description('Paramètres protégés de l\'extension.')
@secure()
param protectedSettings object?

@description('Supprime les erreurs de provisioning remontées par l\'extension.')
param supressFailures bool = false

@description('Active l\'upgrade automatique de l\'extension par la plateforme.')
param enableAutomaticUpgrade bool

@description('Tags à appliquer à l\'extension.')
param tags object?

@description('Protected settings récupérés depuis Key Vault.')
param protectedSettingsFromKeyVault object?

@description('Liste d\'extensions devant être provisionnées avant celle-ci.')
param provisionAfterExtensions array?

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-11-01' existing = {
  name: virtualMachineName
}

resource extension 'Microsoft.Compute/virtualMachines/extensions@2024-11-01' = {
  name: name
  parent: virtualMachine
  location: location
  tags: tags
  properties: {
    publisher: publisher
    type: type
    typeHandlerVersion: typeHandlerVersion
    autoUpgradeMinorVersion: autoUpgradeMinorVersion
    enableAutomaticUpgrade: enableAutomaticUpgrade
    forceUpdateTag: forceUpdateTag
    settings: settings
    protectedSettings: protectedSettings
    suppressFailures: supressFailures
    protectedSettingsFromKeyVault: protectedSettingsFromKeyVault
    provisionAfterExtensions: provisionAfterExtensions
  }
}

@description('Nom de l\'extension.')
output name string = extension.name

@description('ID de l\'extension.')
output resourceId string = extension.id

@description('Nom du Resource Group.')
output resourceGroupName string = resourceGroup().name

@description('Région de déploiement.')
output location string = extension.location
