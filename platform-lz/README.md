# Platform Landing Zone — Modules et utilisation

Ce document décrit les modules Bicep fournis dans `platform-lz/modules`, leur rôle, leurs entrées/sorties, ressources créées et dépendances. Il est structuré pour faciliter l'utilisation selon les bonnes pratiques IaC.

## Description

Ce dossier contient des modules réutilisables pour déployer les éléments de la Platform Landing Zone :
- `management_group.bicep` : création et association d'abonnements aux Management Groups (scope tenant).
- `log_analytics_workspace.bicep` : déploiement d'un Log Analytics Workspace et solutions associées.
- `diagnostic_settings.bicep` : configuration des Diagnostic Settings sur une ressource (scope ressource).
- `resource_group.bicep` : création d'un Resource Group (scope subscription).

## Utilisation

Principes d'utilisation :
- Appeler chaque module depuis un template d'orchestration (ex. `platform/main.bicep`).
- Spécifier correctement le `scope` du module (`tenant`, `managementGroup`, `subscription`, `resource`).
- Utiliser des fichiers de paramètres séparés par environnement (`.bicepparam`).
- Tester avec `--what-if` avant déploiement réel.
- Utiliser des `outputs` de module comme entrées de modules ultérieurs pour conserver la traçabilité.

### Exemples d'appel complets

```bicep
module mg 'modules/management_group.bicep' = {
  name: 'mg-prod'
  scope: tenant()
  params: {
    managementGroupId: 'mg-prod'
    displayName: 'Production'
    parentManagementGroupId: 'mg-root'
    subscriptionIds: [subscription().subscriptionId]
  }
}

module rg 'modules/resource_group.bicep' = {
  name: 'rg-platform-prod'
  scope: subscription()
  params: {
    resourceGroupName: 'rg-platform-prod-canadacentral'
    location: 'cace'
    tags: {
      Environment: 'prod'
      ManagedBy: 'platform-lz'
    }
  }
}

module law 'modules/log_analytics_workspace.bicep' = {
  name: 'law-platform-prod'
  scope: resourceGroup(rg.outputs.resourceGroupName)
  params: {
    workspaceName: 'law-platform-prod'
    location: 'cace'
    sku: 'PerGB2018'
    retentionInDays: 90
    dailyQuotaGb: -1
    enableSentinel: true
    solutions: [
      'SecurityInsights'
      'Updates'
    ]
    tags: {
      Environment: 'prod'
      Owner: 'PlatformTeam'
    }
  }
}
```

```bicep
module diagnostics 'modules/diagnostic_settings.bicep' = {
  name: 'diag-rg-platform-prod'
  scope: resourceGroup(rg.outputs.resourceGroupName)
  params: {
    diagnosticSettingName: 'platform-prod-diagnostics'
    workspaceId: law.outputs.workspaceId
    logCategories: [
      {
        category: 'AuditEvent'
        enabled: true
      }
    ]
  }
}
```

## Requis

- Azure CLI (ou PowerShell) avec connexion active
- Bicep CLI installé
- Permissions : rôle approprié selon le scope (ex. `User Access Administrator` au tenant, `Contributor` ou `Policy Contributor` selon actions)

## Inputs / Outputs (global)

Ce README documente les inputs/outputs par module ci-dessous. Les paramètres attendus doivent être fournis via les appels de module ou le fichier `.bicepparam`.

## Ressources créées

- Management Groups : `Microsoft.Management/managementGroups`
- Policy Definitions : `Microsoft.Authorization/policyDefinitions`
- Policy Initiatives : `Microsoft.Authorization/policySetDefinitions`
- Policy Assignments : `Microsoft.Authorization/policyAssignments`
- Log Analytics Workspace : `Microsoft.OperationalInsights/workspaces`
- Diagnostic Settings : `Microsoft.Insights/diagnosticSettings`
- Resource Groups : `Microsoft.Resources/resourceGroups`

## Dépendances

- `diagnostic_settings` nécessite généralement l'ID d'un Log Analytics Workspace (si vous souhaitez centraliser les logs).
- `log_analytics_workspace` peut être déployé avant `diagnostic_settings` ou référencé par Policy.

---

## Modules — détails (Inputs / Outputs / Ressources / Dépendances)

### management_group.bicep
Description : Crée un Management Group et associe des abonnements.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `managementGroupId` | string | - | Identifiant du Management Group |
| `displayName` | string | - | Nom d'affichage du Management Group |
| `parentManagementGroupId` | string | `''` | ID du parent Management Group, si applicable |
| `subscriptionIds` | array | `[]` | Liste d'IDs d'abonnement à associer |

