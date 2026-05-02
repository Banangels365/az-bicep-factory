// connectivity-lz/modules/ddos_protection.bicep
// DDoS Protection Plan module

@description('DDoS Protection Plan name')
param ddosProtectionPlanName string

@description('Location for the DDoS protection plan')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('Tags to apply to the DDoS protection plan')
param tags object = {}

// DDoS Protection Plan Resource
resource ddosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2023-09-01' = {
  name: ddosProtectionPlanName
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
  tags: tags
  properties: {}
}

// Outputs
@description('DDoS Protection Plan resource ID')
output ddosProtectionPlanId string = ddosProtectionPlan.id

@description('DDoS Protection Plan name')
output ddosProtectionPlanName string = ddosProtectionPlan.name
