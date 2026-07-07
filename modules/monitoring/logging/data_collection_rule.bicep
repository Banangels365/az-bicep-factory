// modules/monitoring/logging/data_collection_rule.bicep
// Déploie une Data Collection Rule (DCR) Azure Monitor.
//
// Important : lorsque kind = 'All', la ressource DCR ne doit pas définir explicitement la propriété top-level kind.

targetScope = 'resourceGroup'

@description('Nom de la Data Collection Rule.')
param name string

@description('Propriétés complètes de la Data Collection Rule. L\'objet doit contenir au minimum kind et les blocs requis pour ce type de DCR.')
param dataCollectionRuleProperties object

@description('Région de déploiement. Par défaut, la région du resource group.')
param location string = resourceGroup().location

@description('Identités managées à affecter à la DCR. Exemple : { systemAssigned: true, userAssignedResourceIds: [] }.')
param managedIdentities object = {}

@description('Tags à appliquer à la ressource.')
param tags object = {}

@description('Paramètres de verrouillage de la ressource.')
param lock object = {}

// Variables

var formattedUserAssignedIdentities = reduce(
  map(managedIdentities.?userAssignedResourceIds ?? [], id => {
    '${id}': {}
  }),
  {},
  (cur, next) => union(cur, next)
)

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var dataCollectionRulePropertiesUnion = union(
  !empty(dataCollectionRuleProperties.?description ?? '')
    ? {
        description: dataCollectionRuleProperties.description
      }
    : {},
  contains(
      [
        'Linux'
        'Windows'
        'All'
        'PlatformTelemetry'
      ],
      dataCollectionRuleProperties.kind
    )
    ? {
        dataSources: dataCollectionRuleProperties.dataSources
      }
    : {},
  contains(
      [
        'Linux'
        'Windows'
        'All'
        'Direct'
        'WorkspaceTransforms'
        'PlatformTelemetry'
      ],
      dataCollectionRuleProperties.kind
    )
    ? {
        dataFlows: dataCollectionRuleProperties.dataFlows
        destinations: dataCollectionRuleProperties.destinations
      }
    : {},
  contains(
      [
        'Linux'
        'Windows'
        'All'
        'Direct'
        'WorkspaceTransforms'
      ],
      dataCollectionRuleProperties.kind
    ) && !empty(dataCollectionRuleProperties.?dataCollectionEndpointResourceId ?? '')
    ? {
        dataCollectionEndpointId: dataCollectionRuleProperties.dataCollectionEndpointResourceId
      }
    : {},
  contains(
      [
        'Linux'
        'Windows'
        'All'
        'Direct'
      ],
      dataCollectionRuleProperties.kind
    ) && !empty(dataCollectionRuleProperties.?streamDeclarations ?? {})
    ? {
        streamDeclarations: dataCollectionRuleProperties.streamDeclarations
      }
    : {},
  dataCollectionRuleProperties.kind == 'AgentSettings'
    ? {
        agentSettings: dataCollectionRuleProperties.agentSettings
      }
    : {}
)

// Création des ressources

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2024-03-11' = if (dataCollectionRuleProperties.kind != 'All') {
  name: name
  location: location
  kind: dataCollectionRuleProperties.kind
  tags: tags
  identity: identity
  properties: dataCollectionRulePropertiesUnion
}

resource dataCollectionRuleAll 'Microsoft.Insights/dataCollectionRules@2024-03-11' = if (dataCollectionRuleProperties.kind == 'All') {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: dataCollectionRulePropertiesUnion
}

resource dataCollectionRuleLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock) && lock.?kind != 'None' && dataCollectionRuleProperties.kind != 'All') {
  name: lock.?name ?? '${name}-lock'
  scope: dataCollectionRule
  properties: {
    level: lock.kind
    notes: lock.?notes ?? (lock.kind == 'CanNotDelete'
      ? 'Cannot delete the resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

resource dataCollectionRuleAllLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock) && lock.?kind != 'None' && dataCollectionRuleProperties.kind == 'All') {
  name: lock.?name ?? '${name}-lock'
  scope: dataCollectionRuleAll
  properties: {
    level: lock.kind
    notes: lock.?notes ?? (lock.kind == 'CanNotDelete'
      ? 'Cannot delete the resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

// Outputs

@description('Nom de la Data Collection Rule créée.')
output name string = dataCollectionRuleProperties.kind == 'All' ? dataCollectionRuleAll.name : dataCollectionRule.name

@description('ID de ressource de la Data Collection Rule créée.')
output resourceId string = dataCollectionRuleProperties.kind == 'All' ? dataCollectionRuleAll.id : dataCollectionRule.id

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name

@description('Localisation de la Data Collection Rule.')
output location string = dataCollectionRuleProperties.kind == 'All'
  ? (dataCollectionRuleAll.?location ?? location)
  : (dataCollectionRule.?location ?? location)

@description('Principal ID de l\'identité managée système si activée.')
output systemAssignedMIPrincipalId string = dataCollectionRuleProperties.kind == 'All'
  ? (dataCollectionRuleAll.?identity.?principalId ?? '')
  : (dataCollectionRule.?identity.?principalId ?? '')

@description('Endpoints exposés par la Data Collection Rule lorsque disponibles.')
output endpoints object = dataCollectionRuleProperties.kind == 'All'
  ? (dataCollectionRuleAll.?properties.?endpoints ?? {})
  : (dataCollectionRule.?properties.?endpoints ?? {})

@description('Immutable ID de la Data Collection Rule lorsque disponible.')
output immutableId string = dataCollectionRuleProperties.kind == 'All'
  ? (dataCollectionRuleAll.?properties.?immutableId ?? '')
  : (dataCollectionRule.?properties.?immutableId ?? '')
