// identity-lz/modules/custom_role_definition.bicep
// Custom RBAC Role Definition module

targetScope = 'subscription'

@description('Nom du rôle personnalisé')
param roleName string

@description('Identifiant stable pour ce rôle (utilisé pour générer le GUID — ne pas changer après déploiement)')
param roleId string = roleName // peut être un UUID fixe passé explicitement

@description('Description du rôle personnalisé')
param customRoleDescription string

@description('Actions autorisées par ce rôle')
param actions array

@description('Actions non autorisées par ce rôle')
param notActions array = []

@description('Données actions autorisées par ce rôle')
param dataActions array = []

@description('Données actions non autorisées par ce rôle')
param notDataActions array = []

@description('Périmètres d\'affectation pour ce rôle (ex: subscription, resource group, etc.)')
param assignableScopes array = [
  subscription().id
]

// Custom Role Definition Resource
resource customRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(subscription().id, roleId)
  properties: {
    roleName: roleName
    description: customRoleDescription
    permissions: [
      {
        actions: actions
        notActions: notActions
        dataActions: dataActions
        notDataActions: notDataActions
      }
    ]
    assignableScopes: assignableScopes
  }
}

// Outputs
@description('ID du rôle personnalisé')
output roleDefinitionId string = customRole.id

@description('Nom de la définition de rôle personnalisé (GUID)')
output roleDefinitionName string = customRole.name

@description('Nom d\'affichage du rôle personnalisé')
output roleName string = customRole.properties.roleName
