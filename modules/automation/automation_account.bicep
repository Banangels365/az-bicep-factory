// modules/automation/automation_account.bicep
// Compte Azure Automation avec artefacts principaux.

targetScope = 'resourceGroup'

@description('Nom du compte Azure Automation.')
param automationAccountName string

@description('Région logique de déploiement.')
param location string = resourceGroup().location

@description('SKU du compte Automation.')
@allowed([
  'Basic'
  'Free'
])
param sku string = 'Basic'

@description('Active l\'identité managée système du compte Automation.')
param enableSystemAssignedIdentity bool = true

@description('Liste des IDs de managed identities utilisateur à attacher au compte Automation.')
param userAssignedManagedIdentityIds array = []

@description('Active l\'authentification locale du compte. false est recommandé.')
param disableLocalAuth bool = true

@description('Active l\'accès réseau public au compte Automation.')
param publicNetworkAccess bool = false

@description('Configuration de chiffrement CMK. Laisser null pour ne pas activer de clé gérée par le client.')
param customerManagedKey object = {}

@description('ID du Log Analytics Workspace à lier au compte Automation.')
param linkedWorkspaceResourceId string = ''

@description('Active les paramètres de diagnostic sur le compte Automation.')
param enableDiagnostics bool = true

@description('Liste des paramètres de diagnostic à créer. Si vide et que linkedWorkspaceResourceId est fourni, une configuration par défaut est créée.')
param diagnosticSettings array = []

@description('Liste des credentials à créer dans le compte Automation.')
param credentials array = []

@description('Liste des modules PowerShell classiques à créer dans le compte Automation.')
param modules array = []

@description('Liste des modules PowerShell 7.2 à créer dans le compte Automation.')
param powershell72Modules array = []

@description('Liste des packages Python 2 à créer dans le compte Automation.')
param python2Packages array = []

@description('Liste des packages Python 3 à créer dans le compte Automation.')
param python3Packages array = []

@description('Liste des runbooks à créer dans le compte Automation.')
param runbooks array = []

@description('Liste des schedules à créer dans le compte Automation.')
param schedules array = []

@description('Liste des job schedules à créer pour lier runbooks et schedules.')
param jobSchedules array = []

@description('Liste des variables Automation à créer.')
param variables array = []

@description('Liste des webhooks à créer.')
param webhooks array = []

@description('Liste des configurations source control à créer.')
param sourceControlConfigurations array = []

@description('Tags à appliquer au compte Automation et, par défaut, aux sous-ressources supportant les tags.')
param tags object = {}

// Variables 

var userAssignedIdentitiesArray = [
  for id in userAssignedManagedIdentityIds: {
    key: id
    value: {}
  }
]

var formattedUserAssignedIdentities = length(userAssignedManagedIdentityIds) > 0
  ? reduce(userAssignedIdentitiesArray, {}, (cur, next) => union(cur, { '${next.key}': next.value }))
  : {}

var identityType = enableSystemAssignedIdentity && length(userAssignedManagedIdentityIds) > 0
  ? 'SystemAssigned,UserAssigned'
  : enableSystemAssignedIdentity
      ? 'SystemAssigned'
      : length(userAssignedManagedIdentityIds) > 0 ? 'UserAssigned' : 'None'

// Création des ressources

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: automationAccountName
  location: location
  tags: tags
  identity: identityType == 'None'
    ? null
    : union(
        {
          type: identityType
        },
        length(userAssignedManagedIdentityIds) > 0
          ? {
              userAssignedIdentities: formattedUserAssignedIdentities
            }
          : {}
      )
  properties: union(
    {
      sku: {
        name: sku
      }
      publicNetworkAccess: publicNetworkAccess
      disableLocalAuth: disableLocalAuth
    },
    customerManagedKey != null
      ? {
          encryption: {
            keySource: 'Microsoft.Keyvault'
            identity: !empty(customerManagedKey.?userAssignedIdentityResourceId ?? '')
              ? { userAssignedIdentity: customerManagedKey.userAssignedIdentityResourceId }
              : null
            keyVaultProperties: {
              keyName: customerManagedKey.keyName
              keyvaultUri: customerManagedKey.keyVaultUri
              keyVersion: !empty(customerManagedKey.?keyVersion ?? '') ? customerManagedKey.keyVersion : null
            }
          }
        }
      : {}
  )
}

// Credentials
module automationCredentials './automation_account_artifact.bicep' = [
  for (item, index) in credentials: {
    name: 'automation-credential-${uniqueString(automationAccountName, string(index), item.name)}'
    params: {
      automationAccountName: automationAccount.name
      artifactType: 'credential'
      location: location
      name: item.name
      tags: tags
      properties: {
        userName: item.userName
        password: item.password
        description: item.?description
      }
    }
  }
]

