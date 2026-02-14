// az-platform-lz/main.bicepparam
using 'main.bicep'

// Organization configuration
param organizationName = 'contoso'
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
param logRetentionDays = 90
param enableSentinel = true

// Subscription associations
param managementSubscriptionId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

param devSubscriptionIds = [
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
]

param stagingSubscriptionIds = [
  'cccccccc-cccc-cccc-cccc-cccccccccccc'
]

param prodSubscriptionIds = [
  'dddddddd-dddd-dddd-dddd-dddddddddddd'
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'
]
