# Modules Budget Azure Consumption

Ces modules Bicep permettent de déployer des budgets Azure Consumption aux scopes **Resource Group**, **Subscription** et **Management Group**. Ils reprennent la logique essentielle des modules AVM Microsoft pour les budgets — mêmes concepts de montant, période, dates, notifications par seuils et filtre optionnel — tout en restant plus simples et adaptés à un usage interne privé.[cite:64][cite:65][cite:66]

Les trois modules reposent sur la ressource `Microsoft.Consumption/budgets@2023-11-01` et conservent une structure volontairement homogène pour simplifier la maintenance dans un dépôt IaC. Les différences portent surtout sur le `targetScope` et sur certains outputs contextuels comme `resourceGroupName`, `subscriptionName` ou `managementGroupId`.[cite:64][cite:65][cite:66]

## Modules disponibles

| Module | Scope | Usage principal |
|---|---|---|
| `modules/consumption/budget_resource_group.bicep` | Resource Group | Suivi budgétaire d’un groupe de ressources précis.[cite:64] |
| `modules/consumption/budget_subscription.bicep` | Subscription | Suivi budgétaire global ou partiel à l’échelle d’une subscription.[cite:65] |
| `modules/consumption/budget_management_group.bicep` | Management Group | Suivi budgétaire transversal sur plusieurs subscriptions rattachées à un management group.[cite:66] |

## Paramètres communs

Les trois modules partagent les mêmes paramètres d’entrée principaux, ce qui permet de passer facilement d’un scope à l’autre sans changer la logique métier.[cite:64][cite:65][cite:66]

| Paramètre | Type | Obligatoire | Description |
|---|---|---:|---|
| `name` | `string` | Oui | Nom du budget Azure Consumption.[cite:64][cite:65][cite:66] |
| `category` | `string` | Non | Catégorie du budget, `Cost` ou `Usage`.[cite:64][cite:65][cite:66] |
| `amount` | `int` | Oui | Montant total du budget à suivre.[cite:64][cite:65][cite:66] |
| `resetPeriod` | `string` | Non | Période de réinitialisation, par exemple `Monthly`, `Quarterly` ou `Annually`.[cite:64][cite:65][cite:66] |
| `startDate` | `string` | Non | Date de début du budget, généralement le premier jour du mois.[cite:64][cite:65][cite:66] |
| `endDate` | `string` | Non | Date de fin du budget ; si vide, le module calcule une date à 10 ans. |
| `operator` | `string` | Non | Opérateur de comparaison pour les notifications.[cite:64][cite:65][cite:66] |
| `thresholds` | `array` | Non | Liste des seuils en pourcentage qui déclenchent des notifications.[cite:64][cite:65][cite:66] |
| `contactEmails` | `array` | Non | Adresses e-mail notifiées quand les seuils sont atteints.[cite:64][cite:65][cite:66] |
| `contactRoles` | `array` | Non | Rôles Azure notifiés quand les seuils sont atteints.[cite:64][cite:65][cite:66] |
| `actionGroups` | `array` | Non | Action Groups à notifier.[cite:64][cite:65][cite:66] |
| `thresholdType` | `string` | Non | Type de seuil, `Actual` ou `Forecasted`.[cite:64][cite:65][cite:66] |
| `filter` | `object` | Non | Filtre avancé appliqué au budget.[cite:64][cite:65][cite:66] |
| `resourceGroupFilter` | `array` | Non | Filtre simplifié par noms de resource groups lorsque `filter` n’est pas renseigné.[cite:64][cite:65][cite:66] |

## Outputs

Les modules exposent des sorties cohérentes pour faciliter leur consommation dans d’autres templates Bicep.[cite:64][cite:65][cite:66]

| Module | Outputs principaux |
|---|---|
| `budget_resource_group.bicep` | `name`, `resourceId`, `resourceGroupName`, `scope`, `effectiveStartDate`, `effectiveEndDate` |
| `budget_subscription.bicep` | `name`, `resourceId`, `subscriptionName`, `scope`, `effectiveStartDate`, `effectiveEndDate` |
| `budget_management_group.bicep` | `name`, `resourceId`, `managementGroupId`, `scope`, `effectiveStartDate`, `effectiveEndDate` |

