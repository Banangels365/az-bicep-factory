// modules/sql/types.bicep

@export()
type roleAssignmentType = {
  name: string?
  principalId: string
  roleDefinitionId: string
  principalType: ('User' | 'Group' | 'ServicePrincipal' | 'ForeignGroup' | 'Device')?
  description: string?
  condition: string?
  conditionVersion: '2.0'?
  delegatedManagedIdentityResourceId: string?
}

@export()
type lockType = {
  name: string?
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
  notes: string?
}

@export()
type diagnosticSettingType = {
  name: string?
  workspaceResourceId: string?
  storageAccountResourceId: string?
  eventHubAuthorizationRuleResourceId: string?
  eventHubName: string?
  marketplacePartnerResourceId: string?
  logAnalyticsDestinationType: string?
  logCategoriesAndGroups: array?
  metricCategories: array?
}

@export()
type externalAdministratorType = {
  administratorType: 'ActiveDirectory'?
  azureADOnlyAuthentication: bool
  login: string
  principalType: ('Application' | 'Group' | 'User')
  sid: string
  tenantId: string?
}
