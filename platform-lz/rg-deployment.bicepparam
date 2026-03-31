// rg-deployment.bicepparam
using './rg-deployment.bicep'

param environment = 'sandbox'
param location = 'canadacentral'
param tags = {
  Environment: 'sandbox'
  ManagedBy: 'Bicep'
  CostCenter: 'IT-Platform'
  Owner: 'CloudOps-Team'
  DataClassification: 'Internal'
}
