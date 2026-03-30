// platform-lz/main.bicepparam
using 'main.bicep'

// Organization configuration
param organizationName = 'ACMY'
param location = 'canadacentral'
param environment = 'sandbox'

// Tagging strategy
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
