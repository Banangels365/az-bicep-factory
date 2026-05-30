[![ALZ - Platform-LZ Validation](https://github.com/Banangels365/az-bicep-factory/actions/workflows/platform-lz-validation.yml/badge.svg)](https://github.com/Banangels365/az-bicep-factory/actions/workflows/platform-lz-validation.yml) 
[![ALZ - Platform-LZ Deployment](https://github.com/Banangels365/az-bicep-factory/actions/workflows/platform-lz-deploy.yml/badge.svg?branch=main)](https://github.com/Banangels365/az-bicep-factory/actions/workflows/platform-lz-deploy.yml)

# Platform Landing Zone — Bicep Modules

> **Version** : 2.0.0 | **Région supportée** : `canadacentral` (`cace`), `canadaeast` (`caea`)  
> **Mainteneur** : PlatformOps Team | **Dernière mise à jour** : Mai 2026

---

## Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Architecture](#architecture)
- [Ordre de déploiement](#ordre-de-déploiement)
- [Modules](#modules)
  - [management_group.bicep](#management_groupbicep)
  - [resource_group.bicep](#resource_groupbicep)
  - [log_analytics_workspace.bicep](#log_analytics_workspacebicep)
  - [diagnostic_settings.bicep](#diagnostic_settingsbicep)
- [Politiques Azure](#politiques-azure)
  - [01_Tagging_Policy.bicep](#01_tagging_policybicep)
  - [02_General_Policy.bicep](#02_general_policybicep)
  - [03_Network_Policy.bicep](#03_network_policybicep)
  - [04_KeyVault_Policy.bicep](#04_keyvault_policybicep)
  - [05_VM_Policy.bicep](#05_vm_policybicep)
  - [06_StorageAccount_Policy.bicep](#06_storageaccount_policybicep)
- [Bonnes pratiques IaC](#bonnes-pratiques-iac)
- [Troubleshooting](#troubleshooting)
- [Ressources](#ressources)

---

## Vue d'ensemble

La Platform Landing Zone déploie et gère les fondations de gouvernance et d'observabilité
sur lesquelles toutes les autres Landing Zones s'appuient. Elle est déployée en premier,
avant connectivity-lz et identity-lz.

**Ce que déploie cette Landing Zone :**

- **Management Groups** pour organiser les subscriptions et appliquer des policies à l'échelle
- **Resource Groups** pour regrouper les ressources de la plateforme
- **Log Analytics Workspace** comme destination centralisée pour tous les diagnostic settings
- **Diagnostic Settings** pour configurer la collecte de logs sur les ressources cibles
- **Azure Policy Initiatives** pour appliquer les standards de gouvernance (tagging, réseau, sécurité)

> **Ordre de déploiement global** : Platform LZ → Connectivity LZ → Identity LZ → Workload LZs.
> Le Log Analytics Workspace déployé ici est référencé par `logAnalyticsWorkspaceId`
> dans tous les orchestrateurs suivants.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│  Tenant Root Group                                              │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Management Groups (tenant scope)                        │   │
│  │                                                          │   │
│  │  mg-root                                                 │   │
│  │  ├── mg-prod         → subscriptions production          │   │
│  │  ├── mg-dev          → subscriptions development         │   │
│  │  ├── mg-sbox         → subscriptions sandbox             │   │
│  │  └── mg-quarantine   → subscriptions quarantaine         │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Platform Resources (subscription scope)                 │   │
│  │                                                          │   │
│  │  rg-platform                                             │   │
│  │  ├── Log Analytics Workspace  ← référencé par toutes LZs │   │
│  │  └── Diagnostic Settings      ← collecte centralisée     │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Azure Policy (subscription/management group scope)      │   │
│  │                                                          │   │
│  │  01_Tagging       → tags obligatoires sur les RGs        │   │
│  │  02_General       → restrictions de localisation         │   │
│  │  03_Network       → NSG obligatoires, pas d'IP publique  │   │
│  │  04_KeyVault      → modèle RBAC obligatoire              │   │
│  │  05_VM            → SKUs autorisés, backup obligatoire   │   │
│  │  06_StorageAccount → HTTPS, TLS 1.2, accès public bloqué │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Ordre de déploiement

```bash
# 1. Valider le déploiement avec --what-if
az deployment tenant what-if \
  --name platform-lz-deploy \
  --location canadaeast \
  --template-file platform-lz/main.bicep \
  --parameters platform-lz/main.bicepparam

# 2. Déployer la Platform Landing Zone
# Note : targetScope = 'tenant' pour les Management Groups
az deployment tenant create \
  --name platform-lz-deploy \
  --location canadaeast \
  --template-file platform-lz/main.bicep \
  --parameters platform-lz/main.bicepparam

# 3. Récupérer l'ID du Log Analytics Workspace pour les LZs suivantes
az deployment tenant show \
  --name platform-lz-deploy \
  --query 'properties.outputs.logAnalyticsWorkspaceId'
```

> **Prérequis** :
> - Permissions `Owner` ou `Management Group Contributor` au niveau tenant pour les Management Groups
> - Permissions `Contributor` sur la subscription pour les Resource Groups et le Log Analytics Workspace
> - Azure CLI >= 2.50.0 | Bicep CLI >= 0.24.0

---

## Modules

---

### `management_group.bicep`

#### Description

Crée un Management Group et associe des subscriptions. Déployé au scope `tenant` —
c'est le scope le plus élevé d'Azure, qui requiert des permissions de niveau
`Management Group Contributor` ou `Owner` au tenant root.

Les subscriptions sont associées en tant que ressources enfants du Management Group.
Si aucune subscription n'est fournie (`subscriptionIds: []`), seul le groupe est créé.

#### Utilisation

```bicep
// Hiérarchie complète de Management Groups
module mgPlatform './modules/management_group.bicep' = {
  name: 'deploy-mg-platform'
  // scope: tenant() — hérité de l'orchestrateur (targetScope = 'tenant')
  params: {
    managementGroupId:       'mg-acmy-platform'
    displayName:             'ACMY Platform'
    parentManagementGroupId: 'mg-acmy-root'         // rattacher au parent
    subscriptionIds:         [platformSubscriptionId]
  }
}

module mgConnectivity './modules/management_group.bicep' = {
  name: 'deploy-mg-connectivity'
  params: {
    managementGroupId:       'mg-acmy-connectivity'
    displayName:             'ACMY Connectivity'
    parentManagementGroupId: 'mg-acmy-platform'     // enfant de Platform
    subscriptionIds:         [connectivitySubscriptionId]
  }
  dependsOn: [mgPlatform]  // s'assurer que le parent existe avant l'enfant
}

module mgSbox './modules/management_group.bicep' = {
  name: 'deploy-mg-sbox'
  params: {
    managementGroupId:       'mg-acmy-sbox'
    displayName:             'ACMY Sandbox'
    parentManagementGroupId: 'mg-acmy-root'
    subscriptionIds: []     // subscriptions ajoutées manuellement ou via pipeline
  }
}
```

#### Requis

- L'orchestrateur appelant doit avoir `targetScope = 'tenant'`
- Permissions : `Management Group Contributor` ou `Owner` au niveau Tenant Root Group
- Le Management Group parent doit exister avant les groupes enfants (`dependsOn` recommandé)

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `managementGroupId` | string | — | ✅ | Identifiant unique du Management Group (slug, pas GUID) |
| `displayName` | string | — | ✅ | Nom d'affichage dans le portail Azure |
| `parentManagementGroupId` | string | `''` | ❌ | ID du groupe parent (racine tenant si vide) |
| `subscriptionIds` | array | `[]` | ❌ | IDs des subscriptions à associer au groupe |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `managementGroupId` | string | Resource ID complet du Management Group |
| `managementGroupName` | string | Identifiant du Management Group (slug) |
| `displayName` | string | Nom d'affichage |

#### Ressources créées

- `Microsoft.Management/managementGroups`
- `Microsoft.Management/managementGroups/subscriptions` (une par subscription associée)

#### Dépendances

Aucune dépendance directe. Le groupe parent doit exister — utiliser `dependsOn` pour garantir l'ordre.

---

### `resource_group.bicep`

#### Description

Crée un Resource Group dans la subscription courante. Déployé au scope `subscription`.
Constitue le premier bloc de tout déploiement de ressources Azure — les autres modules
(`log_analytics_workspace`, `network_security_group`, etc.) y sont ensuite déployés.

#### Utilisation

```bicep
// Resource Groups de la Platform Landing Zone
module rgPlatform './modules/resource_group.bicep' = {
  name: 'deploy-rg-platform'
  // scope: subscription() — hérité ou explicite
  params: {
    resourceGroupName: 'rg-acmy-sbox-caea-platform'
    location:          'caea'
    tags: union(globalTags, {
      Purpose: 'Platform-Management'
    })
  }
}

module rgMonitoring './modules/resource_group.bicep' = {
  name: 'deploy-rg-monitoring'
  params: {
    resourceGroupName: 'rg-acmy-sbox-caea-monitoring'
    location:          'caea'
    tags: union(globalTags, {
      Purpose: 'Monitoring-Observability'
    })
  }
}

// Utiliser l'output pour scoper les modules suivants
module logAnalytics './modules/log_analytics_workspace.bicep' = {
  scope: resourceGroup(rgMonitoring.outputs.resourceGroupName)  // ← output direct
  name: 'deploy-law'
  params: { ... }
}
```

#### Requis

- L'orchestrateur appelant doit avoir `targetScope = 'subscription'` ou équivalent
- Permissions : `Contributor` ou `Resource Group Contributor` sur la subscription

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `resourceGroupName` | string | — | ✅ | Nom du Resource Group |
| `location` | string | `caea` | ❌ | Région (`cace` = canadacentral, `caea` = canadaeast) |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `resourceGroupId` | string | Resource ID complet du Resource Group |
| `resourceGroupName` | string | Nom du Resource Group — à passer à `scope: resourceGroup(...)` |

#### Ressources créées

- `Microsoft.Resources/resourceGroups`

#### Dépendances

Aucune dépendance directe. La subscription cible doit être accessible depuis le tenant de déploiement.

---

### `log_analytics_workspace.bicep`

#### Description

Déploie un Log Analytics Workspace avec solutions OMS optionnelles et Microsoft Sentinel.
C'est la ressource centrale de la Platform Landing Zone — son `workspaceId` est référencé
par `logAnalyticsWorkspaceId` dans tous les modules de diagnostic des autres Landing Zones
(connectivity, identity, spokes).

> **Déployer en premier** : Ce module doit être déployé avant tout autre module
> qui utilise `logAnalyticsWorkspaceId`. Passer l'output `workspaceId` directement
> en paramètre aux orchestrateurs suivants plutôt que de le coder en dur.

#### Utilisation

```bicep
module logAnalytics './modules/log_analytics_workspace.bicep' = {
  scope: resourceGroup(rgMonitoring.outputs.resourceGroupName)
  name: 'deploy-law-platform'
  params: {
    workspaceName:    'law-acmy-sbox-caea'
    location:         'caea'
    sku:              'PerGB2018'
    retentionInDays:  90
    dailyQuotaGb:     -1             // -1 = pas de quota (pay-as-you-go)
    enableSentinel:   false          // activer en production si Sentinel est licencié
    solutions: [
      'Updates'                      // Azure Update Management
      'ChangeTracking'               // suivi des changements de configuration
    ]
    tags: union(globalTags, {
      Purpose: 'Centralized-Logging'
    })
  }
}

// Passer le workspaceId aux autres LZs
output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId

// Utilisation dans connectivity-lz
az deployment sub create \
  --parameters logAnalyticsWorkspaceId=$(az deployment tenant show \
    --name platform-lz-deploy \
    --query 'properties.outputs.logAnalyticsWorkspaceId.value' -o tsv)
```

#### Requis

- Le Resource Group cible doit exister avant le déploiement
- Pour Microsoft Sentinel : licence Microsoft Sentinel requise (ou trial activé)
- Permissions : `Contributor` sur le Resource Group cible

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `workspaceName` | string | — | ✅ | Nom du Log Analytics Workspace |
| `location` | string | `caea` | ❌ | Région (`cace` ou `caea`) |
| `sku` | string | `PerGB2018` | ❌ | SKU du workspace (`PerGB2018` recommandé) |
| `retentionInDays` | int | `90` | ❌ | Rétention des données en jours (30-730) |
| `dailyQuotaGb` | int | `-1` | ❌ | Quota journalier en GB (`-1` = illimité) |
| `publicNetworkAccessForIngestion` | string | `Enabled` | ❌ | Accès public pour l'ingestion des logs |
| `publicNetworkAccessForQuery` | string | `Enabled` | ❌ | Accès public pour les requêtes |
| `enableSentinel` | bool | `false` | ❌ | Déploie Microsoft Sentinel sur ce workspace |
| `solutions` | array | `[]` | ❌ | Solutions OMS additionnelles à activer |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `workspaceId` | string | **Resource ID complet — à passer à tous les modules de diagnostic** |
| `workspaceName` | string | Nom du workspace |
| `customerId` | string | Customer ID (GUID) — pour les agents Log Analytics |

#### Ressources créées

- `Microsoft.OperationalInsights/workspaces`
- `Microsoft.OperationsManagement/solutions` (une par solution activée + Sentinel si activé)

#### Dépendances

Dépend d'un Resource Group existant. Référencé par `diagnostic_settings.bicep` et tous
les modules de monitoring des autres Landing Zones.

---

### `diagnostic_settings.bicep`

#### Description

Configure les Diagnostic Settings sur une ressource existante pour envoyer ses logs
et métriques vers un Log Analytics Workspace, un Storage Account ou un Event Hub.

> **Compatibilité logs/métriques** : Toutes les ressources Azure ne supportent pas
> les mêmes catégories. Certaines ne supportent que les logs, d'autres que les métriques.
> Passer des catégories non supportées cause une erreur ARM `BadRequest`.
> Voir le tableau de compatibilité dans la section [Bonnes pratiques IaC](#bonnes-pratiques-iac).

#### Utilisation

```bicep
// Diagnostic settings sur un Key Vault existant
module diagKeyVault './modules/diagnostic_settings.bicep' = {
  scope: keyVault  // scope = ressource cible
  name: 'diag-kv-platform'
  params: {
    diagnosticSettingName:  'kv-platform-diagnostics'
    workspaceId:            logAnalytics.outputs.workspaceId
    logCategories: [
      { category: 'AuditEvent'                enabled: true }
      { category: 'AzurePolicyEvaluationDetails' enabled: true }
    ]
    metricCategories: [
      { category: 'AllMetrics' enabled: true }
    ]
  }
}

// Diagnostic settings avec archivage Storage (compliance long terme)
module diagStorage './modules/diagnostic_settings.bicep' = {
  scope: existingResource
  name: 'diag-archive'
  params: {
    diagnosticSettingName:  'archive-diagnostics'
    workspaceId:            logAnalytics.outputs.workspaceId
    storageAccountId:       archiveStorageAccount.id  // rétention longue durée
    logCategories: [
      { category: 'AuditEvent' enabled: true }
    ]
  }
}

// Diagnostic settings avec streaming Event Hub (SIEM tiers)
module diagEventHub './modules/diagnostic_settings.bicep' = {
  scope: existingResource
  name: 'diag-eventhub'
  params: {
    diagnosticSettingName:          'siem-diagnostics'
    workspaceId:                    logAnalytics.outputs.workspaceId
    eventHubAuthorizationRuleId:    eventHub.authorizationRuleId
    eventHubName:                   'security-logs'
    logCategories: [
      { category: 'AuditEvent' enabled: true }
    ]
  }
}
```

#### Requis

- La ressource cible doit exister (`scope` du module = ressource existante)
- Au moins une destination (`workspaceId`, `storageAccountId` ou `eventHubAuthorizationRuleId`) doit être fournie
- Les catégories doivent être supportées par le type de ressource cible

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `diagnosticSettingName` | string | `default-diagnostics` | ❌ | Nom de la configuration de diagnostic |
| `workspaceId` | string | `''` | ❌ | Resource ID du Log Analytics Workspace cible |
| `storageAccountId` | string | `''` | ❌ | Resource ID du Storage Account (archivage) |
| `eventHubAuthorizationRuleId` | string | `''` | ❌ | Resource ID de la règle d'autorisation Event Hub |
| `eventHubName` | string | `''` | ❌ | Nom du Event Hub cible |
| `logCategories` | array | `[]` | ❌ | Catégories de logs à activer |
| `metricCategories` | array | `[{ category: 'AllMetrics', enabled: true }]` | ❌ | Catégories de métriques à activer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `diagnosticSettingId` | string | Resource ID complet de la configuration |
| `diagnosticSettingName` | string | Nom de la configuration |

#### Ressources créées

- `Microsoft.Insights/diagnosticSettings`

#### Dépendances

Dépend de `log_analytics_workspace.bicep` si `workspaceId` est fourni. La ressource cible
doit exister avant l'application des diagnostic settings.

---

## Politiques Azure

Les politiques se trouvent dans `platform-lz/policies/`. Contrairement aux modules,
ce sont des **templates autonomes** déployés directement — pas des modules génériques
réutilisables. Chaque fichier déploie une initiative (groupement de policies) et
son assignation correspondante.

> **Scope de déploiement** : Les politiques s'appliquent au scope de l'assignation.
> Déployer au scope d'un Management Group pour couvrir toutes les subscriptions enfants.
> Utiliser `enforcementMode: 'DoNotEnforce'` (ou `Default` pour enforcer) selon la maturité.

---

### `01_Tagging_Policy.bicep`

#### Description

Déploie deux initiatives de tagging sur les Resource Groups :
une initiative avec des policies custom (tags spécifiques à l'organisation)
et une avec des policies built-in Azure (héritage de tags parent vers enfant).

#### Utilisation

```bicep
module taggingPolicy './policies/01_Tagging_Policy.bicep' = {
  name: 'deploy-tagging-policy'
  // scope: managementGroup() ou subscription()
  params: {
    initiativeCustomPoliciesName:        'initiative-tags-custom-acmy'
    initiativeCustomPoliciesDisplayName: 'ACMY — Tags obligatoires sur Resource Groups'
    initiativeBuiltinPoliciesName:       'initiative-tags-builtin-acmy'
    initiativeBuiltinPoliciesDisplayName: 'ACMY — Héritage de tags Azure built-in'
    customPoliciesTags: [
      { tagName: 'Application'      effect: 'Deny' }
      { tagName: 'Environnement'    effect: 'Deny' }
      { tagName: 'Responsable'      effect: 'Deny' }
      { tagName: 'ResponsableEmail' effect: 'Deny' }
      { tagName: 'CreeLe'           effect: 'Deny' }
      { tagName: 'CreePar'          effect: 'Deny' }
    ]
    builtinPoliciesTags: [
      { tagName: 'Application' }
      { tagName: 'Environnement' }
    ]
  }
}
```

#### Requis

- Permissions : `Policy Contributor` ou `Owner` sur le scope cible

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `initiativeCustomPoliciesName` | string | — | ✅ | Nom de l'initiative avec policies custom |
| `initiativeCustomPoliciesDisplayName` | string | — | ✅ | Nom d'affichage de l'initiative custom |
| `initiativeBuiltinPoliciesName` | string | — | ✅ | Nom de l'initiative avec policies built-in |
| `initiativeBuiltinPoliciesDisplayName` | string | — | ✅ | Nom d'affichage de l'initiative built-in |
| `customPoliciesTags` | array | `[]` | ❌ | Tags custom avec effet (`Audit`, `Deny`, `Modify`) |
| `builtinPoliciesTags` | array | `[]` | ❌ | Tags pour héritage built-in |
| `location` | string | `deployment().location` | ❌ | Région de l'assignation |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `initiativeCustomPoliciesTagsId` | string | Resource ID de l'initiative custom |
| `initiativeBuiltinPoliciesTagsId` | string | Resource ID de l'initiative built-in |
| `initiativeCustomPoliciesTagsAssignmentId` | string | Resource ID de l'assignation custom |
| `initiativeBuiltinPoliciesTagsAssignmentId` | string | Resource ID de l'assignation built-in |

#### Ressources créées

- `Microsoft.Authorization/policyDefinitions` (policies custom)
- `Microsoft.Authorization/policySetDefinitions` × 2 (initiatives)
- `Microsoft.Authorization/policyAssignments` × 2 (assignations)

#### Dépendances

Aucune dépendance directe sur d'autres modules Bicep.

---

### `02_General_Policy.bicep`

#### Description

Déploie une initiative de policies générales pour restreindre la localisation des ressources
aux régions autorisées. Utilise les built-ins Azure `Allowed locations` et
`Audit resource location matches resource group location`.

#### Utilisation

```bicep
module generalPolicy './policies/02_General_Policy.bicep' = {
  name: 'deploy-general-policy'
  params: {
    initiativeName:        'initiative-general-acmy'
    initiativeDisplayName: 'ACMY — Politiques générales'
    assignmentName:        'assign-general-acmy'
    assignmentDisplayName: 'ACMY — Assignation politiques générales'
    allowedLocations: [
      'canadacentral'
      'canadaeast'
    ]
  }
}
```

#### Requis

- Permissions : `Policy Contributor` ou `Owner` sur le scope cible

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `initiativeName` | string | — | ✅ | Nom de l'initiative |
| `initiativeDisplayName` | string | — | ✅ | Nom d'affichage de l'initiative |
| `assignmentName` | string | — | ✅ | Nom de l'assignation |
| `assignmentDisplayName` | string | — | ✅ | Nom d'affichage de l'assignation |
| `allowedLocations` | array | — | ✅ | Régions autorisées (noms complets Azure) |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `initiativeId` | string | Resource ID de l'initiative |
| `assignmentId` | string | Resource ID de l'assignation |

#### Ressources créées

- `Microsoft.Authorization/policySetDefinitions`
- `Microsoft.Authorization/policyAssignments`

#### Dépendances

Aucune dépendance directe.

---

### `03_Network_Policy.bicep`

#### Description

Déploie une initiative réseau avec deux contrôles built-in : NSG obligatoire sur les subnets
et interdiction d'IPs publiques sur les interfaces réseau (NICs). Aide à maintenir
la posture réseau Zero Trust en production.

#### Utilisation

```bicep
module networkPolicy './policies/03_Network_Policy.bicep' = {
  name: 'deploy-network-policy'
  params: {
    initiativeName:        'initiative-network-acmy'
    initiativeDisplayName: 'ACMY — Politiques réseau'
    assignmentName:        'assign-network-acmy'
    assignmentDisplayName: 'ACMY — Assignation politiques réseau'
    initiativeCategory:    'Network'
    enforcementMode:       'DoNotEnforce'  // commencer en audit avant d'enforcer
  }
}
```

#### Requis

- Permissions : `Policy Contributor` ou `Owner` sur le scope cible
- Recommandé : démarrer avec `enforcementMode: 'DoNotEnforce'` pour évaluer l'impact

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `initiativeName` | string | — | ✅ | Nom de l'initiative |
| `initiativeDisplayName` | string | — | ✅ | Nom d'affichage de l'initiative |
| `assignmentName` | string | — | ✅ | Nom de l'assignation |
| `assignmentDisplayName` | string | — | ✅ | Nom d'affichage de l'assignation |
| `initiativeCategory` | string | `General` | ❌ | Catégorie dans les métadonnées |
| `enforcementMode` | string | `Default` | ❌ | `Default` (enforcer) ou `DoNotEnforce` (audit) |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `initiativeId` | string | Resource ID de l'initiative |
| `assignmentId` | string | Resource ID de l'assignation |

#### Ressources créées

- `Microsoft.Authorization/policySetDefinitions`
- `Microsoft.Authorization/policyAssignments`

#### Dépendances

Aucune dépendance directe.

---

### `04_KeyVault_Policy.bicep`

#### Description

Déploie une initiative qui impose le modèle de permissions RBAC sur Azure Key Vault.
Empêche l'utilisation du modèle legacy basé sur les Access Policies au profit de RBAC —
plus granulaire et auditable.

#### Utilisation

```bicep
module kvPolicy './policies/04_KeyVault_Policy.bicep' = {
  name: 'deploy-keyvault-policy'
  params: {
    initiativeName:        'initiative-kv-acmy'
    initiativeDisplayName: 'ACMY — Politiques Key Vault'
    assignmentName:        'assign-kv-acmy'
    assignmentDisplayName: 'ACMY — Assignation politiques Key Vault'
    kvRbacEffect:          'Audit'   // 'Audit' ou 'Deny'
  }
}
```

#### Requis

- Permissions : `Policy Contributor` ou `Owner` sur le scope cible

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `initiativeName` | string | — | ✅ | Nom de l'initiative |
| `initiativeDisplayName` | string | — | ✅ | Nom d'affichage de l'initiative |
| `assignmentName` | string | — | ✅ | Nom de l'assignation |
| `assignmentDisplayName` | string | — | ✅ | Nom d'affichage de l'assignation |
| `kvRbacEffect` | string | — | ✅ | Effet de la policy (`Audit`, `Deny`, `Disabled`) |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `initiativeId` | string | Resource ID de l'initiative |
| `assignmentId` | string | Resource ID de l'assignation |

#### Ressources créées

- `Microsoft.Authorization/policySetDefinitions`
- `Microsoft.Authorization/policyAssignments`

#### Dépendances

Aucune dépendance directe.

---

### `05_VM_Policy.bicep`

#### Description

Déploie une initiative VM avec deux contrôles : restriction des SKUs de machines virtuelles
aux types autorisés (gouvernance des coûts) et audit de la présence d'Azure Backup.

#### Utilisation

```bicep
module vmPolicy './policies/05_VM_Policy.bicep' = {
  name: 'deploy-vm-policy'
  params: {
    initiativeName:        'initiative-vm-acmy'
    initiativeDisplayName: 'ACMY — Politiques machines virtuelles'
    assignmentName:        'assign-vm-acmy'
    assignmentDisplayName: 'ACMY — Assignation politiques VM'
    allowedVmSkus: [
      'Standard_B2s'
      'Standard_B4ms'
      'Standard_D2s_v5'
      'Standard_D4s_v5'
      'Standard_D8s_v5'
    ]
    backupEffect: 'AuditIfNotExists'  // 'AuditIfNotExists' ou 'DeployIfNotExists'
  }
}
```

#### Requis

- Permissions : `Policy Contributor` ou `Owner` sur le scope cible
- Pour `backupEffect: 'DeployIfNotExists'` : identité managée sur l'assignation requise

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `initiativeName` | string | — | ✅ | Nom de l'initiative |
| `initiativeDisplayName` | string | — | ✅ | Nom d'affichage de l'initiative |
| `assignmentName` | string | — | ✅ | Nom de l'assignation |
| `assignmentDisplayName` | string | — | ✅ | Nom d'affichage de l'assignation |
| `allowedVmSkus` | array | — | ✅ | Liste des SKUs VM autorisés |
| `backupEffect` | string | `AuditIfNotExists` | ❌ | Effet pour la policy Azure Backup |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `initiativeId` | string | Resource ID de l'initiative |
| `assignmentId` | string | Resource ID de l'assignation |

#### Ressources créées

- `Microsoft.Authorization/policySetDefinitions`
- `Microsoft.Authorization/policyAssignments`

#### Dépendances

Aucune dépendance directe.

---

### `06_StorageAccount_Policy.bicep`

#### Description

Déploie une initiative Storage Account avec trois contrôles de sécurité :
activation du transfert sécurisé (HTTPS uniquement), version TLS minimale et
blocage de l'accès public aux blobs.

#### Utilisation

```bicep
module storagePolicy './policies/06_StorageAccount_Policy.bicep' = {
  name: 'deploy-storage-policy'
  params: {
    initiativeName:        'initiative-storage-acmy'
    initiativeDisplayName: 'ACMY — Politiques Storage Account'
    assignmentName:        'assign-storage-acmy'
    assignmentDisplayName: 'ACMY — Assignation politiques Storage'
    secureTransferEffect:  'Modify'   // corrige automatiquement
    tlsEffect:             'Audit'    // audit seulement
    minimumTlsVersion:     'TLS1_2'
    publicAccessEffect:    'Audit'    // 'Audit' ou 'Deny'
    assignmentLocation:    'canadaeast'
  }
}
```

#### Requis

- Permissions : `Policy Contributor` ou `Owner` sur le scope cible
- Pour `secureTransferEffect: 'Modify'` : identité managée sur l'assignation requise (remediation automatique)

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `initiativeName` | string | — | ✅ | Nom de l'initiative |
| `initiativeDisplayName` | string | — | ✅ | Nom d'affichage de l'initiative |
| `assignmentName` | string | — | ✅ | Nom de l'assignation |
| `assignmentDisplayName` | string | — | ✅ | Nom d'affichage de l'assignation |
| `secureTransferEffect` | string | `Modify` | ❌ | Effet pour HTTPS (`Modify`, `Audit`, `Deny`) |
| `tlsEffect` | string | `Audit` | ❌ | Effet pour version TLS minimale |
| `minimumTlsVersion` | string | `TLS1_2` | ❌ | Version TLS minimale requise |
| `publicAccessEffect` | string | `Audit` | ❌ | Effet pour blocage accès public |
| `assignmentLocation` | string | `deployment().location` | ❌ | Région de l'identité managée de l'assignation |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `initiativeId` | string | Resource ID de l'initiative |
| `assignmentId` | string | Resource ID de l'assignation |

#### Ressources créées

- `Microsoft.Authorization/policySetDefinitions`
- `Microsoft.Authorization/policyAssignments`

#### Dépendances

Aucune dépendance directe.

---

## Bonnes pratiques IaC

### Ordre de déploiement des Management Groups

```bicep
// ❌ Risque : enfant déployé avant le parent si Bicep parallélise
module mgChild './modules/management_group.bicep' = {
  params: { parentManagementGroupId: 'mg-parent' }
}

// ✅ Garantir l'ordre avec dependsOn
module mgChild './modules/management_group.bicep' = {
  params: { parentManagementGroupId: mgParent.outputs.managementGroupName }
  dependsOn: [mgParent]
}
```

### Log Analytics Workspace — source unique de vérité

```bicep
// ❌ ID codé en dur dans chaque LZ
logAnalyticsWorkspaceId: '/subscriptions/xxx/resourceGroups/rg-monitoring/providers/...'

// ✅ Récupérer l'output de platform-lz et passer en paramètre
param logAnalyticsWorkspaceId string  // reçu depuis platform-lz outputs
```

### Policies — progression par mode d'enforcement

```bicep
// Phase 1 — Évaluer l'impact sans bloquer
enforcementMode: 'DoNotEnforce'   // report-only, aucun blocage

// Phase 2 — Enforcer après validation
enforcementMode: 'Default'        // bloque ou corrige selon l'effet
```

### Effets de Policy — choisir le bon niveau

```
Disabled        → policy inactive (développement/test)
Audit           → journalise la non-conformité sans bloquer
AuditIfNotExists → audit si une ressource liée est absente (ex: backup manquant)
Modify          → corrige automatiquement (requiert identité managée)
DeployIfNotExists → déploie une ressource si absente (requiert identité managée)
Deny            → bloque la création/modification non conforme
```

### Diagnostic settings — compatibilité par type de ressource

```bicep
// Référence rapide — ce que chaque ressource supporte
// Resource Group    → logs uniquement (AuditEvent)
// Key Vault         → logs + métriques
// NSG               → logs uniquement (pas de métriques)
// NAT Gateway       → métriques uniquement (pas de logs)
// Load Balancer     → métriques uniquement (pas de logs)
// Azure Firewall    → logs (allLogs) + métriques
// Log Analytics WS  → logs + métriques

// ❌ Passer des métriques sur un NSG → erreur ARM BadRequest
// ✅ Vérifier la documentation par type avant de configurer
```

---

## Troubleshooting

### `AuthorizationFailed` — permissions insuffisantes pour les Management Groups

**Symptôme** : `The client does not have authorization to perform action 'Microsoft.Management/managementGroups/write'`

**Cause** : Le service principal de déploiement n'a pas les permissions au niveau tenant.

**Solution** :
```bash
# Vérifier les permissions au niveau tenant
az role assignment list \
  --scope / \
  --assignee $(az ad signed-in-user show --query id -o tsv) \
  --output table

# Assigner Management Group Contributor au niveau root
az role assignment create \
  --assignee $SP_OBJECT_ID \
  --role 'Management Group Contributor' \
  --scope /providers/Microsoft.Management/managementGroups/Tenant_Root_Group
```

### `PolicyAssignmentAlreadyExists` — assignation déjà présente

**Symptôme** : Conflit lors d'un redéploiement d'une assignation de policy.

**Cause** : Normal en redéploiement idempotent. ARM tente de recréer une assignation
dont le nom existe déjà.

**Solution** : Vérifier que le nom d'assignation est déterministe et identique
entre les déploiements. Si intentionnellement différent, supprimer l'ancienne assignation
avant de déployer la nouvelle.

### `WorkspaceNotFound` — Log Analytics introuvable

**Symptôme** : Erreur sur les diagnostic settings d'une autre LZ après déploiement platform.

**Cause** : `logAnalyticsWorkspaceId` incorrect ou workspace pas encore provisionné.

**Solution** :
```bash
# Vérifier que le workspace existe
az monitor log-analytics workspace show \
  --resource-group rg-acmy-sbox-caea-monitoring \
  --workspace-name law-acmy-sbox-caea

# Récupérer l'ID correct
az monitor log-analytics workspace show \
  --resource-group rg-acmy-sbox-caea-monitoring \
  --workspace-name law-acmy-sbox-caea \
  --query id -o tsv
```

### Policy `Deny` bloque un déploiement d'une autre LZ

**Symptôme** : Déploiement connectivity ou identity bloqué par une policy.

**Cause** : Une policy en mode `Deny` est trop restrictive pour les ressources
de la plateforme (ex: restriction de localisation).

**Solution** : Créer une exemption de policy pour le scope concerné :
```bash
az policy exemption create \
  --name 'exemption-connectivity-lz' \
  --policy-assignment $ASSIGNMENT_ID \
  --scope /subscriptions/{connectivity-sub-id}/resourceGroups/{rg-name} \
  --exemption-category Waiver \
  --description 'Connectivity LZ resources exempt from location policy'
```

---

## Ressources

- [Azure Management Groups](https://learn.microsoft.com/azure/governance/management-groups/overview)
- [Azure Policy Overview](https://learn.microsoft.com/azure/governance/policy/overview)
- [Log Analytics Workspace](https://learn.microsoft.com/azure/azure-monitor/logs/log-analytics-workspace-overview)
- [Azure Monitor Diagnostic Settings](https://learn.microsoft.com/azure/azure-monitor/essentials/diagnostic-settings)
- [Azure Landing Zones — Platform](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/)
- [Policy Effects](https://learn.microsoft.com/azure/governance/policy/concepts/effects)
- [Bicep Scopes](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deploy-to-tenant)