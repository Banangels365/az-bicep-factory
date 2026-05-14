// platform-lz/platform.bicep
// Orchestrateur Bicep pour le déploiement de la plateforme de base (landing zone) dans Azure.
// Ce template déploie la hiérarchie de groupes d'administration, crée les abonnements, associe les abonnements aux groupes de gestion, 
// et configure les ressources de base pour la plateforme (ex: RG de management, Log Analytics, etc.). 
// Il inclut également la définition de politiques personnalisées et d'initiatives, ainsi que leur assignation aux groupes de gestion appropriés.

targetScope = 'managementGroup'

@description('Nom de l\'organisation')
param organizationName string

@description('Environnement')
@allowed([
  'prod' // production
  'dev' // development
  'logs' // logging/monitoring
  'quar' // quarantine
  'sbox' // sandbox
])
param environment string

@description('Région Azure pour les ressources de la plateforme. Valeurs possibles : cace (canadacentral), caea (canadaeast)')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('billing scope ID for subscription creation')
param managementSubscriptionId string

@description('Tags à appliquer aux ressources')
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  CostCenter: 'Platform'
  Owner: 'CloudOps'
}

// @description('Log Analytics retention in days')
// @minValue(30)
// @maxValue(730)
// param logRetentionDays int = 90

// @description('Enable Microsoft Sentinel')
// param enableSentinel bool = true

// Variables
// var logAnalyticsWorkspaceName = 'law-${organizationName}-platform-${environment}'

// ============================================
// MANAGEMENT GROUP HIERARCHY
// ============================================

// Root Management Group (Tenant Root Group is implicit)
module rootMg './modules/management_group.bicep' = {
  name: 'deploy-root-mg'
  scope: tenant()
  params: {
    managementGroupId: '${organizationName}-root'
    displayName: '${organizationName} Root'
    parentManagementGroupId: '' // Leave empty for root MG
    subscriptionIds: [] // No subscriptions directly under root MG
  }
}

// Production Management Group
module prodMg './modules/management_group.bicep' = {
  name: 'deploy-prod-mg'
  scope: tenant()
  params: {
    managementGroupId: '${organizationName}-prod'
    displayName: 'Production'
    parentManagementGroupId: '${organizationName}-root'
    subscriptionIds: [managementSubscriptionId] // Filter subscription IDs for prod MG
  }
  dependsOn: [
    rootMg
  ]
}

// Development Management Group
// module devMg './modules/management_group.bicep' = {
//   name: 'deploy-dev-mg'
//   scope: tenant()
//   params: {
//     managementGroupId: '${organizationName}-dev'
//     displayName: 'Development'
//     parentManagementGroupId: '${organizationName}-root'
//   }
//   dependsOn: [
//     rootMg
//   ]
// }

// Logging Management Group
module loggingMg './modules/management_group.bicep' = {
  name: 'deploy-logging-mg'
  scope: tenant()
  params: {
    managementGroupId: '${organizationName}-logging'
    displayName: 'Logging'
    parentManagementGroupId: '${organizationName}-root'
    subscriptionIds: [] // Filter subscription IDs for logging MG
  }
  dependsOn: [
    rootMg
  ]
}

// Quarantine Management Group
module quarantineMg './modules/management_group.bicep' = {
  name: 'deploy-quarantine-mg'
  scope: tenant()
  params: {
    managementGroupId: '${organizationName}-quarantine'
    displayName: 'Quarantine'
    parentManagementGroupId: '${organizationName}-root'
    subscriptionIds: [] // Filter subscription IDs for quarantine MG
  }
  dependsOn: [
    rootMg
  ]
}

// ============================================
// RESOURCES GROUP CREATION
// ============================================

// Resource Group for Platform Management Resources (e.g. Log Analytics, policies, etc.)
module managementRg './modules/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-management-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-management'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// Resource Groups for identity and access management (e.g. Privileged Identity Management, etc.)
module identityRg './modules/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-identity-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-identity'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// Resource Group for networking resources (e.g. Virtual Networks, Subnets, etc.)
module networkingRg './modules/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-networking-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-networking'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// Resource Group for Monitoring resources (e.g. Azure Monitor, Log Analytics, etc.)
module monitoringRg './modules/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-monitoring-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: 'rg-${organizationName}-${environment}-${location}-monitoring'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

