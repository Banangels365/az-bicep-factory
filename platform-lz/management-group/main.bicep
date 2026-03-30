// platform-lz/management-group/main.bicep
// Management Group module for Azure Landing Zone hierarchy

targetScope = 'tenant'

@description('Management Group ID (unique identifier)')
@minLength(1)
@maxLength(90)
param managementGroupId string

@description('Display name for the management group')
param displayName string

@description('Parent Management Group ID (leave empty for root level)')
param parentManagementGroupId string = ''

// @description('Subscription IDs to associate with this management group')
// param subscriptionIds array = []

// Management Group Resource
resource managementGroup 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: managementGroupId
  properties: {
    displayName: displayName
    details: {
      parent: !empty(parentManagementGroupId)
        ? {
            id: tenantResourceId('Microsoft.Management/managementGroups', parentManagementGroupId)
          }
        : null
    }
  }
}

// Associate subscriptions to management group
// resource subscriptionAssociations 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [
//   for subscriptionId in subscriptionIds: {
//     parent: managementGroup
//     name: subscriptionId
//   }
// ]

// Outputs
@description('Management Group resource ID')
output managementGroupId string = managementGroup.id

@description('Management Group name')
output managementGroupName string = managementGroup.name

@description('Management Group display name')
output displayName string = managementGroup.properties.displayName
