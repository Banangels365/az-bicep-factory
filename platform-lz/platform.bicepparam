// platform-lz/platform.bicepparam
using './platform.bicep'

// Organization configuration
param organizationName = 'acmy'
param environment = 'sbox' // prod, dev, logs, quar, sbox
param location = 'caea' // canadacentral ou canadaeast

// billing scope ID for subscription creation
param managementSubscriptionId = 'f3a6536e-1f68-4ca4-bb51-adf7822ec8bc'

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
