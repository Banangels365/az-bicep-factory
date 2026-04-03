// platform-lz/main.bicep
// Orchestrateur Bicep pour le déploiement de la plateforme de base (landing zone) dans Azure.
// Ce template déploie la hiérarchie de groupes d'administration, crée les abonnements, associe les abonnements aux groupes de gestion, 
// et configure les ressources de base pour la plateforme (ex: RG de management, Log Analytics, etc.). 
// Il inclut également la définition de politiques personnalisées et d'initiatives, ainsi que leur assignation aux groupes de gestion appropriés.

targetScope = 'managementGroup'

@description('Organization name (used for naming)')
param organizationName string

@description('Environment')
@allowed([
  'prod' // production
  'logs' // logging/monitoring
  'quar' // quarantine
  'sbox' // sandbox
])
param environment string

@description('Azure region for resource deployment')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('billing scope ID for subscription creation')
param managementSubscriptionId string

@description('Liste des abonnements à créer')
param subscriptions array = []

@description('Tags to apply to all resources')
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  CostCenter: 'Platform'
  Owner: 'CloudOps'
}

@description('Platform Resource Group Name (for shared platform resources like Log Analytics, policies, etc.)')
param platformResourceGroupName string

@description('Liste des groupes de ressources à créer')
param resourceGroups array = []

// @description('Log Analytics retention in days')
// @minValue(30)
// @maxValue(730)
// param logRetentionDays int = 90

// @description('Enable Microsoft Sentinel')
// param enableSentinel bool = true

// @description('Subscription ID for platform management resources')
// param managementSubscriptionId string

// @description('Prod subscription IDs to associate')
// param prodSubscriptionIds array = []

// @description('Quarantine subscription IDs to associate')
// param quarantineSubscriptionIds array = []

// @description('Logging subscription IDs to associate')
// param loggingSubscriptionIds array = []

// Variables
var managementGroupPrefix = organizationName
// var resourceGroupName = 'rg-platform-management-${environment}'
// var logAnalyticsWorkspaceName = 'law-${organizationName}-platform-${environment}'

// ============================================
// MANAGEMENT GROUP HIERARCHY
// ============================================

// Root Management Group (Tenant Root Group is implicit)
module rootMg './modules/management_group.bicep' = {
  name: 'deploy-root-mg'
  scope: tenant()
  params: {
    managementGroupId: '${managementGroupPrefix}-root'
    displayName: '${organizationName} Root'
    parentManagementGroupId: 'Tenant Root Group' // Root management group ID (tenant root group)
    // description: 'Root management group for ${organizationName}'
  }
}

// Production Management Group
module prodMg './modules/management_group.bicep' = {
  name: 'deploy-prod-mg'
  scope: tenant()
  params: {
    managementGroupId: '${managementGroupPrefix}-prod'
    displayName: 'Production'
    parentManagementGroupId: '${managementGroupPrefix}-root'
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
//     managementGroupId: '${managementGroupPrefix}-dev'
//     displayName: 'Development'
//     parentManagementGroupId: '${managementGroupPrefix}-root'
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
    managementGroupId: '${managementGroupPrefix}-logging'
    displayName: 'Logging'
    parentManagementGroupId: '${managementGroupPrefix}-root'
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
    managementGroupId: '${managementGroupPrefix}-quarantine'
    displayName: 'Quarantine'
    parentManagementGroupId: '${managementGroupPrefix}-root'
  }
  dependsOn: [
    rootMg
  ]
}

// ============================================
// SUBSCRIPTION CREATION
// ============================================

module subscriptionsCreator './modules/subscription.bicep' = [
  for sub in subscriptions: {
    scope: tenant()
    params: {
      subscriptionAliasName: sub.alias
      subscriptionDisplayName: sub.displayName
      billingScope: sub.billingScope
      workload: sub.workload
    }
    dependsOn: [
      prodMg
    ]
  }
]

// ============================================
// SUBSCRIPTION TO MANAGEMENT GROUP ASSOCIATIONS
// ============================================

module subscriptionAssociations './modules/subscription_to_mg_association.bicep' = [
  for (sub, i) in subscriptions: {
    scope: tenant()
    params: {
      subscriptionId: subscriptionsCreator[i].outputs.subscriptionId
      managementGroupId: sub.mgId
    }
    dependsOn: [
      subscriptionsCreator[i]
    ]
  }
]

