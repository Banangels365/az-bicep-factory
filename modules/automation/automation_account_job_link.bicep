// modules/automation/automation_account_job_link.bicep
// Sous-module de liaison entre un runbook et un schedule.

targetScope = 'resourceGroup'

@description('Nom du compte Automation parent.')
param automationAccountName string

@description('Nom du runbook à planifier.')
param runbookName string

@description('Nom du schedule à associer au runbook.')
param scheduleName string

@description('Paramètres à transmettre au runbook au moment de l\'exécution.')
param parameters object = {}

@description('Nom du Hybrid Runbook Worker Group à utiliser. Laisser vide pour une exécution standard.')
param runOn string = ''

// Création des ressources

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' existing = {
  name: automationAccountName
}

resource jobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2024-10-23' = {
  name: guid(automationAccount.id, scheduleName, runbookName)
  parent: automationAccount
  properties: {
    parameters: parameters
    runbook: {
      name: runbookName
    }
    runOn: !empty(runOn) ? runOn : null
    schedule: {
      name: scheduleName
    }
  }
}

// Outputs

@description('Nom technique du job schedule créé.')
output name string = jobSchedule.name

@description('ID de ressource du job schedule créé.')
output resourceId string = jobSchedule.id
