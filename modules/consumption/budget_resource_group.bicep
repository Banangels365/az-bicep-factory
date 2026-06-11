// modules/consumption/budget_resource_group.bicep
// Budget Azure Consumption au scope Resource Group.

targetScope = 'resourceGroup'

@description('Nom du budget Azure Consumption.')
param name string

@description('Catégorie du budget. Cost suit les coûts réels, Usage suit la consommation.')
@allowed([
  'Cost'
  'Usage'
])
param category string = 'Cost'

@description('Montant total du budget à suivre.')
param amount int

@description('Période de réinitialisation du budget.')
@allowed([
  'Monthly'
  'Quarterly'
  'Annually'
  'BillingMonth'
  'BillingQuarter'
  'BillingAnnual'
])
param resetPeriod string = 'Monthly'

@description('Date de début du budget. La bonne pratique consiste à utiliser le premier jour du mois.')
param startDate string = '${utcNow('yyyy')}-${utcNow('MM')}-01T00:00:00Z'

@description('Date de fin du budget. Si vide, une date à 10 ans de la date de début est calculée.')
param endDate string = ''

@description('Opérateur de comparaison utilisé pour les notifications.')
@allowed([
  'EqualTo'
  'GreaterThan'
  'GreaterThanOrEqualTo'
])
param operator string = 'GreaterThan'

@description('Liste des seuils en pourcentage qui déclenchent des notifications.')
param thresholds array = [
  50
  75
  90
  100
  110
]

@description('Liste des adresses e-mail à notifier lorsque les seuils sont atteints ou dépassés.')
param contactEmails array = []

@description('Liste des rôles Azure à notifier lorsque les seuils sont atteints ou dépassés.')
param contactRoles array = []

@description('Liste des resource IDs d’Action Groups à notifier lorsque les seuils sont atteints ou dépassés.')
param actionGroups array = []

@description('Type de seuil utilisé pour les notifications.')
@allowed([
  'Actual'
  'Forecasted'
])
param thresholdType string = 'Actual'

@description('Filtre avancé du budget. Si renseigné, il est prioritaire sur resourceGroupFilter.')
param filter object = {}

@description('Liste des resource groups à inclure dans le budget lorsque aucun filtre avancé n’est fourni.')
param resourceGroupFilter array = []

var resolvedEndDate = !empty(endDate)
  ? endDate
  : '${string(int(substring(startDate, 0, 4)) + 10)}${substring(startDate, 4)}'

// Construction des notifications à partir des seuils fournis.

var notificationsArray = [
  for threshold in thresholds: {
    key: 'notification_${string(threshold)}'
    value: {
      enabled: true
      operator: operator
      threshold: threshold
      contactEmails: contactEmails
      contactRoles: contactRoles
      contactGroups: actionGroups
      thresholdType: thresholdType
    }
  }
]

var notifications = reduce(notificationsArray, {}, (cur, next) => union(cur, { '${next.key}': next.value }))

// Si un filtre avancé est fourni, il est utilisé tel quel.
// Sinon, on peut restreindre le budget à une liste de resource groups.
var resolvedFilter = !empty(filter)
  ? filter
  : !empty(resourceGroupFilter)
      ? {
          dimensions: {
            name: 'ResourceGroupName'
            operator: 'In'
            values: resourceGroupFilter
          }
        }
      : null

resource budget 'Microsoft.Consumption/budgets@2023-11-01' = {
  name: name
  properties: {
    category: category
    amount: amount
    timeGrain: resetPeriod
    timePeriod: {
      startDate: startDate
      endDate: resolvedEndDate
    }
    filter: resolvedFilter
    notifications: notifications
  }
}

@description('Nom du budget créé.')
output name string = budget.name

@description('ID de ressource du budget créé.')
output resourceId string = budget.id

@description('Nom du resource group cible.')
output resourceGroupName string = resourceGroup().name

@description('Scope effectif du budget.')
output scope string = resourceGroup().id

@description('Date de début effective du budget.')
output effectiveStartDate string = startDate

@description('Date de fin effective du budget.')
output effectiveEndDate string = resolvedEndDate