// ============================================
// PLATFORM RESOURCES (Logging)
// ============================================

// Log Analytics Workspace
// module logAnalytics 'log-analytics-workspace/main.bicep' = {
//   name: 'deploy-log-analytics'
//   scope: resourceGroup(managementSubscriptionId, resourceGroupName)
//   params: {
//     workspaceName: logAnalyticsWorkspaceName
//     location: location
//     sku: 'PerGB2018'
//     retentionInDays: logRetentionDays
//     dailyQuotaGb: 0
//     enableSentinel: enableSentinel
//     solutions: [
//       'SecurityCenterFree'
//       'Updates'
//       'VMInsights'
//       'ChangeTracking'
//       'AzureActivity'
//       'AgentHealthAssessment'
//     ]
//     tags: tags
//   }
//   dependsOn: [
//     managementRg
//   ]
// }

// ============================================
// POLICY DEFINITIONS
// ============================================

// Custom Policy: Require tags on resources
// module requireTagsPolicy 'policy-definition/main.bicep' = {
//   name: 'deploy-require-tags-policy'
//   scope: managementGroup('${managementGroupPrefix}-root')
//   params: {
//     policyName: 'require-mandatory-tags'
//     displayName: 'Require mandatory tags on resources'
//     policyDescription: 'Enforces the existence of mandatory tags on all resources'
//     mode: 'Indexed'
//     metadata: {
//       version: '1.0.0'
//       category: 'Tags'
//     }
//     parameters: {
//       tagNames: {
//         type: 'Array'
//         metadata: {
//           displayName: 'Tag Names'
//           description: 'List of mandatory tag names'
//         }
//       }
//     }
//     policyRule: {
//       if: {
//         anyOf: [
//           {
//             field: 'tags'
//             exists: false
//           }
//           {
//             count: {
//               field: 'tags[*]'
//               where: {
//                 field: 'tags[*]'
//                 in: '[parameters(\'tagNames\')]'
//               }
//             }
//             less: '[length(parameters(\'tagNames\'))]'
//           }
//         ]
//       }
//       then: {
//         effect: 'deny'
//       }
//     }
//   }
//   dependsOn: [
//     rootMg
//   ]
// }

// Custom Policy: Allowed locations
// module allowedLocationsPolicy 'policy-definition/main.bicep' = {
//   name: 'deploy-allowed-locations-policy'
//   scope: managementGroup('${managementGroupPrefix}-root')
//   params: {
//     policyName: 'allowed-locations-custom'
//     displayName: 'Allowed locations for resources'
//     policyDescription: 'Restricts resource deployment to specific Azure regions'
//     mode: 'Indexed'
//     metadata: {
//       version: '1.0.0'
//       category: 'General'
//     }
//     parameters: {
//       allowedLocations: {
//         type: 'Array'
//         metadata: {
//           displayName: 'Allowed locations'
//           description: 'The list of allowed locations for resources'
//           strongType: 'location'
//         }
//       }
//     }
//     policyRule: {
//       if: {
//         allOf: [
//           {
//             field: 'location'
//             notIn: '[parameters(\'allowedLocations\')]'
//           }
//           {
//             field: 'type'
//             notEquals: 'Microsoft.AzureActiveDirectory/b2cDirectories'
//           }
//         ]
//       }
//       then: {
//         effect: 'deny'
//       }
//     }
//   }
//   dependsOn: [
//     rootMg
//   ]
// }

// ============================================
// POLICY INITIATIVE (Policy Set)
// ============================================

