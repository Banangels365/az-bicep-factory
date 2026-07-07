// modules/compute/vmss/virtual_machine_scale_set.bicep
// Déploie un Virtual Machine Scale Set Azure avec un sous-module générique pour les extensions.

targetScope = 'resourceGroup'

@description('Nom du Virtual Machine Scale Set.')
param name string

@description('Région de déploiement. Par défaut, la région du resource group.')
param location string = resourceGroup().location

@description('Type de système d\'exploitation des instances.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Nom de la taille de machine virtuelle du scale set, par exemple Standard_D4s_v5.')
param skuName string

@description('Nombre initial d\'instances dans le scale set.')
param skuCapacity int = 1

@description('Mode d\'orchestration du scale set.')
@allowed([
  'Flexible'
  'Uniform'
])
param orchestrationMode string = 'Flexible'

@description('Référence d\'image à utiliser. Pour une image marketplace : publisher/offer/sku/version. Pour une image custom : id.')
param imageReference object

@description('Informations de plan marketplace si l\'image choisie en nécessite un.')
param plan object = {}

@description('Nom d\'utilisateur administrateur des VM.')
param adminUsername string

@description('Mot de passe administrateur. Requis pour Windows et optionnel pour Linux si authentification par clé publique.')
@secure()
param adminPassword string = ''

@description('Données customData injectées dans la VMSS. Le contenu est automatiquement encodé en base64.')
param customData string = ''

@description('Configuration du disque OS.')
param osDisk object

@description('Liste des disques de données à attacher aux instances.')
param dataDisks array = []

@description('Indique si le chiffrement au niveau de l\'hôte doit être activé.')
param encryptionAtHost bool = true

@description('Type de sécurité de la VMSS. Utiliser TrustedLaunch pour activer les réglages UEFI.')
param securityType string = ''

@description('Active Secure Boot lorsque securityType vaut TrustedLaunch.')
param secureBootEnabled bool = false

@description('Active vTPM lorsque securityType vaut TrustedLaunch.')
param vTpmEnabled bool = false

@description('Préfixe du nom des instances du scale set.')
@minLength(1)
@maxLength(15)
param vmNamePrefix string = 'vmssvm'

@description('Indique si le VM Agent doit être provisionné sur les instances.')
param provisionVMAgent bool = true

@description('Active les mises à jour automatiques Windows. Valable pour les VM Windows.')
param enableAutomaticUpdates bool = true

@description('Mode de patch des invités. AutomaticByPlatform, AutomaticByOS et Manual sont adaptés à Windows. ImageDefault est recommandé pour Linux.')
@allowed([
  'AutomaticByPlatform'
  'AutomaticByOS'
  'Manual'
  'ImageDefault'
])
param patchMode string = 'AutomaticByPlatform'

@description('Mode d\'évaluation des patchs invités.')
@allowed([
  'AutomaticByPlatform'
  'ImageDefault'
])
param patchAssessmentMode string = 'ImageDefault'

@description('Permet de contourner certains garde-fous plateforme lors des patchs planifiés par l\'utilisateur.')
param bypassPlatformSafetyChecksOnUserSchedule bool = true

@description('Comportement de redémarrage lors des opérations de patching AutomaticByPlatform.')
@allowed([
  'Always'
  'IfRequired'
  'Never'
  'Unknown'
])
param rebootSetting string = 'IfRequired'

@description('Active ou désactive l\'authentification par mot de passe sur Linux.')
param disablePasswordAuthentication bool = false

@description('Liste des clés publiques SSH à injecter pour Linux.')
param publicKeys array = []

@description('Secrets à injecter dans le profil OS, par exemple des certificats Windows.')
param secrets array = []

@description('Configuration Windows spécifique, comme timeZone, winRM ou additionalUnattendContent.')
param windowsConfiguration object = {}

@description('Configuration Linux spécifique complémentaire. Réservé aux besoins avancés.')
param linuxConfiguration object = {}

@description('Configurations réseau du scale set. Le premier élément est considéré comme la carte primaire.')
param nicConfigurations array

@description('Active la capacité Ultra SSD pour les disques gérés si nécessaire.')
param ultraSSDEnabled bool = false

