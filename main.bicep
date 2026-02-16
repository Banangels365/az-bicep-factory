// az-platform-lz/main.bicep
// Main orchestrator for Azure Landing Zone Platform deployment

targetScope = 'managementGroup'

@description('Organization name (used for naming)')
param organizationName string = 'ACMY'

@description('Azure region for platform resources')
@allowed([
  'canadacentral'
  'canadaeast'
  'eastus'
  'westus'
])
param location string = 'canadacentral'

@description('Environment (used for tagging and naming)')
@allowed([
  'prod'
  'dev'
  'logging'
  'quarantine'
])
param environment string = 'prod'

@description('billing scope ID for subscription creation')
param managementSubscriptionId string

@description('Production subscription ID for resources')
param prodSubscriptionId string = ''

@description('Tags to apply to all resources')
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
// var logAnalyticsWorkspaceName = 'law-${organizationName}-platform-${environment}'
// var resourceGroupName = 'rg-platform-management-${environment}'

// ============================================
// MANAGEMENT GROUP HIERARCHY
// ============================================

// Root Management Group (Tenant Root Group is implicit)
module rootMg 'management-group/main.bicep' = {
  name: 'lab-root-mg'
  scope: tenant()
  params: {
    managementGroupId: '${managementGroupPrefix}-root'
    displayName: '${organizationName} Root'
    // description: 'Root management group for ${organizationName}'
  }
}

// Platform Management Group
// module platformMg 'management-group/main.bicep' = {
//   name: 'lab-platform-mg'
//   scope: tenant()
//   params: {
//     managementGroupId: '${managementGroupPrefix}-platform'
//     displayName: 'Lab-Platform'
//     parentManagementGroupId: '${managementGroupPrefix}-root'
//     //parentManagementGroupId: rootMg.outputs.managementGroupId
//     // description: 'Management group for platform resources (management, identity, connectivity)'
//   }
//   dependsOn: [
//     rootMg
//   ]
// }

// Landing Zones Management Group
// module landingZonesMg 'management-group/main.bicep' = {
//   name: 'deploy-landing-zones-mg'
//   scope: tenant()
//   params: {
//     managementGroupId: '${managementGroupPrefix}-landing-zones'
//     displayName: 'Landing Zones'
//     parentManagementGroupId: '${managementGroupPrefix}-root'
//     // description: 'Management group for application landing zones'
//   }
//   dependsOn: [
//     rootMg
//   ]
// }

// Production Management Group
module prodMg 'management-group/main.bicep' = {
  name: 'Lab-prod-mg'
  scope: tenant()
  params: {
    managementGroupId: '${managementGroupPrefix}-prod'
    displayName: 'Production'
    parentManagementGroupId: '${managementGroupPrefix}-root'
    // subscriptionIds: prodSubscriptionIds
    // description: 'Management group for production workloads'
  }
  dependsOn: [
    rootMg
  ]
}

// Development Management Group
module devMg 'management-group/main.bicep' = {
  name: 'Lab-dev-mg'
  scope: tenant()
  params: {
    managementGroupId: '${managementGroupPrefix}-dev'
    displayName: 'Development'
    parentManagementGroupId: '${managementGroupPrefix}-root'
    // subscriptionIds: prodSubscriptionIds
    // description: 'Management group for development workloads'
  }
  dependsOn: [
    rootMg
  ]
}

// Logging Management Group
module loggingMg 'management-group/main.bicep' = {
  name: 'Lab-logging-mg'
  scope: tenant()
  params: {
    managementGroupId: '${managementGroupPrefix}-logging'
    displayName: 'Logging'
    parentManagementGroupId: '${managementGroupPrefix}-root'
    // description: 'Management group for sandbox/experimentation workloads'
  }
  dependsOn: [
    rootMg
  ]
}

// Quarantine Management Group
module quarantineMg 'management-group/main.bicep' = {
  name: 'Lab-quarantine-mg'
  scope: tenant()
  params: {
    managementGroupId: '${managementGroupPrefix}-quarantine'
    displayName: 'Quarantine'
    parentManagementGroupId: '${managementGroupPrefix}-root'
    // description: 'Management group for quarantine resources'
  }
  dependsOn: [
    rootMg
  ]
}

// ============================================
// SUBSCRIPTION CREATION
// ============================================
module prodSubscription_1 'subscription/main.bicep' = {
  name: 'deploy-prod-subscription-01'
  scope: tenant()
  params: {
    subscriptionAliasName: 'sub-prod-${organizationName}-01'
    subscriptionDisplayName: '${organizationName} Production Subscription 01'
    billingScope: managementSubscriptionId
    workload: 'Prod'
  }
  dependsOn: [
    prodMg
  ]
}

