// modules/compute/proximity_placement_group.bicep
// Déploie un Azure Proximity Placement Group (PPG).

targetScope = 'resourceGroup'

@description('Nom du Proximity Placement Group.')
param name string

@description('Région de déploiement. Par défaut, la région du resource group.')
param location string = resourceGroup().location

@description('Type de Proximity Placement Group. Ultra peut être utilisé pour certains scénarios plus exigeants en performance.')
@allowed([
  'Standard'
  'Ultra'
])
param type string = 'Standard'

@description('Zone de disponibilité logique du Proximity Placement Group. Utiliser -1 pour ne pas définir de zone. Les valeurs 1, 2 ou 3 correspondent aux zones logiques de la souscription.')
@allowed([
  -1
  1
  2
  3
])
param availabilityZone int = -1

@description('Intent utilisateur du Proximity Placement Group. Permet de décrire les usages prévus de colocalisation. Laisser vide si non utilisé.')
param intent object = {}

@description('État ou informations de colocalisation à appliquer. Ce paramètre est rarement nécessaire dans les déploiements classiques et peut rester vide.')
param colocationStatus object = {}

@description('Tags à appliquer à la ressource.')
param tags object = {}

@description('Paramètres de verrouillage de la ressource.') // Exemple : { kind: ''CanNotDelete'', name: ''lock-ppg'', notes: ''Protection PPG'' }.
param lock object = {}

// Création du Proximity Placement Group

resource proximityPlacementGroup 'Microsoft.Compute/proximityPlacementGroups@2024-11-01' = {
  name: name
  location: location
  tags: tags
  zones: availabilityZone != -1
    ? [
        '${availabilityZone}'
      ]
    : null
  properties: {
    proximityPlacementGroupType: type
    colocationStatus: !empty(colocationStatus) ? colocationStatus : null
    intent: !empty(intent) ? intent : null
  }
}

resource proximityPlacementGroupLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock) && lock.?kind != 'None') {
  name: lock.?name ?? '${name}-lock'
  scope: proximityPlacementGroup
  properties: {
    level: lock.kind
    notes: lock.?notes ?? (lock.kind == 'CanNotDelete'
      ? 'Cannot delete the resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

// Outputs

@description('Nom du Proximity Placement Group créé.')
output name string = proximityPlacementGroup.name

@description('ID de ressource du Proximity Placement Group créé.')
output resourceId string = proximityPlacementGroup.id

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name

@description('Localisation du Proximity Placement Group.')
output location string = proximityPlacementGroup.location

@description('Type effectif du Proximity Placement Group.')
output proximityPlacementGroupType string = proximityPlacementGroup.properties.proximityPlacementGroupType

@description('Zone logique effectivement appliquée au Proximity Placement Group. Retourne -1 si aucune zone n’est définie.')
output effectiveAvailabilityZone int = availabilityZone
