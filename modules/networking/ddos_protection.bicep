// connectivity-lz/modules/ddos_protection.bicep
// DDoS Protection Plan module

@description('Nom du plan de protection DDoS')
param ddosProtectionPlanName string

@description('Région pour le plan de protection DDoS')
param location string

@description('Tags à appliquer au plan de protection DDoS')
param tags object = {}

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// DDoS Protection Plan Resource
resource ddosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2023-09-01' = {
  name: ddosProtectionPlanName
  location: resolvedLocation
  tags: tags
  properties: {}
}

// Outputs
@description('ID du plan de protection DDoS')
output ddosProtectionPlanId string = ddosProtectionPlan.id

@description('Nom du plan de protection DDoS')
output ddosProtectionPlanName string = ddosProtectionPlan.name
