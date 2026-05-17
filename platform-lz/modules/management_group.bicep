// platform-lz/modules/management_group.bicep
// Module de création de Management Group pour Azure Landing Zone

targetScope = 'tenant'

@description('ID du groupe d\'administration (1-90 caractères, lettres, chiffres, tirets)')
@minLength(1)
@maxLength(90)
param managementGroupId string

@description('Nom d\'affichage pour le groupe d\'administration')
param displayName string

@description('ID du groupe d\'administration parent (optionnel). Laisser vide pour créer au niveau racine.')
param parentManagementGroupId string = ''

@description('Liste des abonnements à associer au groupe d\'administration')
param subscriptionIds array = []

// ======================================================================
// 1) Création du Management Group
// ======================================================================
resource managementGroup 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupId
  properties: {
    displayName: displayName

    // L'objet "details" doit être entièrement conditionnel
    details: empty(parentManagementGroupId)
      ? null
      : {
          parent: {
            id: tenantResourceId('Microsoft.Management/managementGroups', parentManagementGroupId)
          }
        }
  }
}

// ======================================================================
// 2) Association des abonnements au Management Group
// ======================================================================
resource subscriptionAssociations 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [
  for subscriptionId in subscriptionIds: {
    parent: managementGroup
    name: subscriptionId
  }
]

// ======================================================================
// 3) Sorties
// ======================================================================
@description('ID du groupe d\'administration')
output managementGroupId string = managementGroup.id

@description('Nom du groupe d\'administration')
output managementGroupName string = managementGroup.name

@description('Nom d\'affichage du groupe d\'administration')
output displayName string = managementGroup.properties.displayName
