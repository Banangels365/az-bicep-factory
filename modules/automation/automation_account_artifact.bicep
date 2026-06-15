// modules/automation/automation_account_artifact.bicep
// Sous-module générique pour les artefacts d'un compte Automation.

targetScope = 'resourceGroup'

@description('Nom du compte Automation parent.')
param automationAccountName string

@description('Type d\'artefact à créer.')
@allowed([
  'credential'
  'module'
  'powershell72Module'
  'python2Package'
  'python3Package'
  'runbook'
  'schedule'
  'variable'
  'webhook'
  'sourceControl'
])
param artifactType string

@description('Nom de l\'artefact.')
param name string

@description('Localisation de la ressource lorsque le type d\'artefact la supporte.')
param location string = resourceGroup().location

@description('Tags à appliquer lorsque le type d\'artefact la supporte.')
param tags object = {}

@description('Propriétés spécifiques à l\'artefact.')
param properties object = {}

@description('Date de début de la planification.')
param scheduleStartTime string = utcNow('u')

@description('Date d\'expiration du webhook (si le webhook est configuré).')
param webhookExpiryTime string = utcNow()

// Créer le compte Automation parent si nécessaire
resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' existing = {
  name: automationAccountName
}

// Credential
resource credential 'Microsoft.Automation/automationAccounts/credentials@2024-10-23' = if (artifactType == 'credential') {
  name: name
  parent: automationAccount
  properties: {
    userName: properties.userName
    password: properties.password
    description: !empty(properties.?description ?? '') ? properties.description : null
  }
}

// Module
resource automationModule 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = if (artifactType == 'module') {
  name: name
  parent: automationAccount
  location: location
  tags: tags
  properties: {
    contentLink: {
      uri: properties.version != 'latest'
        ? '${properties.uri}/${name}/${properties.version}'
        : '${properties.uri}/${name}'
      version: properties.version != 'latest' ? properties.version : null
    }
  }
}

// PowerShell 7.2 Module
resource powershell72Module 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = if (artifactType == 'powershell72Module') {
  name: name
  parent: automationAccount
  location: location
  tags: tags
  properties: {
    contentLink: {
      uri: properties.version != 'latest'
        ? '${properties.uri}/${name}/${properties.version}'
        : '${properties.uri}/${name}'
      version: properties.version != 'latest' ? properties.version : null
    }
  }
}

// Python 2 Package
resource python2Package 'Microsoft.Automation/automationAccounts/python2Packages@2023-11-01' = if (artifactType == 'python2Package') {
  name: name
  parent: automationAccount
  tags: tags
  properties: {
    contentLink: {
      uri: properties.version != 'latest'
        ? '${properties.uri}/${name}/${properties.version}'
        : '${properties.uri}/${name}'
      version: properties.version != 'latest' ? properties.version : null
    }
  }
}

// Python 3 Package
resource python3Package 'Microsoft.Automation/automationAccounts/python3Packages@2023-11-01' = if (artifactType == 'python3Package') {
  name: name
  parent: automationAccount
  tags: tags
  properties: {
    contentLink: {
      uri: properties.version != 'latest'
        ? '${properties.uri}/${name}/${properties.version}'
        : '${properties.uri}/${name}'
      version: properties.version != 'latest' ? properties.version : null
    }
  }
}

// Runbook
resource runbook 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = if (artifactType == 'runbook') {
  name: name
  parent: automationAccount
  location: location
  tags: tags
  properties: {
    runbookType: properties.type
    description: !empty(properties.?description ?? '') ? properties.description : null
    logVerbose: properties.?logVerboseOutput ?? false
    logProgress: properties.?logProgressOutput ?? false
    logActivityTrace: properties.?logActivityTrace ?? 0
    publishContentLink: !empty(properties.?uri ?? '')
      ? {
          uri: properties.uri
          version: !empty(properties.?version ?? '') ? properties.version : null
        }
      : null
  }
}

// Schedule
resource schedule 'Microsoft.Automation/automationAccounts/schedules@2024-10-23' = if (artifactType == 'schedule') {
  name: name
  parent: automationAccount
  properties: {
    advancedSchedule: properties.?advancedSchedule
    description: !empty(properties.?description ?? '') ? properties.description : null
    expiryTime: !empty(properties.?expiryTime ?? '') ? properties.expiryTime : null
    frequency: properties.?frequency ?? 'OneTime'
    interval: (properties.?interval ?? 0) != 0 ? properties.interval : null
    startTime: !empty(properties.?startTime ?? '') ? properties.startTime : dateTimeAdd(scheduleStartTime, 'PT15M')
    timeZone: !empty(properties.?timeZone ?? '') ? properties.timeZone : null
  }
}

// Variable
resource automationVariable 'Microsoft.Automation/automationAccounts/variables@2024-10-23' = if (artifactType == 'variable') {
  name: name
  parent: automationAccount
  properties: {
    description: !empty(properties.?description ?? '') ? properties.description : null
    value: string(properties.value)
    isEncrypted: properties.?isEncrypted ?? false
  }
}

// Webhook
resource webhook 'Microsoft.Automation/automationAccounts/webhooks@2024-10-23' = if (artifactType == 'webhook') {
  name: name
  parent: automationAccount
  properties: {
    isEnabled: properties.?isEnabled ?? false
    expiryTime: !empty(properties.?expiryTime ?? '') ? properties.expiryTime : webhookExpiryTime
    runbook: {
      name: properties.runbookName
    }
    runOn: !empty(properties.?runOn ?? '') ? properties.runOn : null
    uri: null
    parameters: properties.?parameters ?? {}
  }
}

// Source control
resource sourceControl 'Microsoft.Automation/automationAccounts/sourceControls@2024-10-23' = if (artifactType == 'sourceControl') {
  name: name
  parent: automationAccount
  properties: {
    sourceType: properties.sourceType
    autoSync: properties.?autoSync ?? false
    repoUrl: properties.repoUrl
    branch: properties.branch
    folderPath: properties.folderPath
    publishRunbook: properties.?publishRunbook ?? true
    description: properties.description
    securityToken: properties.?securityToken
  }
}

@description('Nom de l\'artefact créé.')
output name string = name

@description('ID de ressource de l\'artefact créé.')
output resourceId string = artifactType == 'credential'
  ? credential.id
  : artifactType == 'module'
      ? automationModule.id
      : artifactType == 'powershell72Module'
          ? powershell72Module.id
          : artifactType == 'python2Package'
              ? python2Package.id
              : artifactType == 'python3Package'
                  ? python3Package.id
                  : artifactType == 'runbook'
                      ? runbook.id
                      : artifactType == 'schedule'
                          ? schedule.id
                          : artifactType == 'variable'
                              ? automationVariable.id
                              : artifactType == 'webhook' ? webhook.id : sourceControl.id

@description('Localisation réelle de l\'artefact lorsque disponible.')
output deployedLocation string = artifactType == 'module'
  ? automationModule!.location!
  : artifactType == 'powershell72Module'
      ? powershell72Module!.location!
      : artifactType == 'runbook' ? runbook!.location! : location!