## Exemple Resource Group

Exemple de budget mensuel appliqué au resource group courant.

```bicep
targetScope = 'resourceGroup'

module rgBudget '../modules/consumption/budget_resource_group.bicep' = {
  name: 'budget-rg-app1'
  params: {
    name: 'app1-monthly-budget'
    amount: 1200
    category: 'Cost'
    resetPeriod: 'Monthly'
    contactEmails: [
      'app-team@contoso.com'
    ]
    thresholds: [
      80
      100
      120
    ]
  }
}
```

## Exemple Subscription

Exemple de budget mensuel appliqué à une subscription cible depuis un déploiement au scope management group.[cite:65]

```bicep
targetScope = 'managementGroup'

param targetSubscriptionId string
param finOpsActionGroupId string

module subBudget '../modules/consumption/budget_subscription.bicep' = {
  name: 'budget-subscription-platform'
  scope: subscription(targetSubscriptionId)
  params: {
    name: 'platform-monthly-budget'
    amount: 10000
    category: 'Cost'
    resetPeriod: 'Monthly'
    startDate: '2026-06-01T00:00:00Z'
    contactEmails: [
      'finops@contoso.com'
      'platform@contoso.com'
    ]
    contactRoles: [
      'Owner'
    ]
    actionGroups: [
      finOpsActionGroupId
    ]
    thresholds: [
      60
      80
      100
      120
    ]
    resourceGroupFilter: [
      'rg-platform-prod'
      'rg-monitoring-prod'
    ]
  }
}
```

## Exemple Management Group

Exemple de budget de gouvernance appliqué à un management group cible.[cite:66]

```bicep
targetScope = 'tenant'

param targetManagementGroupId string

module mgBudget '../modules/consumption/budget_management_group.bicep' = {
  name: 'budget-mg-platform'
  scope: managementGroup(targetManagementGroupId)
  params: {
    name: 'mg-platform-quarterly-budget'
    amount: 50000
    category: 'Cost'
    resetPeriod: 'Quarterly'
    contactEmails: [
      'finops@contoso.com'
      'governance@contoso.com'
    ]
    thresholds: [
      70
      90
      100
    ]
    thresholdType: 'Forecasted'
  }
}
```

## Exemple avec filtre avancé

Le paramètre `filter` est prioritaire sur `resourceGroupFilter` et permet de cibler des dimensions ou des tags plus finement.[cite:64][cite:65][cite:66]

```bicep
module filteredBudget '../modules/consumption/budget_subscription.bicep' = {
  name: 'budget-subscription-filtered'
  scope: subscription(targetSubscriptionId)
  params: {
    name: 'filtered-budget'
    amount: 4000
    category: 'Cost'
    contactEmails: [
      'app-team@contoso.com'
    ]
    filter: {
      and: [
        {
          dimensions: {
            name: 'ResourceGroupName'
            operator: 'In'
            values: [
              'rg-app-prod'
            ]
          }
        }
        {
          tags: {
            name: 'environment'
            operator: 'In'
            values: [
              'prod'
            ]
          }
        }
      ]
    }
  }
}
```

## Bonnes pratiques

- Fournir au moins un canal de notification parmi `contactEmails`, `contactRoles` ou `actionGroups`, car les modules AVM budget sont conçus pour fonctionner avec un mécanisme de notification explicite.[cite:64][cite:65][cite:66]
- Utiliser une `startDate` alignée sur le premier jour du mois pour garder une lecture budgétaire cohérente.[cite:64][cite:65][cite:66]
- Utiliser `resourceGroupFilter` pour les cas simples et `filter` pour les cas avancés, afin de conserver un code IaC lisible.[cite:64][cite:65][cite:66]
- Limiter le nombre de seuils à des valeurs réellement exploitables opérationnellement, par exemple `80`, `100` et `120`.[cite:64][cite:65][cite:66]