| Output | Type | Description |
|---|---|---|
| `managementGroupId` | string | Resource ID du Management Group |
| `managementGroupName` | string | Nom du Management Group |
| `displayName` | string | Nom d'affichage |

Ressources : `Microsoft.Management/managementGroups`, `Microsoft.Management/managementGroups/subscriptions`

Dépendances : aucune directe.

### log_analytics_workspace.bicep
Description : Déploie un workspace Log Analytics et des solutions.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `workspaceName` | string | - | Nom du workspace |
| `location` | string | `caea` | Région logique (`cace` = canadacentral, `caea` = canadaeast) |
| `sku` | string | `PerGB2018` | SKU du workspace |
| `retentionInDays` | int | `90` | Durée de conservation des logs |
| `dailyQuotaGb` | int | `-1` | Quota journalier des données |
| `publicNetworkAccessForIngestion` | string | `Enabled` | Accès public ingestion |
| `publicNetworkAccessForQuery` | string | `Enabled` | Accès public requête |
| `tags` | object | `{}` | Tags à appliquer |
| `enableSentinel` | bool | `false` | Déploie la solution Sentinel si vrai |
| `solutions` | array | `[]` | Solutions OMS additionnelles |

| Output | Type | Description |
|---|---|---|
| `workspaceId` | string | ID du workspace |
| `workspaceName` | string | Nom du workspace |
| `customerId` | string | ID client du workspace |

Ressources : `Microsoft.OperationalInsights/workspaces`, `Microsoft.OperationsManagement/solutions`

Dépendances : utilisé par `diagnostic_settings.bicep` et peut être référencé par des policies ou des scripts de monitoring.

### diagnostic_settings.bicep
Description : Configure les Diagnostic Settings d'une ressource.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `diagnosticSettingName` | string | `default-diagnostics` | Nom de la configuration |
| `workspaceId` | string | - | ID du Log Analytics cible |
| `storageAccountId` | string | `''` | ID du compte de stockage cible |
| `eventHubAuthorizationRuleId` | string | `''` | ID de la règle Event Hub |
| `eventHubName` | string | `''` | Nom du Event Hub |
| `logCategories` | array | `[]` | Catégories de logs à activer |
| `metricCategories` | array | `[ { category: 'AllMetrics', enabled: true } ]` | Catégories de métriques |

| Output | Type | Description |
|---|---|---|
| `diagnosticSettingId` | string | ID de la configuration |
| `diagnosticSettingName` | string | Nom de la configuration |

Ressources : `Microsoft.Insights/diagnosticSettings`

Dépendances : dépend généralement d'un `log_analytics_workspace` si `workspaceId` est fourni.

### resource_group.bicep
Description : Crée un Resource Group.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `resourceGroupName` | string | - | Nom du Resource Group |
| `location` | string | `caea` | Région logique (cace/canadacentral, caea/canadaeast) |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `resourceGroupId` | string | ID du Resource Group |
| `resourceGroupName` | string | Nom du Resource Group |

Ressources : `Microsoft.Resources/resourceGroups`

Dépendances : aucune directe.

### log_analytics_workspace.bicep
Description : Déploie un workspace Log Analytics et des solutions.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `workspaceName` | string | - | Nom du workspace |
| `location` | string | `caea` | Région logique (`cace` = canadacentral, `caea` = canadaeast) |
| `sku` | string | `PerGB2018` | SKU du workspace |
| `retentionInDays` | int | `90` | Durée de conservation des logs |
| `dailyQuotaGb` | int | `-1` | Quota journalier des données |
| `publicNetworkAccessForIngestion` | string | `Enabled` | Accès public ingestion |
| `publicNetworkAccessForQuery` | string | `Enabled` | Accès public requête |
| `tags` | object | `{}` | Tags à appliquer |
| `enableSentinel` | bool | `false` | Déploie la solution Sentinel si vrai |
| `solutions` | array | `[]` | Solutions OMS additionnelles |

| Output | Type | Description |
|---|---|---|
| `workspaceId` | string | ID du workspace |
| `workspaceName` | string | Nom du workspace |
| `customerId` | string | ID client du workspace |

Ressources : `Microsoft.OperationalInsights/workspaces`, `Microsoft.OperationsManagement/solutions`

