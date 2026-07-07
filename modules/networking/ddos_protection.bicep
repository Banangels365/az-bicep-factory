// modules/networking/ddos_protection.bicep
// DDoS Protection Plan module

@description('Nom du plan de protection DDoS')
param ddosProtectionPlanName string

@description('Région pour le plan de protection DDoS')
param location string = resourceGroup().location

@description('Tags à appliquer au plan de protection DDoS')
param tags object = {}

// DDoS Protection Plan Resource
resource ddosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2023-09-01' = {
  name: ddosProtectionPlanName
  location: location
  tags: tags
  properties: {}
}

// Outputs
@description('ID du plan de protection DDoS')
output ddosProtectionPlanId string = ddosProtectionPlan.id

@description('Nom du plan de protection DDoS')
output ddosProtectionPlanName string = ddosProtectionPlan.name
