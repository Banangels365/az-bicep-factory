# Identity Landing Zone — Bicep Modules

> **Version** : 2.0.0 | **Région supportée** : `canadacentral` (`cace`), `canadaeast` (`caea`)  
> **Mainteneur** : IdentityOps Team | **Dernière mise à jour** : Mai 2026

---

## Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Architecture](#architecture)
- [Ordre de déploiement](#ordre-de-déploiement)
- [Modules](#modules)
  - [custom_role_definition.bicep](#custom_role_definitionbicep)
  - [managed_identity.bicep](#managed_identitybicep)
  - [rbac_assignment.bicep](#rbac_assignmentbicep)
  - [rbac_subscription_assignment.bicep](#rbac_subscription_assignmentbicep)
- [Bonnes pratiques IaC](#bonnes-pratiques-iac)
- [Troubleshooting](#troubleshooting)
- [Ressources](#ressources)

---

## Vue d'ensemble

L'Identity Landing Zone déploie et gère les identités et les permissions RBAC pour toutes les subscriptions de la plateforme. Elle constitue le socle de sécurité sur lequel les autres Landing Zones s'appuient.

**Ce que déploie cette Landing Zone :**

- **Managed Identities** (User-Assigned) pour les ressources Azure automatisées
- **Custom Role Definitions** pour les besoins de permissions non couverts par les rôles built-in
- **RBAC Assignments** au niveau subscription et resource group pour les groupes Entra ID et les Managed Identities

**Ce qui est géré hors Bicep (scripts) :**

- Groupes Entra ID → `scripts/create-entra-groups.sh`
- Service Principals → `scripts/create-service-principals.sh`
- Conditional Access Policies → `scripts/configure-conditional-access.ps1`

> **Pourquoi séparer Entra ID de Bicep ?**  
> ARM/Bicep ne peut pas créer ni interroger des objets Entra ID. Les groupes et Service Principals
> vivent dans le tenant, hors du scope ARM. Les scripts créent ces objets en premier,
> puis leurs Object IDs sont passés en paramètres au déploiement Bicep.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Étape 1 — Scripts (hors Bicep)                             │
│                                                             │
│  create-entra-groups.sh          → Object IDs groupes       │
│  create-service-principals.sh    → Object IDs SPs           │
│  configure-conditional-access.ps1 → Policies Zero Trust     │
└─────────────────────────┬───────────────────────────────────┘
                          │ Object IDs passés en paramètres
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  Étape 2 — Bicep (identity/main.bicep)                      │
│                                                             │
│  managed_identity.bicep          → Managed Identities       │
│  custom_role_definition.bicep    → Rôles personnalisés       │
│  rbac_subscription_assignment    → RBAC niveau subscription  │
│  rbac_assignment.bicep           → RBAC niveau RG/ressource  │
└─────────────────────────────────────────────────────────────┘
```

---

## Ordre de déploiement

```bash
# 1. Créer les groupes Entra ID et récupérer les Object IDs
./scripts/create-entra-groups.sh

# 2. Créer les Service Principals
./scripts/create-service-principals.sh

# 3. Configurer Conditional Access (Zero Trust)
pwsh ./scripts/configure-conditional-access.ps1

# 4. Déployer Managed Identities, Custom Roles et RBAC
az deployment sub create \
  --name identity-lz-deploy \
  --location canadaeast \
  --template-file identity/main.bicep \
  --parameters identity/identity.bicepparam

# 5. Valider avec --what-if avant tout déploiement en production
az deployment sub what-if \
  --name identity-lz-deploy \
  --location canadaeast \
  --template-file identity/main.bicep \
  --parameters identity/identity.bicepparam
```

---

## Modules

---

### `custom_role_definition.bicep`

#### Description

Crée une définition de rôle RBAC personnalisé au scope subscription. À utiliser uniquement
lorsque les rôles built-in Azure ne couvrent pas précisément les besoins — par exemple,
permettre le démarrage/arrêt de VMs sans autoriser leur suppression.

> **Bonne pratique IaC** : Le paramètre `roleId` doit être une valeur **fixe et immuable**
> définie au premier déploiement. Changer `roleId` génère un nouveau GUID, crée une nouvelle
> définition de rôle et brise les assignments existants. `roleName` peut être modifié librement.

#### Utilisation

```bicep
// Rôle custom : opérateur VM (start/stop uniquement)
module customRoleVmOperator './modules/custom_role_definition.bicep' = {
  name: 'deploy-role-vm-operator'
  // targetScope = 'subscription' — appel depuis un orchestrateur subscription-scoped
  params: {
    roleId:                  'vm-operator-v1'            // ⚠️ NE JAMAIS CHANGER après déploiement
    roleName:                'Virtual Machine Operator'  // Peut évoluer librement
    customRoleDescription:   'Peut démarrer, arrêter et redémarrer des VMs sans les supprimer'
    actions: [
      'Microsoft.Compute/virtualMachines/start/action'
      'Microsoft.Compute/virtualMachines/restart/action'
      'Microsoft.Compute/virtualMachines/deallocate/action'
      'Microsoft.Compute/virtualMachines/read'
    ]
    notActions: [
      'Microsoft.Compute/virtualMachines/delete'
      'Microsoft.Compute/virtualMachines/write'
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

// Utiliser l'output pour assigner le rôle
module rbacMiVmOperator './modules/rbac_assignment.bicep' = {
  scope: resourceGroup(targetRg)
  name: 'rbac-mi-vm-operator'
  params: {
    principalId:            miPlatform.outputs.principalId
    roleDefinitionIdOrName: customRoleVmOperator.outputs.roleDefinitionId
    principalType:          'ServicePrincipal'
    assignmentScope:        resourceGroup(targetRg).id
  }
}
```

#### Requis

- L'orchestrateur appelant doit avoir `targetScope = 'subscription'`
- Permissions : `Owner` ou `User Access Administrator` au niveau subscription

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `roleName` | string | — | ✅ | Nom d'affichage du rôle (modifiable) |
| `roleId` | string | `roleName` | ✅ | Identifiant stable pour le GUID — **ne jamais changer après déploiement** |
| `customRoleDescription` | string | — | ✅ | Description du rôle |
| `actions` | array | — | ✅ | Actions ARM autorisées |
| `notActions` | array | `[]` | ❌ | Actions ARM explicitement refusées |
| `dataActions` | array | `[]` | ❌ | Actions sur les données autorisées |
| `notDataActions` | array | `[]` | ❌ | Actions sur les données refusées |
| `assignableScopes` | array | `[subscription().id]` | ❌ | Scopes où le rôle peut être assigné |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `roleDefinitionId` | string | Resource ID complet — à passer à `rbac_assignment.bicep` |
| `roleDefinitionName` | string | GUID de la définition (nom ARM) |
| `roleName` | string | Nom d'affichage du rôle |

#### Ressources créées

- `Microsoft.Authorization/roleDefinitions`

#### Dépendances

Aucune dépendance directe sur d'autres modules Bicep.

---

### `managed_identity.bicep`

#### Description

Crée une identité managée User-Assigned (UAMI). Les Managed Identities sont à privilégier
par rapport aux Service Principals avec secrets — elles n'ont pas de credentials à gérer
ni à faire tourner.

Chaque Managed Identity est créée avec un `Purpose` tag spécifique pour identifier sa fonction.
Son `principalId` est utilisé directement dans les modules RBAC pour lui assigner des rôles.

#### Utilisation

```bicep
// Créer une Managed Identity
module miPlatform './modules/managed_identity.bicep' = {
  scope: resourceGroup(identityResourceGroupName)
  name: 'deploy-mi-platform'
  params: {
    managedIdentityName: 'mi-acmy-sbox-caea-platform'
    location:            'caea'
    tags: union(globalTags, {
      Purpose: 'Platform-Management'
    })
  }
}

// Assigner un rôle à la Managed Identity (utiliser principalId)
module rbacPlatformMI './modules/rbac_subscription_assignment.bicep' = {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-platform-mi'
  params: {
    principalId:            miPlatform.outputs.principalId  // ← output direct
    roleDefinitionIdOrName: 'Contributor'
    principalType:          'ServicePrincipal'              // ← toujours ServicePrincipal pour les MIs
  }
}

// Attacher la Managed Identity à une VM
resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${miPlatform.outputs.managedIdentityId}': {}  // ← output direct
    }
  }
}
```

#### Requis

- Le resource group cible doit exister avant le déploiement
- Permissions : `Contributor` ou `Managed Identity Contributor` sur le resource group cible

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `managedIdentityName` | string | — | ✅ | Nom de la Managed Identity |
| `location` | string | — | ✅ | Région (`cace` = canadacentral, `caea` = canadaeast) |
| `tags` | object | `{}` | ❌ | Tags à associer à la ressource |

#### Outputs

| Output | Type | Usage typique |
|---|---|---|
| `managedIdentityId` | string | Attacher à une VM, App Service, etc. |
| `managedIdentityName` | string | Référence par nom dans d'autres modules |
| `principalId` | string | **Créer des role assignments RBAC** |
| `clientId` | string | Authentification dans le code applicatif |
| `tenantId` | string | Scénarios cross-tenant |

#### Ressources créées

- `Microsoft.ManagedIdentity/userAssignedIdentities`

#### Dépendances

Aucune dépendance directe. Le resource group cible doit exister (pré-requis opérationnel).

---

### `rbac_assignment.bicep`

#### Description

Assigne un rôle RBAC à un principal (groupe Entra ID, Managed Identity, Service Principal)
au scope d'un **resource group** ou d'une **ressource spécifique**.

Supporte les rôles built-in (par nom), les rôles custom (par resource ID complet),
et les GUIDs directs. Inclut le support des conditions RBAC pour des assignments
granulaires (ex: restreindre l'accès à un storage account précis).

> **Important** : `targetScope` est `resourceGroup` (défaut Bicep). Pour des assignments
> au niveau subscription, utiliser `rbac_subscription_assignment.bicep`.

#### Utilisation

```bicep
// Cas 1 — Rôle built-in sur un resource group
module rbacDevContributors './modules/rbac_assignment.bicep' = {
  scope: resourceGroup(devRgName)
  name: 'rbac-dev-contributors-rg'
  params: {
    principalId:            entraGroupIds.devContributors
    roleDefinitionIdOrName: 'Contributor'           // nom built-in
    principalType:          'Group'
    assignmentScope:        resourceGroup(devRgName).id
    roleAssignmentDescription: 'Dev team — Contributor sur RG dev'
  }
}

// Cas 2 — Rôle sur une ressource spécifique (Key Vault)
module rbacKvSecretsUser './modules/rbac_assignment.bicep' = {
  scope: resourceGroup(sharedRgName)
  name: 'rbac-mi-kv-secrets-user'
  params: {
    principalId:            miPlatform.outputs.principalId
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType:          'ServicePrincipal'
    assignmentScope:        keyVault.id             // ← ressource spécifique, pas le RG entier
    roleAssignmentDescription: 'Platform MI — lecture des secrets Key Vault'
  }
}

// Cas 3 — Rôle custom (output de custom_role_definition)
module rbacMiVmOperator './modules/rbac_assignment.bicep' = {
  scope: resourceGroup(computeRgName)
  name: 'rbac-mi-vm-operator'
  params: {
    principalId:            miPlatform.outputs.principalId
    roleDefinitionIdOrName: customRoleVmOperator.outputs.roleDefinitionId  // resource ID complet
    principalType:          'ServicePrincipal'
    assignmentScope:        resourceGroup(computeRgName).id
  }
}

// Cas 4 — Assignment avec condition RBAC
module rbacConditionalStorage './modules/rbac_assignment.bicep' = {
  scope: resourceGroup(storageRgName)
  name: 'rbac-analytics-storage-conditional'
  params: {
    principalId:            entraGroupIds.analyticsTeam
    roleDefinitionIdOrName: 'Storage Blob Data Reader'
    principalType:          'Group'
    assignmentScope:        storageAccount.id
    condition:              '(@Resource[Microsoft.Storage/storageAccounts/name] StringEquals \'stgprodanalytics\')'
    conditionVersion:       '2.0'
    roleAssignmentDescription: 'Analytics — lecture storage prod uniquement'
  }
}
```

#### Requis

- Le principal (`principalId`) doit exister avant le déploiement
- Permissions : `User Access Administrator` ou `Owner` sur le scope cible
- `scope:` du module et `assignmentScope:` param doivent être cohérents

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `principalId` | string | — | ✅ | Object ID du principal (groupe, MI, SP) |
| `roleDefinitionIdOrName` | string | — | ✅ | Nom built-in, resource ID complet, ou GUID |
| `assignmentScope` | string | — | ✅ | Resource ID du scope (RG, ressource). Doit correspondre au `scope:` du module |
| `principalType` | string | `ServicePrincipal` | ❌ | `User`, `Group`, `ServicePrincipal`, `ForeignGroup` |
| `roleAssignmentDescription` | string | `''` | ❌ | Description de l'assignment |
| `condition` | string | `''` | ❌ | Condition ABAC/RBAC |
| `conditionVersion` | string | `2.0` | ❌ | Version de la condition (toujours `2.0`) |
| `delegatedManagedIdentityResourceId` | string | `''` | ❌ | MI déléguée pour scénarios cross-tenant |

#### Rôles built-in supportés (mapping intégré)

`Owner`, `Contributor`, `Reader`, `AcrPull`, `AcrPush`, `Azure Kubernetes Service RBAC Admin`,
`Backup Contributor`, `Backup Operator`, `Backup Reader`, `Cosmos DB Account Reader Role`,
`Cost Management Contributor`, `Cost Management Reader`, `DocumentDB Account Contributor`,
`Key Vault Administrator`, `Key Vault Secrets User`, `Kubernetes Cluster Admin`,
`Monitoring Contributor`, `Monitoring Reader`, `Network Contributor`, `Security Admin`,
`Security Reader`, `Storage Blob Data Contributor`, `Storage Blob Data Reader`,
`Storage Queue Data Contributor`, `SQL DB Contributor`, `SQL Security Manager`,
`User Access Administrator`, `Virtual Machine Contributor`, `Website Contributor`

#### Outputs

| Output | Type | Description |
|---|---|---|
| `roleAssignmentId` | string | Resource ID complet de l'assignment |
| `roleAssignmentName` | string | GUID de l'assignment (nom ARM) |
| `principalId` | string | Principal auquel le rôle est assigné |
| `roleDefinitionId` | string | Resource ID de la définition de rôle |

#### Ressources créées

- `Microsoft.Authorization/roleAssignments`

#### Dépendances

- Le principal référencé (`principalId`) doit exister — groupe Entra ID, Managed Identity ou Service Principal
- Pour un rôle custom : `custom_role_definition.bicep` doit être déployé avant

---

### `rbac_subscription_assignment.bicep`

#### Description

Assigne un rôle RBAC à un principal au scope d'une **subscription entière**.
Variante de `rbac_assignment.bicep` avec `targetScope = 'subscription'`.

À utiliser pour les assignments larges : accès Reader sur toute une subscription,
Network Contributor pour les équipes réseau, etc. Pour des scopes plus granulaires
(resource group, ressource spécifique), utiliser `rbac_assignment.bicep`.

> **Note** : Les subscriptions optionnelles (logging, quarantine) doivent être
> protégées par `if (!empty(subscriptionId))` dans l'orchestrateur pour éviter
> des erreurs ARM avec `subscription('')`.

#### Utilisation

```bicep
// Cas 1 — Groupe Entra sur une subscription (toujours présente)
module rbacProdAdmins './modules/rbac_subscription_assignment.bicep' = if (!empty(prodSubscriptionId)) {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-prod-admins'
  params: {
    principalId:            entraGroupIds.prodAdmins
    roleDefinitionIdOrName: 'Contributor'
    principalType:          'Group'
    roleAssignmentDescription: 'Prod Admins — Contributor sur subscription prod'
  }
}

// Cas 2 — Managed Identity sur une subscription optionnelle
module rbacMonitoringMILogging './modules/rbac_subscription_assignment.bicep' = if (!empty(loggingSubscriptionId)) {
  scope: subscription(loggingSubscriptionId)
  name: 'rbac-monitoring-mi-logging'
  params: {
    principalId:            miMonitoring.outputs.principalId
    roleDefinitionIdOrName: 'Monitoring Reader'
    principalType:          'ServicePrincipal'
    roleAssignmentDescription: 'Monitoring MI — Reader sur subscription logging'
  }
}

// Cas 3 — Rôle custom au niveau subscription
module rbacCustomRole './modules/rbac_subscription_assignment.bicep' = if (!empty(prodSubscriptionId)) {
  scope: subscription(prodSubscriptionId)
  name: 'rbac-vm-operator-sub'
  params: {
    principalId:            entraGroupIds.opsTeam
    roleDefinitionIdOrName: customRole.outputs.roleDefinitionId  // resource ID complet
    principalType:          'Group'
    roleAssignmentDescription: 'Ops Team — VM Operator sur subscription prod'
  }
}
```

#### Requis

- Permissions : `User Access Administrator` ou `Owner` au niveau de la subscription cible
- La subscription cible doit être accessible depuis le tenant de déploiement
- L'orchestrateur appelant doit avoir `targetScope = 'subscription'`

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `principalId` | string | — | ✅ | Object ID du principal (groupe, MI, SP) |
| `roleDefinitionIdOrName` | string | — | ✅ | Nom built-in, resource ID complet, ou GUID |
| `principalType` | string | `ServicePrincipal` | ❌ | `User`, `Group`, `ServicePrincipal`, `ForeignGroup` |
| `roleAssignmentDescription` | string | `''` | ❌ | Description de l'assignment |
| `condition` | string | `''` | ❌ | Condition ABAC/RBAC |
| `conditionVersion` | string | `2.0` | ❌ | Version de la condition (toujours `2.0`) |

#### Rôles built-in supportés (mapping intégré)

`Owner`, `Contributor`, `Reader`, `Backup Contributor`, `Backup Operator`, `Backup Reader`,
`Cost Management Contributor`, `Cost Management Reader`, `Monitoring Contributor`,
`Monitoring Reader`, `Network Contributor`, `Security Admin`, `Security Reader`,
`User Access Administrator`

#### Outputs

| Output | Type | Description |
|---|---|---|
| `roleAssignmentId` | string | Resource ID complet de l'assignment |
| `roleAssignmentName` | string | GUID de l'assignment (nom ARM) |
| `principalId` | string | Principal auquel le rôle est assigné |
| `roleDefinitionId` | string | Resource ID de la définition de rôle |

#### Ressources créées

- `Microsoft.Authorization/roleAssignments`

#### Dépendances

- Le principal référencé (`principalId`) doit exister
- Pour un rôle custom : `custom_role_definition.bicep` doit être déployé avant

---

## Bonnes pratiques IaC

### Moindre privilège

```bicep
// ❌ Éviter — trop permissif
roleDefinitionIdOrName: 'Owner'

// ✅ Préférer — scope minimal nécessaire
roleDefinitionIdOrName: 'Storage Blob Data Contributor'
assignmentScope: storageAccount.id   // ressource spécifique, pas le RG entier
```

### Groupes plutôt qu'utilisateurs individuels

```bicep
// ❌ Éviter — maintenance difficile, audit complexe
principalId:   'object-id-utilisateur-individuel'
principalType: 'User'

// ✅ Préférer — gestion centralisée dans Entra ID
principalId:   entraGroupIds.devContributors
principalType: 'Group'
```

### Managed Identities plutôt que Service Principals avec secrets

```bicep
// ❌ Éviter — secrets à gérer, rotation, risque de fuite
// Service Principal avec clientSecret stocké dans Key Vault

// ✅ Préférer — pas de credential, rotation automatique
module miAppDeploy './modules/managed_identity.bicep' = {
  params: {
    managedIdentityName: 'mi-acmy-sbox-caea-app-deploy'
    location:            location
  }
}
```

### Subscriptions optionnelles — toujours utiliser des guards

```bicep
// ❌ Plante si loggingSubscriptionId = ''
module rbacLogging '...' = {
  scope: subscription(loggingSubscriptionId)  // subscription('') → erreur ARM
  ...
}

// ✅ Module ignoré si subscription pas encore disponible
module rbacLogging '...' = if (!empty(loggingSubscriptionId)) {
  scope: subscription(loggingSubscriptionId)
  ...
}
```

### Stabilité des GUIDs pour les rôles custom

```bicep
// ❌ Si roleName change → nouveau GUID → nouvelle définition → anciens assignments brisés
name: guid(subscription().id, roleName)

// ✅ roleId stable → GUID immuable même si roleName évolue
name: guid(subscription().id, roleId)   // roleId = 'vm-operator-v1' → fixe pour toujours
```

### Utiliser `--what-if` systématiquement

```bash
# Toujours valider avant de déployer en production
az deployment sub what-if \
  --name identity-lz-deploy \
  --location canadaeast \
  --template-file identity/main.bicep \
  --parameters identity/identity.bicepparam
```

---

## Troubleshooting

### `InvalidRoleDefinitionId` — rôle non trouvé dans le mapping

**Symptôme** : `The role definition ID 'Monitoring Reader' is not valid`

**Cause** : Le nom du rôle n'est pas dans `builtInRoleNames` du module utilisé.

**Solution** : Vérifier que le rôle est présent dans le mapping du module concerné
(`rbac_assignment.bicep` ou `rbac_subscription_assignment.bicep`). Les deux modules
ont des mappings distincts — un rôle présent dans l'un peut être absent de l'autre.

```bicep
// Alternative : passer le GUID directement
roleDefinitionIdOrName: '43d0d8ad-25c7-4714-9337-8ba259a9fe05'  // Monitoring Reader
```

### `RoleAssignmentExists` — assignment déjà présent

**Symptôme** : Conflit lors d'un redéploiement

**Cause** : Normal — le GUID de l'assignment est déterministe (`guid(principalId, roleDefinitionId, scope)`).
ARM tente de recréer un assignment identique.

**Solution** : Ce comportement est correct et idempotent. ARM ignore l'assignment existant
si identique, ou le met à jour si les propriétés ont changé.

### `AuthorizationFailed` — permissions insuffisantes

**Symptôme** : `The client does not have authorization to perform action 'Microsoft.Authorization/roleAssignments/write'`

**Solution** :
```bash
# Vérifier les rôles du service principal de déploiement
SP_ID=$(az ad sp show --id $APP_ID --query id -o tsv)
az role assignment list --assignee $SP_ID --output table

# Le SP doit avoir User Access Administrator ou Owner sur chaque subscription cible
az role assignment create \
  --assignee $SP_ID \
  --role 'User Access Administrator' \
  --scope /subscriptions/{subscription-id}
```

### `subscription('')` — subscription ID vide

**Symptôme** : Erreur ARM sur un module de subscription optionnelle

**Cause** : Paramètre `loggingSubscriptionId` ou `quarantineSubscriptionId` vide,
sans guard `if (!empty(...))` sur le module.

**Solution** : Ajouter le guard conditionnel sur tous les modules utilisant
des subscriptions optionnelles (voir section Bonnes pratiques).

---

## Ressources

- [Azure RBAC Built-in Roles](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles)
- [Managed Identities Overview](https://learn.microsoft.com/entra/identity/managed-identities-azure-resources/overview)
- [RBAC Conditions](https://learn.microsoft.com/azure/role-based-access-control/conditions-overview)
- [Bicep Modules Best Practices](https://learn.microsoft.com/azure/azure-resource-manager/bicep/best-practices)
- [Zero Trust Security](https://learn.microsoft.com/security/zero-trust/)
- [Conditional Access Deployment](https://learn.microsoft.com/entra/identity/conditional-access/plan-conditional-access)