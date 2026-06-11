targetScope = 'resourceGroup'

@description('Nom du Host Pool')
param name string

@description('Région Azure du Host Pool. Par défaut : région du resource group.')
param location string = resourceGroup().location

@description('Nom convivial affiché dans le portail Azure.')
param friendlyName string = ''

@description('Description du Host Pool.')
param hostPoolDescription string = ''

@description('Tags à appliquer à la ressource.')
param tags object = {}

@description('Type du Host Pool.')
@allowed([
  'Pooled'
  'Personal'
])
param hostPoolType string = 'Pooled'

@description('Algorithme de load balancing. Pour un Host Pool Personal, la valeur effective sera forcée à Persistent.')
@allowed([
  'BreadthFirst'
  'DepthFirst'
  'Persistent'
])
param loadBalancerType string = 'BreadthFirst'

@description('Nombre maximal de sessions par hôte. Applicable uniquement aux Host Pools Pooled.')
@minValue(1)
@maxValue(999999)
param maxSessionLimit int = 10

@description('Mode d\'assignation des postes personnels. Applicable uniquement aux Host Pools Personal.')
@allowed([
  'Automatic'
  'Direct'
])
param personalDesktopAssignmentType string = 'Automatic'

@description('Type d\'Application Group préféré.')
@allowed([
  'Desktop'
  'RailApplications'
  'None'
])
param preferredAppGroupType string = 'Desktop'

@description('Active Start VM on Connect.')
param startVMOnConnect bool = true

@description('Déploie le Host Pool dans l\'environnement de validation AVD.')
param validationEnvironment bool = false

@description('Propriétés RDP personnalisées.')
param customRdpProperty string = 'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:0;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'

@description('Mode de gestion du Host Pool. Standard permet de générer un token d\'enregistrement ; Automated ne retourne pas de token.')
@allowed([
  'Standard'
  'Automated'
])
param managementType string = 'Standard'

@description('Durée de validité du token d\'enregistrement au format ISO 8601. Exemple : PT8H, PT24H, P5D.')
param tokenValidityLength string = 'PT24H'

@description('Date de base utilisée pour calculer l\'expiration du token. Ne pas surcharger sauf besoin spécifique.')
param baseTime string = utcNow('u')

@description('Configuration de la mise à jour des agents AVD. Laisser vide pour ne pas configurer de fenêtre planifiée.')
param agentUpdate object = {}

@description('Niveau d\'accès réseau public au Host Pool.')
@allowed([
  'Enabled'
  'Disabled'
  'EnabledForClientsOnly'
  'EnabledForSessionHostsOnly'
])
param publicNetworkAccess string = 'Enabled'

@description('Paramètre direct UDP.')
@allowed([
  'Default'
  'Enabled'
  'Disabled'
])
param directUDP string = 'Default'

@description('Paramètre managed private UDP.')
@allowed([
  'Default'
  'Enabled'
  'Disabled'
])
param managedPrivateUDP string = 'Default'

@description('Paramètre public UDP.')
@allowed([
  'Default'
  'Enabled'
  'Disabled'
])
param publicUDP string = 'Default'

@description('Paramètre relay UDP.')
@allowed([
  'Default'
  'Enabled'
  'Disabled'
])
param relayUDP string = 'Default'

@description('Numéro de ring AVD.')
param ring int?

@description('Template VM sérialisé pour les session hosts. Laisser vide si non utilisé.')
param vmTemplate string = ''

@description('Autorité ADFS pour SSO.')
param ssoadfsAuthority string = ''

@description('Client ID utilisé pour le SSO AVD.')
param ssoClientId string = ''

@description('Chemin Key Vault du secret SSO.')
@secure()
param ssoClientSecretKeyVaultPath string = ''

@description('Type de secret SSO.')
@secure()
@allowed([
  ''
  'Certificate'
  'CertificateInKeyVault'
  'SharedKey'
  'SharedKeyInKeyVault'
])
param ssoSecretType string = ''

@description('Liste des paramètres de diagnostic à créer sur le Host Pool.')
param diagnosticSettings array = []

var isPooled = hostPoolType == 'Pooled'
var isPersonal = hostPoolType == 'Personal'
var registrationTokenEnabled = managementType == 'Standard' && !empty(tokenValidityLength)

var resolvedLoadBalancerType = isPooled ? loadBalancerType : 'Persistent'

var hostPoolProperties = union(
  {
    hostPoolType: hostPoolType
    loadBalancerType: resolvedLoadBalancerType
    preferredAppGroupType: preferredAppGroupType
    startVMOnConnect: startVMOnConnect
    validationEnvironment: validationEnvironment
    customRdpProperty: customRdpProperty
    publicNetworkAccess: publicNetworkAccess
    managementType: managementType
    directUDP: directUDP
    managedPrivateUDP: managedPrivateUDP
    publicUDP: publicUDP
    relayUDP: relayUDP
  },
  !empty(friendlyName) ? { friendlyName: friendlyName } : {},
  !empty(hostPoolDescription) ? { description: hostPoolDescription } : {},
  isPooled ? { maxSessionLimit: maxSessionLimit } : {},
  isPersonal ? { personalDesktopAssignmentType: personalDesktopAssignmentType } : {},
  registrationTokenEnabled
    ? {
        registrationInfo: {
          expirationTime: dateTimeAdd(baseTime, tokenValidityLength)
          registrationTokenOperation: 'Update'
        }
      }
    : {},
  !empty(agentUpdate) ? { agentUpdate: agentUpdate } : {},
  !empty(vmTemplate) ? { vmTemplate: vmTemplate } : {},
  !empty(ssoadfsAuthority) ? { ssoadfsAuthority: ssoadfsAuthority } : {},
  !empty(ssoClientId) ? { ssoClientId: ssoClientId } : {},
  !empty(ssoClientSecretKeyVaultPath) ? { ssoClientSecretKeyVaultPath: ssoClientSecretKeyVaultPath } : {},
  !empty(ssoSecretType) ? { ssoSecretType: ssoSecretType } : {},
  ring != null ? { ring: ring } : {}
)

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2025-03-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: hostPoolProperties
}

resource hostPoolDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in diagnosticSettings: {
    name: !empty(diagnosticSetting.?name) ? diagnosticSetting.name : '${name}-diag-${index + 1}'
    scope: hostPool
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

@description('Resource ID du Host Pool.')
output resourceId string = hostPool.id

@description('Nom du Host Pool.')
output hostPoolName string = hostPool.name

@description('Région du Host Pool.')
output hostPoolLocation string = hostPool.location

@description('Type du Host Pool.')
output deployedHostPoolType string = hostPool.properties.hostPoolType

@description('Type de load balancing effectivement appliqué.')
output deployedLoadBalancerType string = hostPool.properties.loadBalancerType

@description('Type d\'Application Group préféré.')
output deployedPreferredAppGroupType string = hostPool.properties.preferredAppGroupType

@description('Token d\'enregistrement du Host Pool. Retourne une valeur uniquement si managementType = Standard.')
@secure()
output registrationToken string = managementType == 'Standard' ? (hostPool.properties.registrationInfo.token ?? '') : ''

@description('Date d\'expiration du token d\'enregistrement.')
output registrationTokenExpirationTime string = registrationTokenEnabled
  ? dateTimeAdd(baseTime, tokenValidityLength)
  : ''