module prodSubscription_2 'subscription/main.bicep' = {
  name: 'deploy-prod-subscription-02'
  scope: tenant()
  params: {
    subscriptionAliasName: 'sub-prod-${organizationName}-02'
    subscriptionDisplayName: '${organizationName} Production Subscription 02'
    billingScope: managementSubscriptionId
    workload: 'Prod'
  }
  dependsOn: [
    prodMg
  ]
}

module loggingSubscription 'subscription/main.bicep' = {
  name: 'deploy-logging-subscription'
  scope: tenant()
  params: {
    subscriptionAliasName: 'sub-logging-${organizationName}'
    subscriptionDisplayName: '${organizationName} Logging Subscription'
    billingScope: managementSubscriptionId
    workload: 'Logging'
  }
  dependsOn: [
    loggingMg
  ]
}

// ============================================
// SUBSCRIPTION TO MANAGEMENT GROUP ASSOCIATIONS
// ============================================

module prodSubscriptionAssociation_1 'subscription/subscription-to-mg-association.bicep' = {
  name: 'associate-prod-subscription-01'
  scope: tenant()
  params: {
    subscriptionId: prodSubscription_1.outputs.subscriptionId
    managementGroupId: prodMg.outputs.managementGroupId
  }
  dependsOn: [
    // prodSubscription_1
    // prodMg
  ]
}

module prodSubscriptionAssociation_2 'subscription/subscription-to-mg-association.bicep' = {
  name: 'associate-prod-subscription-02'
  scope: tenant()
  params: {
    subscriptionId: prodSubscription_2.outputs.subscriptionId
    managementGroupId: prodMg.outputs.managementGroupId
  }
  dependsOn: [
    // prodSubscription_2
    // prodMg
  ]
}

module loggingSubscriptionAssociation 'subscription/subscription-to-mg-association.bicep' = {
  name: 'associate-logging-subscription'
  scope: tenant()
  params: {
    subscriptionId: loggingSubscription.outputs.subscriptionId
    managementGroupId: loggingMg.outputs.managementGroupId
  }
  dependsOn: [
    // loggingSubscription
    // loggingMg
  ]
}

// ============================================
// RESOURCES GROUP CREATION
// ============================================

module NetworkingRg 'resource-group/main.bicep' = if (!empty(prodSubscriptionId)) {
  name: 'deploy-networking-rg'
  scope: subscription(prodSubscriptionId)
  params: {
    resourceGroupName: 'rg-${environment}-${location}-networking'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
    prodMg
  ]
}

module IdentityRg 'resource-group/main.bicep' = if (!empty(prodSubscriptionId)) {
  name: 'deploy-identity-rg'
  scope: subscription(prodSubscriptionId)
  params: {
    resourceGroupName: 'rg-${environment}-${location}-identity'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
    prodMg
  ]
}

module SecurityRg 'resource-group/main.bicep' = if (!empty(prodSubscriptionId)) {
  name: 'deploy-security-rg'
  scope: subscription(prodSubscriptionId)
  params: {
    resourceGroupName: 'rg-${environment}-${location}-security'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
    prodMg
  ]
}

module OperationsRg 'resource-group/main.bicep' = if (!empty(prodSubscriptionId)) {
  name: 'deploy-operations-rg'
  scope: subscription(prodSubscriptionId)
  params: {
    resourceGroupName: 'rg-${environment}-${location}-operations'
    location: location
    tags: tags
  }
  dependsOn: [
    rootMg
    prodMg
  ]
}

// ============================================
// PLATFORM RESOURCES (Logging)
// ============================================

// Resource Group for Platform Management
// module managementRg 'br/public:avm/res/resources/resource-group:0.2.3' = {
//   name: 'deploy-management-rg'
//   scope: subscription(managementSubscriptionId)
//   params: {
//     name: resourceGroupName
//     location: location
//     tags: tags
//   }
// }

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
  dev: devMg.outputs.managementGroupId
  logging: loggingMg.outputs.managementGroupId
  quarantine: quarantineMg.outputs.managementGroupId
}

// output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId
// output logAnalyticsWorkspaceName string = logAnalytics.outputs.workspaceName
// output logAnalyticsCustomerId string = logAnalytics.outputs.customerId

// output policyInitiativeId string = lzBaselineInitiative.outputs.initiativeId
// output prodPolicyAssignmentId string = prodPolicyAssignment.outputs.assignmentId
// output devPolicyAssignmentId string = devPolicyAssignment.outputs.assignmentId
