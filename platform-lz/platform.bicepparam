// platform-lz/main.bicepparam
using './platform.bicep'

// Organization configuration
param organizationName = 'ACMY'
param location = 'canadacentral'
param environment = 'sandbox'

// liste des tags à appliquer à toutes les ressources
param tags = {
  Environment: 'sandbox'
  ManagedBy: 'Bicep'
  CostCenter: 'IT-Platform'
  Owner: 'CloudOps-Team'
  DataClassification: 'Internal'
}

// Logging configuration
// param logRetentionDays = 90
// param enableSentinel = true

// billing scope ID for subscription creation
param managementSubscriptionId = 'f3a6536e-1f68-4ca4-bb51-adf7822ec8bc' // Subscription ID where the management group and billing scope are located

// Liste des abonnements à créer
param subscriptions = [
  {
    alias: 'sub-prod-${organizationName}-01'
    displayName: '${organizationName} Production Subscription 01'
    billingScope: '/subscriptions/${managementSubscriptionId}'
    workload: 'Prod'
    mgId: '${organizationName}-prod'
  }
  {
    alias: 'sub-prod-${organizationName}-02'
    displayName: '${organizationName} Production Subscription 02'
    billingScope: '/subscriptions/${managementSubscriptionId}'
    workload: 'Prod'
    mgId: '${organizationName}-prod'
  }
  {
    alias: 'sub-logging-${organizationName}'
    displayName: '${organizationName} Logging Subscription'
    billingScope: '/subscriptions/${managementSubscriptionId}'
    workload: 'Logging'
    mgId: '${organizationName}-logging'
  }
  // Ajoutez d'autres
]