@description('Politique de montée de version du scale set.')
@allowed([
  'Manual'
  'Automatic'
  'Rolling'
])
param upgradePolicyMode string = 'Manual'

@description('Autorise l\'upgrade cross-zone lors des rolling upgrades.')
param enableCrossZoneUpgrade bool = false

@description('Crée de nouvelles VM lors des upgrades Rolling avant suppression des anciennes.')
param maxSurge bool = false

@description('Pourcentage maximum d\'instances dans un batch Rolling.')
param maxBatchInstancePercent int = 20

@description('Pourcentage maximum d\'instances globalement malsaines autorisé pendant un Rolling upgrade.')
param maxUnhealthyInstancePercent int = 20

@description('Pourcentage maximum d\'instances upgradées malsaines autorisé pendant un Rolling upgrade.')
param maxUnhealthyUpgradedInstancePercent int = 20

@description('Temps d\'attente entre les batches de rolling upgrade au format ISO 8601.')
param pauseTimeBetweenBatches string = 'PT0S'

@description('Priorise la mise à jour des instances non saines avant les instances saines.')
param prioritizeUnhealthyInstances bool = false

@description('Restaure les instances à l\'état précédent en cas de violation de stratégie lors d\'un Rolling upgrade.')
param rollbackFailedInstancesOnPolicyBreach bool = false

@description('Active les réparations automatiques des instances.')
param automaticRepairsPolicyEnabled bool = true

@description('Période de grâce avant réparation automatique, au format ISO 8601.')
param gracePeriod string = 'PT30M'

@description('Active le sur-provisionnement des instances. Principalement utile en mode Uniform.')
param overprovision bool = false

@description('Empêche l\'exécution des extensions sur les VM créées uniquement pour le sur-provisionnement.')
param doNotRunExtensionsOnOverprovisionedVMs bool = false

@description('Force un équilibrage des instances entre zones.')
param zoneBalance bool = false

@description('Nombre de fault domains par placement group.')
param scaleSetFaultDomain int = 1

@description('Limite le scale set à un seul placement group. Principalement utile en mode Uniform.')
param singlePlacementGroup bool = false

@description('Politique de scale-in.')
param scaleInPolicy object = {
  rules: [
    'Default'
  ]
}

@description('Zones de disponibilité à utiliser.')
param availabilityZones array = [
  1
  2
  3
]

@description('ID de resource group proximity placement group à associer au scale set.')
param proximityPlacementGroupResourceId string = ''

@description('Priorité des VM.')
@allowed([
  'Regular'
  'Low'
  'Spot'
])
param vmPriority string = 'Regular'

@description('Active la policy d\'éviction Deallocate pour les VM Spot / Low Priority.')
param enableEvictionPolicy bool = false

@description('Prix maximum en USD pour les VM Spot. Laisser vide pour utiliser le prix courant.')
param maxPriceForLowPriorityVm int = 0

@description('Type de licence, par exemple WindowsServer ou WindowsClient.')
param licenseType string = ''

@description('Profil Scheduled Events à appliquer.')
param scheduledEventsProfile object = {}

@description('Active les diagnostics de démarrage.')
param bootDiagnosticEnabled bool = false

@description('Nom du compte de stockage à utiliser pour les boot diagnostics. Si vide, le mode managé est utilisé.')
param bootDiagnosticStorageAccountName string = ''

@description('Suffixe URI blob du compte de stockage de boot diagnostics.')
param bootDiagnosticStorageAccountUri string = '.blob.${environment().suffixes.storage}'

@description('Définition des identités managées à associer à la VMSS.')
param managedIdentities object = {}

@description('Liste des extensions VMSS à créer après la ressource principale.')
param extensions array = []

@description('Configuration de la sonde de santé applicative VMSS. Mettre enabled à true pour activer l\'extension.')
param extensionHealthConfig object = {
  enabled: true
  protocol: 'http'
  port: 80
  requestPath: '/'
}

@description('Définitions des diagnostics settings à appliquer à la VMSS.')
param diagnosticSettings array = []

@description('Paramètres de verrouillage de la ressource.') // Exemple : { kind: ''CanNotDelete'', name: ''lock-vmss'', notes: ''Protection VMSS'' }.
param lock object = {}

