// az-platform-lz/main.bicepparam
using 'main.bicep'

// Organization configuration
param organizationName = 'ACMY'
param location = 'canadacentral'
param environment = 'prod'

// Tagging strategy
param tags = {
  Environment: 'Production'
  ManagedBy: 'Bicep'
  CostCenter: 'IT-Platform'
  Owner: 'CloudOps-Team'
  DataClassification: 'Internal'
}

// Logging configuration
// param logRetentionDays = 90
// param enableSentinel = true

// billing scope ID for subscription creation
param managementSubscriptionId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
