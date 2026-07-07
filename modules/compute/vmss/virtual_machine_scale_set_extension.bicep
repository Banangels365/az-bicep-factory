// modules/compute/vmss/virtual_machine_scale_set_extension.bicep
// Déploie une extension sur un Virtual Machine Scale Set existant.

targetScope = 'resourceGroup'

@description('Nom du Virtual Machine Scale Set parent.')
param virtualMachineScaleSetName string

@description('Nom de l\'extension.')
param name string

@description('Éditeur de l\'extension.')
param publisher string

@description('Type de l\'extension, par exemple CustomScriptExtension.')
param type string

@description('Version du handler d\'extension.')
param typeHandlerVersion string

@description('Indique si une version mineure plus récente peut être utilisée au déploiement.')
param autoUpgradeMinorVersion bool = true

@description('Tag permettant de forcer la réexécution de l\'extension même sans changement de configuration.')
param forceUpdateTag string = ''

@description('Paramètres non sensibles de l\'extension.')
param settings object = {}

@description('Paramètres sensibles de l\'extension.')
@secure()
param protectedSettings object = {}

@description('Indique si les erreurs internes de l\'extension doivent être supprimées.')
param supressFailures bool = false

@description('Indique si l\'extension peut être automatiquement mise à jour par la plateforme.')
param enableAutomaticUpgrade bool = false

@description('Référence Key Vault pour les protectedSettings, si utilisée.')
param protectedSettingsFromKeyVault object = {}

@description('Liste des extensions devant être provisionnées avant celle-ci.')
param provisionAfterExtensions array = []

resource virtualMachineScaleSet 'Microsoft.Compute/virtualMachineScaleSets@2024-11-01' existing = {
  name: virtualMachineScaleSetName
}

resource extension 'Microsoft.Compute/virtualMachineScaleSets/extensions@2024-11-01' = {
  name: name
  parent: virtualMachineScaleSet
  properties: {
    publisher: publisher
    type: type
    typeHandlerVersion: typeHandlerVersion
    autoUpgradeMinorVersion: autoUpgradeMinorVersion
    enableAutomaticUpgrade: enableAutomaticUpgrade
    forceUpdateTag: !empty(forceUpdateTag) ? forceUpdateTag : null
    settings: !empty(settings) ? settings : null
    protectedSettings: !empty(protectedSettings) ? protectedSettings : null
    suppressFailures: supressFailures
    protectedSettingsFromKeyVault: !empty(protectedSettingsFromKeyVault) ? protectedSettingsFromKeyVault : null
    provisionAfterExtensions: !empty(provisionAfterExtensions) ? provisionAfterExtensions : null
  }
}

@description('Nom de l\'extension créée.')
output name string = extension.name

@description('ID de ressource de l\'extension créée.')
output resourceId string = extension.id

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name