Dépendances : utilisé par `diagnostic_settings.bicep` et peut être référencé par des policies ou des scripts de monitoring.

### diagnostic_settings.bicep
Description : Configure les Diagnostic Settings d'une ressource.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `diagnosticSettingName` | string | `default-diagnostics` | Nom de la configuration |
| `workspaceId` | string | - | ID du Log Analytics cible |
| `storageAccountId` | string | `''` | ID du compte de stockage cible |
| `eventHubAuthorizationRuleId` | string | `''` | ID de la règle Event Hub |
| `eventHubName` | string | `''` | Nom du Event Hub |
| `logCategories` | array | `[]` | Catégories de logs à activer |
| `metricCategories` | array | `[ { category: 'AllMetrics', enabled: true } ]` | Catégories de métriques |

| Output | Type | Description |
|---|---|---|
| `diagnosticSettingId` | string | ID de la configuration |
| `diagnosticSettingName` | string | Nom de la configuration |

Ressources : `Microsoft.Insights/diagnosticSettings`

Dépendances : dépend généralement d'un workspace Log Analytics si `workspaceId` est fourni.

### resource_group.bicep
Description : Crée un Resource Group.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `resourceGroupName` | string | - | Nom du Resource Group |
| `location` | string | `caea` | Région logique (cace/canadacentral, caea/canadaeast) |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `resourceGroupId` | string | ID du Resource Group |
| `resourceGroupName` | string | Nom du Resource Group |

Ressources : `Microsoft.Resources/resourceGroups`

Dépendances : aucune directe.

---

## Politiques disponibles dans `platform-lz/policies`

Le dossier `platform-lz/policies` contient des templates d'initiatives et d'assignations organisées par thème. Ces fichiers sont des exemples de bundles de policies, pas des modules génériques, et peuvent être déployés directement.

### 01_Tagging_Policy.bicep
Description : initiative et assignations de policies de tagging sur les Resource Groups.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `location` | string | `deployment().location` | Région de l'assignation |
| `initiativeCustomPoliciesName` | string | - | Nom de l'initiative personnalisée |
| `initiativeCustomPoliciesDisplayName` | string | - | Affichage de l'initiative personnalisée |
| `initiativeBuiltinPoliciesName` | string | - | Nom de l'initiative built-in |
| `initiativeBuiltinPoliciesDisplayName` | string | - | Affichage de l'initiative built-in |
| `customPoliciesTags` | array | `[]` | Liste de policies custom de tagging |
| `builtinPoliciesTags` | array | `[]` | Liste de policies built-in de tagging |

| Output | Type | Description |
|---|---|---|
| `initiativeCustomPoliciesTagsId` | string | ID de l'initiative custom |
| `initiativeBuiltinPoliciesTagsId` | string | ID de l'initiative built-in |
| `initiativeCustomPoliciesTagsAssignmentId` | string | ID de l'assignation custom |
| `initiativeBuiltinPoliciesTagsAssignmentId` | string | ID de l'assignation built-in |

Ressources : `Microsoft.Authorization/policyDefinitions`, `Microsoft.Authorization/policySetDefinitions`, `Microsoft.Authorization/policyAssignments`

Contenu : 2 initiatives, 2 assignations, policies custom de tags et policies built-in de type `requiredOnResourceGroup` / `inheritFromResourceGroup`.

### 02_General_Policy.bicep
Description : initiative de policies générales pour la localisation des ressources.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `initiativeName` | string | - | Nom de l'initiative |
| `assignmentName` | string | - | Nom de l'assignation |
| `allowedLocations` | array | - | Liste des emplacements autorisés |
| `initiativeDisplayName` | string | - | Nom lisible de l'initiative |
| `assignmentDisplayName` | string | - | Nom lisible de l'assignation |

| Output | Type | Description |
|---|---|---|
| `initiativeId` | string | ID de l'initiative |
| `assignmentId` | string | ID de l'assignation |

Ressources : `Microsoft.Authorization/policySetDefinitions`, `Microsoft.Authorization/policyAssignments`

Contenu : built-ins `allowed locations` et `audit resource location matches resource group location`.

### 03_Network_Policy.bicep
Description : initiative réseau avec contrôle NSG et suppression des IP publiques sur NIC.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `initiativeName` | string | - | Nom de l'initiative |
| `assignmentName` | string | - | Nom de l'assignation |
| `initiativeDisplayName` | string | - | Nom lisible de l'initiative |
| `assignmentDisplayName` | string | - | Nom lisible de l'assignation |
| `initiativeCategory` | string | `General` | Catégorie metadata |
| `enforcementMode` | string | `Default` | Mode d'application |

