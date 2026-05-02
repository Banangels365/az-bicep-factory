// platform-lz/platform.bicepparam
using './platform.bicep'

// Organization configuration
param organizationName = 'acmy'
param environment = 'sbox' // prod, logs, quar, sbox
param location = 'caea' // canadacentral ou canadaeast

// RG de la plateforme où seront créés les ressources transversales, de gouvernance, d’observabilité et d’administration communes à plusieurs environnements (prod, dev, sandbox, etc.).
// telles que (log analytics, azure policies, diagnostic settings, actions Group, alerts, etc.).
// param platformResourceGroupName = 'rg-sbox-caea-platform'

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
var managementSubscriptionId = 'f3a6536e-1f68-4ca4-bb51-adf7822ec8bc' // Subscription ID where the management group and billing scope are located

// Liste des abonnements à créer
param subscriptions = [
  {
    alias: 'sub-${environment}-${organizationName}-${location}-01'
    displayName: '${organizationName} Production Subscription 01'
    billingScope: '/subscriptions/${managementSubscriptionId}'
    workload: 'sbox'
    mgId: '${organizationName}-${environment}'
  }
  {
    alias: 'sub-${environment}-${organizationName}-${location}-02'
    displayName: '${organizationName} Production Subscription 02'
    billingScope: '/subscriptions/${managementSubscriptionId}'
    workload: 'sbox'
    mgId: '${organizationName}-${environment}'
  }
  {
    alias: 'sub-${environment}-${organizationName}-${location}-01'
    displayName: '${organizationName} Logging Subscription'
    billingScope: '/subscriptions/${managementSubscriptionId}'
    workload: 'logs'
    mgId: '${organizationName}-${environment}'
  }
  // Ajoutez d'autres
]

param resourceGroups = [
  {
    name: 'rg-${environment}-${location}-management'
    location: location
    tags: tags
  }
  {
    name: 'rg-${environment}-${location}-identity'
    location: location
    tags: tags
  }
  {
    name: 'rg-${environment}-${location}-networking'
    location: location
    tags: tags
  }
  {
    name: 'rg-${environment}-${location}-monitoring'
    location: location
    tags: tags
  }
]