@description('Tags à appliquer à la ressource VMSS.')
param tags object = {}

// Variables

var formattedUserAssignedIdentities = reduce(
  map(managedIdentities.?userAssignedResourceIds ?? [], id => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

var identity = !empty(managedIdentities)
  ? {
      type: managedIdentities.?systemAssigned ?? false
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var nicIpConfigurations = map(
  nicConfigurations,
  (nicConfiguration, nicIndex) =>
    map(nicConfiguration.?ipConfigurations ?? [], (ipConfiguration, ipIndex) => {
      name: ipConfiguration.?name ?? 'ipconfig-${ipIndex + 1}'
      properties: {
        primary: ipIndex == 0
        subnet: {
          id: ipConfiguration.subnetResourceId
        }
        privateIPAddressVersion: ipConfiguration.?privateIPAddressVersion ?? 'IPv4'
        applicationSecurityGroups: !empty(ipConfiguration.?applicationSecurityGroupResourceIds ?? [])
          ? map(ipConfiguration.applicationSecurityGroupResourceIds, asgId => {
              id: asgId
            })
          : null
        publicIPAddressConfiguration: !empty(ipConfiguration.?publicIpConfiguration ?? {})
          ? {
              name: ipConfiguration.publicIpConfiguration.?name ?? 'pip-${ipIndex + 1}'
              properties: {
                idleTimeoutInMinutes: ipConfiguration.publicIpConfiguration.?idleTimeoutInMinutes ?? 4
                publicIPAddressVersion: ipConfiguration.publicIpConfiguration.?publicIPAddressVersion ?? 'IPv4'
                publicIPPrefix: !empty(ipConfiguration.publicIpConfiguration.?publicIPPrefixResourceId ?? '')
                  ? {
                      id: ipConfiguration.publicIpConfiguration.publicIPPrefixResourceId
                    }
                  : null
                dnsSettings: !empty(ipConfiguration.publicIpConfiguration.?dnsSettings ?? {})
                  ? ipConfiguration.publicIpConfiguration.dnsSettings
                  : null
              }
              sku: !empty(ipConfiguration.publicIpConfiguration.?skuName ?? '')
                ? {
                    name: ipConfiguration.publicIpConfiguration.skuName
                  }
                : null
            }
          : null
      }
    })
)

var networkInterfaceConfigurations = [
  for (nicConfiguration, nicIndex) in nicConfigurations: {
    name: nicConfiguration.?name ?? '${name}-${nicConfiguration.?nicSuffix ?? 'nic'}-${nicIndex + 1}'
    properties: {
      primary: nicIndex == 0
      enableAcceleratedNetworking: nicConfiguration.?enableAcceleratedNetworking ?? true
      networkSecurityGroup: !empty(nicConfiguration.?networkSecurityGroupResourceId ?? '')
        ? {
            id: nicConfiguration.networkSecurityGroupResourceId
          }
        : null
      ipConfigurations: nicIpConfigurations[nicIndex]
    }
  }
]

var linuxOsProfile = osType == 'Linux'
  ? union(
      {
        computerNamePrefix: vmNamePrefix
        adminUsername: adminUsername
        customData: !empty(customData) ? base64(customData) : null
        linuxConfiguration: union(
          {
            disablePasswordAuthentication: disablePasswordAuthentication
            provisionVMAgent: provisionVMAgent
            ssh: !empty(publicKeys)
              ? {
                  publicKeys: publicKeys
                }
              : null
            patchSettings: provisionVMAgent
              ? {
                  patchMode: patchMode
                  assessmentMode: patchAssessmentMode
                  automaticByPlatformSettings: patchMode == 'AutomaticByPlatform'
                    ? {
                        bypassPlatformSafetyChecksOnUserSchedule: bypassPlatformSafetyChecksOnUserSchedule
                        rebootSetting: rebootSetting
                      }
                    : null
                }
              : null
          },
          linuxConfiguration
        )
      },
      !empty(adminPassword)
        ? {
            adminPassword: adminPassword
          }
        : {},
      !empty(secrets)
        ? {
            secrets: secrets
          }
        : {}
    )
  : null

var windowsOsProfile = osType == 'Windows'
  ? {
      computerNamePrefix: vmNamePrefix
      adminUsername: adminUsername
      adminPassword: adminPassword
      customData: !empty(customData) ? base64(customData) : null
      windowsConfiguration: union(
        {
          provisionVMAgent: provisionVMAgent
          enableAutomaticUpdates: enableAutomaticUpdates
          patchSettings: provisionVMAgent
            ? {
                patchMode: patchMode
                assessmentMode: patchAssessmentMode
                automaticByPlatformSettings: patchMode == 'AutomaticByPlatform'
                  ? {
                      bypassPlatformSafetyChecksOnUserSchedule: bypassPlatformSafetyChecksOnUserSchedule
                      rebootSetting: rebootSetting
                    }
                  : null
              }
            : null
        },
        windowsConfiguration
      )
      secrets: !empty(secrets) ? secrets : null
    }
  : null

var imageReferencePayload = !empty(imageReference.?id ?? '')
  ? {
      id: imageReference.id
    }
  : {
      publisher: imageReference.publisher
      offer: imageReference.offer
      sku: imageReference.sku
      version: imageReference.?version ?? 'latest'
    }

// Création des ressources

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2024-11-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  zones: !empty(availabilityZones) ? map(availabilityZones, zone => '${zone}') : null
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  plan: plan
  properties: {
    orchestrationMode: orchestrationMode
    upgradePolicy: {
      mode: upgradePolicyMode
      rollingUpgradePolicy: upgradePolicyMode == 'Rolling'
        ? {
            enableCrossZoneUpgrade: enableCrossZoneUpgrade
            maxBatchInstancePercent: maxBatchInstancePercent
            maxSurge: maxSurge
            maxUnhealthyInstancePercent: maxUnhealthyInstancePercent
            maxUnhealthyUpgradedInstancePercent: maxUnhealthyUpgradedInstancePercent
            pauseTimeBetweenBatches: pauseTimeBetweenBatches
            prioritizeUnhealthyInstances: prioritizeUnhealthyInstances
            rollbackFailedInstancesOnPolicyBreach: rollbackFailedInstancesOnPolicyBreach
          }
        : null
    }
    automaticRepairsPolicy: {
      enabled: automaticRepairsPolicyEnabled
      gracePeriod: gracePeriod
    }
    virtualMachineProfile: {
      osProfile: osType == 'Windows' ? windowsOsProfile : linuxOsProfile
      securityProfile: {
        encryptionAtHost: encryptionAtHost ? true : null
        securityType: !empty(securityType) ? securityType : null
        uefiSettings: securityType == 'TrustedLaunch'
          ? {
              secureBootEnabled: secureBootEnabled
              vTpmEnabled: vTpmEnabled
            }
          : null
      }
      storageProfile: {
        imageReference: imageReferencePayload
        osDisk: osDisk
        dataDisks: !empty(dataDisks) ? dataDisks : null
      }
      networkProfile: union(
        orchestrationMode == 'Flexible'
          ? {
              networkApiVersion: '2020-11-01'
            }
          : {},
        {
          networkInterfaceConfigurations: networkInterfaceConfigurations
        }
      )
      diagnosticsProfile: {
        bootDiagnostics: {
          enabled: !empty(bootDiagnosticStorageAccountName) ? true : bootDiagnosticEnabled
          storageUri: !empty(bootDiagnosticStorageAccountName)
            ? 'https://${bootDiagnosticStorageAccountName}${bootDiagnosticStorageAccountUri}'
            : null
        }
      }
      extensionProfile: extensionHealthConfig.?enabled ?? false
        ? {
            extensions: [
              {
                name: 'HealthExtension'
                properties: {
                  publisher: 'Microsoft.ManagedServices'
                  type: osType == 'Windows' ? 'ApplicationHealthWindows' : 'ApplicationHealthLinux'
                  typeHandlerVersion: extensionHealthConfig.?typeHandlerVersion ?? '2.0'
                  autoUpgradeMinorVersion: extensionHealthConfig.?autoUpgradeMinorVersion ?? false
                  settings: {
                    protocol: extensionHealthConfig.?protocol ?? 'http'
                    port: extensionHealthConfig.?port ?? 80
                    requestPath: (extensionHealthConfig.?protocol ?? 'http') != 'tcp'
                      ? extensionHealthConfig.?requestPath ?? '/'
                      : null
                    intervalInSeconds: extensionHealthConfig.?intervalInSeconds ?? 5
                    numberOfProbes: extensionHealthConfig.?numberOfProbes ?? 1
                  }
                }
              }
            ]
          }
        : null
      priority: vmPriority
      evictionPolicy: enableEvictionPolicy ? 'Deallocate' : null
      billingProfile: (vmPriority == 'Spot' || vmPriority == 'Low') && maxPriceForLowPriorityVm > 0
        ? {
            maxPrice: maxPriceForLowPriorityVm
          }
        : null
      licenseType: !empty(licenseType) ? licenseType : null
      scheduledEventsProfile: !empty(scheduledEventsProfile) ? scheduledEventsProfile : null
    }
    proximityPlacementGroup: !empty(proximityPlacementGroupResourceId)
      ? {
          id: proximityPlacementGroupResourceId
        }
      : null
    overprovision: orchestrationMode == 'Uniform' ? overprovision : null
    doNotRunExtensionsOnOverprovisionedVMs: orchestrationMode == 'Uniform'
      ? doNotRunExtensionsOnOverprovisionedVMs
      : null
    zoneBalance: zoneBalance ? true : null
    platformFaultDomainCount: scaleSetFaultDomain
    singlePlacementGroup: singlePlacementGroup
    additionalCapabilities: {
      ultraSSDEnabled: ultraSSDEnabled
    }
    scaleInPolicy: scaleInPolicy
  }
}

module vmssExtensions 'virtual_machine_scale_set_extension.bicep' = [
  for (extension, index) in extensions: if (extension.?enabled ?? true) {
    name: 'vmss-ext-${uniqueString(name, extension.name, string(index))}'
    params: {
      virtualMachineScaleSetName: vmss.name
      name: extension.name
      publisher: extension.publisher
      type: extension.type
      typeHandlerVersion: extension.typeHandlerVersion
      autoUpgradeMinorVersion: extension.?autoUpgradeMinorVersion ?? true
      forceUpdateTag: extension.?forceUpdateTag
      settings: extension.?settings
      protectedSettings: extension.?protectedSettings
      supressFailures: extension.?supressFailures ?? false
      enableAutomaticUpgrade: extension.?enableAutomaticUpgrade ?? false
      protectedSettingsFromKeyVault: extension.?protectedSettingsFromKeyVault
      provisionAfterExtensions: extension.?provisionAfterExtensions
    }
  }
]

resource vmssLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock) && lock.?kind != 'None') {
  name: lock.?name ?? '${name}-lock'
  scope: vmss
  properties: {
    level: lock.kind
    notes: lock.?notes ?? (lock.kind == 'CanNotDelete'
      ? 'Cannot delete the resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

resource vmssDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in diagnosticSettings: {
    name: diagnosticSetting.?name ?? '${name}-diag-${index + 1}'
    scope: vmss
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
      metrics: [
        for metricCategory in (diagnosticSetting.?metricCategories ?? [
          {
            category: 'AllMetrics'
            enabled: true
          }
        ]): {
          category: metricCategory.category
          enabled: metricCategory.?enabled ?? true
          timeGrain: null
        }
      ]
    }
  }
]

// Outputs

@description('ID de ressource du Virtual Machine Scale Set.')
output resourceId string = vmss.id

@description('Nom du Virtual Machine Scale Set.')
output name string = vmss.name

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name

@description('Localisation du Virtual Machine Scale Set.')
output location string = vmss.location

@description('Principal ID de l\'identité système, si activée.')
output systemAssignedMIPrincipalId string = managedIdentities.?systemAssigned ?? false ? vmss.identity.principalId : ''

@description('Identité effective associée à la VMSS.')
output identity object = vmss.identity

@description('Mode d\'orchestration effectif du Virtual Machine Scale Set.')
output orchestrationMode string = vmss.properties.orchestrationMode