| Output | Type | Description |
|---|---|---|
| `initiativeId` | string | ID de l'initiative |
| `assignmentId` | string | ID de l'assignation |

Ressources : `Microsoft.Authorization/policySetDefinitions`, `Microsoft.Authorization/policyAssignments`

Contenu : built-ins `Subnets should be associated with a Network Security Group` et `Network interfaces should not have public IPs`.

### 04_KeyVault_Policy.bicep
Description : initiative Key Vault RBAC.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `initiativeName` | string | - | Nom de l'initiative |
| `assignmentName` | string | - | Nom de l'assignation |
| `initiativeDisplayName` | string | - | Nom lisible de l'initiative |
| `assignmentDisplayName` | string | - | Nom lisible de l'assignation |
| `kvRbacEffect` | string | - | Effet appliqué à la policy |

| Output | Type | Description |
|---|---|---|
| `initiativeId` | string | ID de l'initiative |
| `assignmentId` | string | ID de l'assignation |

Ressources : `Microsoft.Authorization/policySetDefinitions`, `Microsoft.Authorization/policyAssignments`

Contenu : built-in `Azure Key Vault should use RBAC permission model`.

### 05_VM_Policy.bicep
Description : initiative VM avec contrôles de SKU et audit Backup.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `initiativeName` | string | - | Nom de l'initiative |
| `assignmentName` | string | - | Nom de l'assignation |
| `allowedVmSkus` | array | - | Liste des SKU de VM autorisés |
| `backupEffect` | string | `AuditIfNotExists` | Effet pour la policy Azure Backup |
| `initiativeDisplayName` | string | - | Nom lisible de l'initiative |
| `assignmentDisplayName` | string | - | Nom lisible de l'assignation |

| Output | Type | Description |
|---|---|---|
| `initiativeId` | string | ID de l'initiative |
| `assignmentId` | string | ID de l'assignation |

Ressources : `Microsoft.Authorization/policySetDefinitions`, `Microsoft.Authorization/policyAssignments`

Contenu : built-ins `Allowed virtual machine SKUs` et `Azure Backup should be enabled for Virtual Machines`.

### 06_StorageAccount_Policy.bicep
Description : initiative Storage Account avec HTTPS, TLS minimum et blocage du public access.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `initiativeName` | string | - | Nom de l'initiative |
| `assignmentName` | string | - | Nom de l'assignation |
| `secureTransferEffect` | string | `Modify` | Effet pour Secure Transfer |
| `tlsEffect` | string | `Audit` | Effet pour minimum TLS |
| `minimumTlsVersion` | string | `TLS1_2` | Version TLS minimale |
| `publicAccessEffect` | string | `Audit` | Effet pour blocage du public access |
| `assignmentLocation` | string | `deployment().location` | Région de l'assignation |
| `initiativeDisplayName` | string | - | Nom lisible de l'initiative |
| `assignmentDisplayName` | string | - | Nom lisible de l'assignation |

| Output | Type | Description |
|---|---|---|
| `initiativeId` | string | ID de l'initiative |
| `assignmentId` | string | ID de l'assignation |

Ressources : `Microsoft.Authorization/policySetDefinitions`, `Microsoft.Authorization/policyAssignments`

Contenu : built-ins `Configure secure transfer of data on a storage account`, `Storage accounts should have the specified minimum TLS version`, et `Storage account public access should be disallowed`.

---

## Bonnes pratiques spécifiques aux modules

- Utiliser des noms et tags standardisés (cf. stratégie de tagging dans le repo).
- Fournir des paramètres via `.bicepparam` par environnement pour éviter les secrets en clair.
- Séparer la création d'infrastructure (management groups, RGs, workspace) et les assignments / configurations (policies, diagnostics) en étapes distinctes.

## Exemple rapide — flux recommandé

1. Déployer les `management_group` (tenant scope).
2. Déployer `log_analytics_workspace` (resource group scope).
3. Déployer `diagnostic_settings` contre les ressources cibles (scope ressource), en pointant vers le workspace.

---

Si vous souhaitez, je peux :
- Générer un tableau Markdown des paramètres/outputs pour chaque module (CSV-like),
- Ajouter des snippets d'exemples plus détaillés pour l'appel de chaque module depuis `platform/main.bicep`.

**Mise à jour** : Mai 2026