// PowerShell modules
module automationModules './automation_account_artifact.bicep' = [
  for (item, index) in modules: {
    name: 'automation-module-${uniqueString(automationAccountName, string(index), item.name)}'
    params: {
      automationAccountName: automationAccount.name
      artifactType: 'module'
      location: location
      name: item.name
      tags: item.?tags ?? tags
      properties: {
        uri: item.uri
        version: item.?version ?? 'latest'
      }
    }
  }
]

// PowerShell 7.2 modules
module automationPwsh72Modules './automation_account_artifact.bicep' = [
  for (item, index) in powershell72Modules: {
    name: 'automation-pwsh72-${uniqueString(automationAccountName, string(index), item.name)}'
    params: {
      automationAccountName: automationAccount.name
      artifactType: 'powershell72Module'
      location: item.?location ?? location
      name: item.name
      tags: item.?tags ?? tags
      properties: {
        uri: item.uri
        version: item.?version ?? 'latest'
      }
    }
  }
]

// Python 2 packages
module automationPython2Packages './automation_account_artifact.bicep' = [
  for (item, index) in python2Packages: {
    name: 'automation-python2-${uniqueString(automationAccountName, string(index), item.name)}'
    params: {
      automationAccountName: automationAccount.name
      artifactType: 'python2Package'
      location: location
      name: item.name
      tags: item.?tags ?? tags
      properties: {
        uri: item.uri
        version: item.?version ?? 'latest'
      }
    }
  }
]

// Python 3 packages
module automationPython3Packages './automation_account_artifact.bicep' = [
  for (item, index) in python3Packages: {
    name: 'automation-python3-${uniqueString(automationAccountName, string(index), item.name)}'
    params: {
      automationAccountName: automationAccount.name
      artifactType: 'python3Package'
      location: location
      name: item.name
      tags: item.?tags ?? tags
      properties: {
        uri: item.uri
        version: item.?version ?? 'latest'
      }
    }
  }
]

// Runbooks
module automationRunbooks './automation_account_artifact.bicep' = [
  for (item, index) in runbooks: {
    name: 'automation-runbook-${uniqueString(automationAccountName, string(index), item.name)}'
    params: {
      automationAccountName: automationAccount.name
      artifactType: 'runbook'
      location: location
      name: item.name
      tags: item.?tags ?? tags
      properties: {
        type: item.type
        description: item.?description
        uri: item.?uri ?? item.?scriptUri
        version: item.?version
        logVerboseOutput: item.?logVerbose ?? false
        logProgressOutput: item.?logProgress ?? false
        logActivityTrace: item.?logActivity ?? 0
      }
    }
  }
]

// Schedules
module automationSchedules './automation_account_artifact.bicep' = [
  for (item, index) in schedules: {
    name: 'automation-schedule-${uniqueString(automationAccountName, string(index), item.name)}'
    params: {
      automationAccountName: automationAccount.name
      artifactType: 'schedule'
      location: location
      name: item.name
      properties: {
        advancedSchedule: item.?advancedSchedule
        description: item.?description
        expiryTime: item.?expiryTime
        frequency: item.?frequency ?? 'OneTime'
        interval: item.?interval ?? 0
        startTime: item.?startTime
        timeZone: item.?timeZone ?? 'America/Toronto'
      }
    }
  }
]

// Automation Variables
module automationVariables './automation_account_artifact.bicep' = [
  for (item, index) in variables: {
    name: 'automation-variable-${uniqueString(automationAccountName, string(index), item.name)}'
    params: {
      automationAccountName: automationAccount.name
      artifactType: 'variable'
      location: location
      name: item.name
      properties: {
        description: item.?description
        value: item.value
        isEncrypted: item.?isEncrypted ?? false
      }
    }
  }
]

// Webhooks
module automationWebhooks './automation_account_artifact.bicep' = [
  for (item, index) in webhooks: {
    name: 'automation-webhook-${uniqueString(automationAccountName, string(index), item.name)}'
    params: {
      automationAccountName: automationAccount.name
      artifactType: 'webhook'
      location: location
      name: item.name
      properties: {
        runbookName: item.runbookName
        runOn: item.?runOn
        parameters: item.?parameters ?? {}
        expiryTime: item.?expiryTime
        isEnabled: item.?isEnabled ?? false
      }
    }
  }
]

// Source control
module automationSourceControls './automation_account_artifact.bicep' = [
  for (item, index) in sourceControlConfigurations: {
    name: 'automation-sourcecontrol-${uniqueString(automationAccountName, string(index), item.name)}'
    params: {
      automationAccountName: automationAccount.name
      artifactType: 'sourceControl'
      location: location
      name: item.name
      properties: {
        sourceType: item.sourceType
        autoSync: item.?autoSync ?? false
        repoUrl: item.repoUrl
        branch: item.branch
        folderPath: item.folderPath
        publishRunbook: item.?publishRunbook ?? true
        description: item.description
        securityToken: item.?securityToken
      }
    }
  }
]

