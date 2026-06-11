// workload-lz/modules/avd/scaling_plan.bicep
// Azure Virtual Desktop — Scaling Plan
// Permet de définir des règles d'auto-scaling pour les Host Pools AVD, en fonction de planifications et de conditions spécifiques. 
// Le scaling plan aide à optimiser les coûts et les performances en ajustant dynamiquement le nombre de machines virtuelles en fonction de la demande.

targetScope = 'resourceGroup'

@description('Nom du plan de mise à l\'échelle.')
param name string

@description('Région Azure du plan de mise à l\'échelle. Par défaut : région du resource group.')
param location string = resourceGroup().location

@description('Nom convivial du plan de mise à l\'échelle.')
param friendlyName string = name

@description('Description du plan de mise à l\'échelle.')
param scalingPlanDescription string = ''

@description('Fuseau horaire du plan de mise à l\'échelle.')
param timeZone string = 'Eastern Standard Time'

@description('Type de Host Pool ciblé par le plan de mise à l\'échelle.')
@allowed([
  'Pooled'
  'Personal'
])
param hostPoolType string = 'Pooled'

@description('Tag d\'exclusion. Les VMs portant ce tag sont exclues du scaling.')
param exclusionTag string = 'ScalingPlanExclusion'

@description('Références des Host Pools associés au plan de mise à l\'échelle. Chaque entrée : hostPoolResourceId, scalingPlanEnabled?')
param hostPoolReferences array = []

@description('Planifications du scaling plan. Si vide, une planification par défaut est appliquée.')
param schedules array = []

@description('Tags à appliquer à la ressource.')
param tags object = {}

@description('Liste des paramètres de diagnostic à créer sur le scaling plan.')
param diagnosticSettings array = []

var defaultSchedules = [
  {
    name: 'WorkWeek'
    daysOfWeek: [
      'Monday'
      'Tuesday'
      'Wednesday'
      'Thursday'
      'Friday'
    ]
    rampUpStartTime: {
      hour: 7
      minute: 0
    }
    rampUpLoadBalancingAlgorithm: 'BreadthFirst'
    rampUpMinimumHostsPct: 20
    rampUpCapacityThresholdPct: 60
    peakStartTime: {
      hour: 9
      minute: 0
    }
    peakLoadBalancingAlgorithm: 'BreadthFirst'
    rampDownStartTime: {
      hour: 18
      minute: 0
    }
    rampDownLoadBalancingAlgorithm: 'DepthFirst'
    rampDownMinimumHostsPct: 10
    rampDownCapacityThresholdPct: 90
    rampDownForceLogoffUsers: false
    rampDownWaitTimeMinutes: 30
    rampDownNotificationMessage: 'La session se terminera dans 30 minutes. Veuillez sauvegarder votre travail.'
    offPeakStartTime: {
      hour: 20
      minute: 0
    }
    offPeakLoadBalancingAlgorithm: 'DepthFirst'
  }
]

var effectiveSchedules = !empty(schedules) ? schedules : defaultSchedules

var effectiveHostPoolReferences = [
  for hostPoolRef in hostPoolReferences: {
    hostPoolArmPath: hostPoolRef.hostPoolResourceId
    scalingPlanEnabled: hostPoolRef.?scalingPlanEnabled ?? true
  }
]

resource scalingPlan 'Microsoft.DesktopVirtualization/scalingPlans@2025-03-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: union(
    {
      friendlyName: friendlyName
      description: scalingPlanDescription
      timeZone: timeZone
      hostPoolType: hostPoolType
      schedules: effectiveSchedules
      hostPoolReferences: effectiveHostPoolReferences
    },
    !empty(exclusionTag) ? { exclusionTag: exclusionTag } : {}
  )
}

resource scalingPlanDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in diagnosticSettings: {
    name: !empty(diagnosticSetting.?name) ? diagnosticSetting.name : '${name}-diag-${index + 1}'
    scope: scalingPlan
    properties: {
      workspaceId: diagnosticSetting.?workspaceResourceId
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
      logs: [
        for logItem in (empty(diagnosticSetting.?logCategoriesAndGroups)
          ? [
              {
                categoryGroup: 'allLogs'
                enabled: true
              }
            ]
          : diagnosticSetting.logCategoriesAndGroups): {
          category: logItem.?category
          categoryGroup: logItem.?categoryGroup
          enabled: logItem.?enabled ?? true
        }
      ]
    }
  }
]

var hostPoolReferenceIds = [for ref in effectiveHostPoolReferences: ref.hostPoolArmPath]
var scheduleNames = [for schedule in effectiveSchedules: schedule.name]

@description('Resource ID du plan de mise à l\'échelle.')
output resourceId string = scalingPlan.id

@description('Nom du plan de mise à l\'échelle.')
output scalingPlanName string = scalingPlan.name

@description('Région du plan de mise à l\'échelle.')
output scalingPlanLocation string = scalingPlan.location

@description('Fuseau horaire du plan de mise à l\'échelle.')
output scalingPlanTimeZone string = scalingPlan.properties.timeZone

@description('Type de Host Pool ciblé par le plan.')
output scalingPlanHostPoolType string = scalingPlan.properties.hostPoolType

@description('Références des Host Pools associés au plan.')
output scalingPlanHostPoolReferences array = hostPoolReferenceIds

@description('Noms des schedules configurés.')
output scalingPlanScheduleNames array = scheduleNames
