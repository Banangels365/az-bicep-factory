// modules/storage/types.bicep
// Ce fichier définit les types personnalisés utilisés dans les modules de stockage, notamment pour les affectations de rôles. 
// Ces types permettent de structurer les données et de faciliter la réutilisation dans les différents modules de stockage. 

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