// Job schedules
module automationJobSchedules './automation_account_job_link.bicep' = [
  for (item, index) in jobSchedules: {
    name: 'automation-jobschedule-${uniqueString(automationAccountName, string(index), item.runbookName, item.scheduleName)}'
    params: {
      automationAccountName: automationAccount.name
      runbookName: item.runbookName
      scheduleName: item.scheduleName
      parameters: item.?parameters ?? {}
      runOn: item.?runOn ?? ''
    }
    dependsOn: [
      automationRunbooks
      automationSchedules
    ]
  }
]

// Liaison Log Analytics Workspace
resource linkedService 'Microsoft.OperationalInsights/workspaces/linkedServices@2025-02-01' = if (!empty(linkedWorkspaceResourceId)) {
  name: '${last(split(linkedWorkspaceResourceId, '/'))}/Automation'
  // scope: resourceGroup(split(linkedWorkspaceResourceId, '/')[2], split(linkedWorkspaceResourceId, '/')[4])
  properties: {
    resourceId: automationAccount.id
  }
}

// Diagnostic settings par défaut si aucun tableau détaillé n\'est fourni
resource defaultDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics && !empty(linkedWorkspaceResourceId) && empty(diagnosticSettings)) {
  name: '${automationAccountName}-diagnostics'
  scope: automationAccount
  properties: {
    workspaceId: linkedWorkspaceResourceId
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// Diagnostic settings détaillés
resource customDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (item, index) in diagnosticSettings: if (enableDiagnostics) {
    name: item.?name ?? '${automationAccountName}-diag-${index}'
    scope: automationAccount
    properties: {
      workspaceId: item.?workspaceResourceId
      storageAccountId: item.?storageAccountResourceId
      eventHubAuthorizationRuleId: item.?eventHubAuthorizationRuleResourceId
      eventHubName: item.?eventHubName
      logAnalyticsDestinationType: item.?logAnalyticsDestinationType
      logs: [
        for logItem in item.?logCategoriesAndGroups ?? []: {
          category: logItem.?category
          categoryGroup: logItem.?categoryGroup
          enabled: logItem.?enabled ?? true
        }
      ]
      metrics: [
        for metricItem in item.?metricCategories ?? []: {
          category: metricItem.category
          enabled: metricItem.?enabled ?? true
        }
      ]
    }
  }
]

// Outputs

@description('ID du compte Automation créé.')
output automationAccountId string = automationAccount.id

@description('Nom du compte Automation créé.')
output automationAccountName string = automationAccount.name

@description('Localisation réelle du compte Automation.')
output automationAccountLocation string = automationAccount.location

@description('URL du service hybride Automation si exposée par la ressource.')
output automationAccountEndpoint string = automationAccount.properties.?automationHybridServiceUrl ?? ''

@description('Principal ID de l\'identité managée système du compte Automation.')
output principalId string = enableSystemAssignedIdentity ? (automationAccount.identity.?principalId ?? '') : ''

@description('Noms des credentials créés.')
output credentialNames array = [for (item, i) in credentials: automationCredentials[i].outputs.name]

@description('Noms des modules PowerShell créés.')
output moduleNames array = [for (item, i) in modules: automationModules[i].outputs.name]

@description('Noms des modules PowerShell 7.2 créés.')
output powershell72ModuleNames array = [for (item, i) in powershell72Modules: automationPwsh72Modules[i].outputs.name]

@description('Noms des packages Python 2 créés.')
output python2PackageNames array = [for (item, i) in python2Packages: automationPython2Packages[i].outputs.name]

@description('Noms des packages Python 3 créés.')
output python3PackageNames array = [for (item, i) in python3Packages: automationPython3Packages[i].outputs.name]

@description('Noms des runbooks créés.')
output runbookNames array = [for (item, i) in runbooks: automationRunbooks[i].outputs.name]

@description('Noms des schedules créés.')
output scheduleNames array = [for (item, i) in schedules: automationSchedules[i].outputs.name]

@description('Noms des variables créées.')
output variableNames array = [for (item, i) in variables: automationVariables[i].outputs.name]

@description('Noms des webhooks créés.')
output webhookNames array = [for (item, i) in webhooks: automationWebhooks[i].outputs.name]

@description('Noms des configurations source control créées.')
output sourceControlNames array = [
  for (item, i) in sourceControlConfigurations: automationSourceControls[i].outputs.name
]

@description('IDs des job schedules créés.')
output jobScheduleIds array = [for (item, i) in jobSchedules: automationJobSchedules[i].outputs.resourceId]
