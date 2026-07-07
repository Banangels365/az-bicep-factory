using '01-Tag.bicep'

// Liste des
param initiativeCustomPoliciesName = '01-Tag'
param initiativeCustomPoliciesDisplayName = '01-Tag'
param initiativeBuiltinPoliciesName = '01-Tag-Assignment'
param initiativeBuiltinPoliciesDisplayName = '01-Tag-Assignment'


/*
Liste des policies custom pour les tags
On peut ajouter autant de tags que nécessaire dans cette liste, avec les propriétés suivantes :
- name : le nom interne de la policy definition (sera utilisé dans l'initiative)
- displayName : le nom affiché de la policy definition  (sera affiché dans le portail Azure)
- field : le champ de la resource sur lequel la policy sera appliquée (ex: tags.NomDuTag)
- allowedValues : la liste des valeurs autorisées pour ce tag
*/

param customPoliciesTags = [
  {
    name: 'Environnement'
    displayName: 'Tag - Environnement'
    field: 'tags.Environnement'
    allowedValues: [
      'Dev'
      'Preprod'
      'Prod'
    ]
    nonComplianceMessage: 'Le tag Environnement doit être conforme aux valeurs acceptées. Soit Dev, Preprod ou Prod.'
  }
  {
    name: 'Criticite'
    displayName: 'Tag - Criticite'
    field: 'tags.Criticite'
    allowedValues: [
      'Eleve'
      'Moyen'
      'Bas'
    ]
    nonComplianceMessage: 'Le tag Criticite doit être conforme aux valeurs acceptées. Soit Eleve, Moyen ou Bas.'
  }
]


/*
Liste des policies builtin pour les tags
On peut ajouter autant de tags que nécessaire dans cette liste, avec les propriétés suivantes :
- name : le nom du tag (sera utilisé dans l'initiative)
- type : le type de la policy builtin (ex: requiredOnResourceGroup, inheritFromParent, etc.)
- nonComplianceMessage : le message de non-conformité affiché lorsque la policy n'est pas respectée
*/

param builtinPolicieTags = [
  {
    name: 'Application'
    type: 'requiredOnResourceGroup'
    nonComplianceMessage: 'Le tag FournisseurApp est obligatoire sur les Resource Groups.'
  }
  {
    name: 'Responsable'
    type: 'requiredOnResourceGroup'
    nonComplianceMessage: 'Le tag Responsable est obligatoire sur les Resource Groups.'
  }
  {
    name: 'ResponsableEmail'
    type: 'requiredOnResourceGroup'
    nonComplianceMessage: 'Le tag ResponsableEmail est obligatoire sur les Resource Groups.'
  }
  {
    name: 'CreePar'
    type: 'requiredOnResourceGroup'
    nonComplianceMessage: 'Le tag CreePar est obligatoire sur les Resource Groups.'
  }
  {
    name: 'CreeLe'
    type: 'requiredOnResourceGroup'
    nonComplianceMessage: 'Le tag CreeLe est obligatoire sur les Resource Groups.'
  }
  // Tags hérités du parent
  {
    name: 'Environnement'
    type: 'inheritFromParent'
    nonComplianceMessage: 'Le tag Environnement doit être hérité du parent.'
  }
  {
    name: 'Application'
    type: 'inheritFromParent'
    nonComplianceMessage: 'Le tag Application doit être hérité du parent.'
  }
  {
    name: 'Criticite'
    type: 'inheritFromParent'
    nonComplianceMessage: 'Le tag Criticite doit être hérité du parent.'
  }
]

