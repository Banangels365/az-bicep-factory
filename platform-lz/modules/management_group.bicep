// platform-lz/modules/management_group.bicep
// Management Group module for Azure Landing Zone hierarchy

targetScope = 'tenant'

@description('ID du groupe d\'administration') // Doit être unique dans le locataire, 1-90 caractères, lettres, chiffres et tirets autorisés
@minLength(1)
@maxLength(90)
param managementGroupId string

@description('Nom d\'affichage pour le groupe d\'administration')
param displayName string

@description('ID du groupe d\'administration parent (optionnel). Laisser vide pour créer un groupe d\'administration au niveau racine.')
param parentManagementGroupId string = ''

@description('IDs des abonnements à associer au groupe d\'administration')
param subscriptionIds array = []

// Management Group Resource
resource managementGroup 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupId
  properties: {
    displayName: displayName
    details: !empty(parentManagementGroupId)
      ? {
          parent: {
            id: tenantResourceId('Microsoft.Management/managementGroups', parentManagementGroupId)
          }
        }
      : {}
  }
}

// Associate subscriptions to management group
resource subscriptionAssociations 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [
  for subscriptionId in subscriptionIds: {
    parent: managementGroup
    name: subscriptionId
  }
]

// Outputs
@description('ID du groupe d\'administration')
output managementGroupId string = managementGroup.id

@description('Nom du groupe d\'administration')
output managementGroupName string = managementGroup.name

@description('Nom d\'affichage du groupe d\'administration')
output displayName string = managementGroup.properties.displayName