// Landing Zone Baseline Initiative
// module lzBaselineInitiative 'policy-initiative/main.bicep' = {
//   name: 'deploy-lz-baseline-initiative'
//   scope: managementGroup('${managementGroupPrefix}-root')
//   params: {
//     initiativeName: 'landing-zone-baseline'
//     displayName: 'Landing Zone Baseline Policies'
//     initiativeDescription: 'Baseline security and governance policies for landing zones'
//     metadata: {
//       version: '1.0.0'
//       category: 'Landing Zone'
//     }
//     parameters: {
//       allowedLocations: {
//         type: 'Array'
//         metadata: {
//           displayName: 'Allowed locations'
//           description: 'The list of allowed locations for resources'
//         }
//         defaultValue: [
//           'canadacentral'
//           'canadaeast'
//         ]
//       }
//       tagNames: {
//         type: 'Array'
//         metadata: {
//           displayName: 'Required tag names'
//           description: 'List of mandatory tags'
//         }
//         defaultValue: [
//           'Environment'
//           'CostCenter'
//           'Owner'
//         ]
//       }
//     }
//     policyDefinitions: [
//       {
//         policyDefinitionId: requireTagsPolicy.outputs.policyDefinitionId
//         parameters: {
//           tagNames: {
//             value: '[parameters(\'tagNames\')]'
//           }
//         }
//         groupNames: []
//       }
//       {
//         policyDefinitionId: allowedLocationsPolicy.outputs.policyDefinitionId
//         parameters: {
//           allowedLocations: {
//             value: '[parameters(\'allowedLocations\')]'
//           }
//         }
//         groupNames: []
//       }
//       {
//         policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a914e76-4921-4c19-b460-a2d36003525a'
//         parameters: {}
//         groupNames: []
//       }
//     ]
//   }
//   dependsOn: [
//     // requireTagsPolicy
//     // allowedLocationsPolicy
//   ]
// }

// ============================================
// POLICY ASSIGNMENTS
// ============================================

// Assign baseline policies to Production Landing Zone
// module prodPolicyAssignment 'policy-assignment/main.bicep' = {
//   name: 'deploy-prod-policy-assignment'
//   scope: managementGroup('${managementGroupPrefix}-prod')
//   params: {
//     assignmentName: 'prod-baseline-policies'
//     displayName: 'Production Baseline Policies'
//     assignmentDescription: 'Baseline policies for production workloads'
//     policyDefinitionId: lzBaselineInitiative.outputs.initiativeId
//     identityType: 'SystemAssigned'
//     location: location
//     enforcementMode: 'Default'
//     parameters: {
//       allowedLocations: {
//         value: [
//           'canadacentral'
//           'canadaeast'
//         ]
//       }
//       tagNames: {
//         value: [
//           'Environment'
//           'CostCenter'
//           'Owner'
//           'ApplicationId'
//         ]
//       }
//     }
//     nonComplianceMessages: [
//       {
//         message: 'Resources must comply with production baseline policies'
//       }
//     ]
//   }
//   dependsOn: [
//     prodMg
//     lzBaselineInitiative
//   ]
// }

// Assign baseline policies to Dev/Staging (audit mode)
// module devPolicyAssignment 'policy-assignment/main.bicep' = {
//   name: 'deploy-dev-policy-assignment'
//   scope: managementGroup('${managementGroupPrefix}-dev')
//   params: {
//     assignmentName: 'dev-baseline-policies'
//     displayName: 'Development Baseline Policies'
//     assignmentDescription: 'Baseline policies for development workloads (audit only)'
//     policyDefinitionId: lzBaselineInitiative.outputs.initiativeId
//     identityType: 'SystemAssigned'
//     location: location
//     enforcementMode: 'DoNotEnforce'
//     parameters: {
//       allowedLocations: {
//         value: [
//           'canadacentral'
//           'canadaeast'
//         ]
//       }
//       tagNames: {
//         value: [
//           'Environment'
//           'CostCenter'
//         ]
//       }
//     }
//   }
//   dependsOn: [
//     devMg
//     // lzBaselineInitiative
//   ]
// }

// ============================================
// OUTPUTS
// ============================================

output managementGroupIds object = {
  root: rootMg.outputs.managementGroupId
  prod: prodMg.outputs.managementGroupId
  logging: loggingMg.outputs.managementGroupId
  quarantine: quarantineMg.outputs.managementGroupId
}

output managementResourceGroupId string = managementRg.?outputs.resourceGroupId ?? ''

// output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId
// output logAnalyticsWorkspaceName string = logAnalytics.outputs.workspaceName
// output logAnalyticsCustomerId string = logAnalytics.outputs.customerId

// output policyInitiativeId string = lzBaselineInitiative.outputs.initiativeId
// output prodPolicyAssignmentId string = prodPolicyAssignment.outputs.assignmentId
// output devPolicyAssignmentId string = devPolicyAssignment.outputs.assignmentId