// ============================================
// RESOURCES GROUP CREATION
// ============================================

// Resource Group for Platform Management
module managementRg './modules/resource_group.bicep' = if (!empty(managementSubscriptionId)) {
  name: 'deploy-management-rg'
  scope: subscription(managementSubscriptionId)
  params: {
    resourceGroupName: platformResourceGroupName
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
  ]
}

module resourceGroupsCreator './modules/resource_group.bicep' = [
  for (rg, i) in resourceGroups: if (!empty(rg.subscriptionId)) {
    name: 'deploy-${rg.name}-rg'
    scope: subscription(rg.subscriptionId)
    params: {
      resourceGroupName: rg.name
      location: rg.location
      tags: rg.tags
    }
    dependsOn: [
      subscriptionsCreator[i]
    ]
  }
]

// module OperationsRg './platform-lz/resource-group/main.bicep' = if (!empty(prodSubscriptionId)) {
//   name: 'deploy-operations-rg'
//   scope: subscription(prodSubscriptionId)
//   params: {
//     resourceGroupName: 'rg-${environment}-${location}-operations'
//     location: location
//     tags: tags
//   }
//   dependsOn: [
//     rootMg
//     prodMg
//   ]
// }

// Note: RG creation for new subscriptions is commented out because subscription IDs are runtime outputs.
// To create RGs in new subscriptions, deploy them separately after subscription creation.
// Example: Use a separate Bicep template with scope subscription('<new-sub-id>') and call it post-deployment.

// Anciens modules RG (remplacés par la boucle ci-dessus)
// module NetworkingRg './platform-lz/resource-group/main.bicep' = if (!empty(prodSubscriptionId)) {
//   name: 'deploy-networking-rg'
//   scope: subscription(prodSubscriptionId)
//   params: {
//     resourceGroupName: 'rg-${environment}-${location}-networking'
//     location: location
//     tags: tags
//   }
//   dependsOn: [
//     rootMg
//     prodMg
//   ]
// }

// module IdentityRg './platform-lz/resource-group/main.bicep' = if (!empty(prodSubscriptionId)) {
//   name: 'deploy-identity-rg'
//   scope: subscription(prodSubscriptionId)
//   params: {
//     resourceGroupName: 'rg-${environment}-${location}-identity'
//     location: location
//     tags: tags
//   }
//   dependsOn: [
//     rootMg
//     prodMg
//   ]
// }

// module SecurityRg './platform-lz/resource-group/main.bicep' = if (!empty(prodSubscriptionId)) {
//   name: 'deploy-security-rg'
//   scope: subscription(prodSubscriptionId)
//   params: {
//     resourceGroupName: 'rg-${environment}-${location}-security'
//     location: location
//     tags: tags
//   }
//   dependsOn: [
//     rootMg
//     prodMg
//   ]
// }

// module OperationsRg './platform-lz/resource-group/main.bicep' = if (!empty(prodSubscriptionId)) {
//   name: 'deploy-operations-rg'
//   scope: subscription(prodSubscriptionId)
//   params: {
//     resourceGroupName: 'rg-${environment}-${location}-operations'
//     location: location
//     tags: tags
//   }
//   dependsOn: [
//     rootMg
//     prodMg
//   ]
// }

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

output subscriptions array = [
  for (sub, i) in subscriptions: {
    alias: sub.alias
    displayName: sub.displayName
    subscriptionId: subscriptionsCreator[i].outputs.subscriptionId
  }
]

output resourceGroupIds array = [
  for (rg, i) in resourceGroups: {
    name: rg.name
    subscriptionId: rg.subscriptionId
    resourceGroupId: resourceGroupsCreator[i].?outputs.resourceGroupId ?? ''
  }
]

output managementResourceGroupId string = managementRg.?outputs.resourceGroupId ?? ''

// output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId
// output logAnalyticsWorkspaceName string = logAnalytics.outputs.workspaceName
// output logAnalyticsCustomerId string = logAnalytics.outputs.customerId

// output policyInitiativeId string = lzBaselineInitiative.outputs.initiativeId
// output prodPolicyAssignmentId string = prodPolicyAssignment.outputs.assignmentId
// output devPolicyAssignmentId string = devPolicyAssignment.outputs.assignmentId
