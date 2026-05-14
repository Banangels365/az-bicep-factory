# Azure Landing Zone - Platform

Ce repository contient les modules Bicep et l'orchestration pour déployer la **Platform Landing Zone** Azure selon les recommandations Microsoft Cloud Adoption Framework (CAF).

## 📋 Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Architecture](#architecture)
- [Prérequis](#prérequis)
- [Structure du projet](#structure-du-projet)
- [Déploiement](#déploiement)
- [Modules disponibles](#modules-disponibles)
- [Gestion des Policies](#gestion-des-policies)
- [Logging et monitoring](#logging-et-monitoring)
- [Bonnes pratiques](#bonnes-pratiques)

## 🎯 Vue d'ensemble

Cette Landing Zone Platform déploie :

- **Hiérarchie de Management Groups** : Organisation des subscriptions selon le modèle CAF
- **Azure Policies** : Gouvernance et compliance automatisée
- **Log Analytics Workspace** : Logging centralisé pour toutes les ressources
- **Microsoft Sentinel** : SIEM pour la sécurité (optionnel)
- **Diagnostic Settings** : Configuration automatique des logs

## 🏗️ Architecture

### Hiérarchie des Management Groups

```
Tenant Root Group
└── contoso-root
    ├── contoso-platform
    │   ├── Management
    │   ├── Identity
    │   └── Connectivity
    ├── contoso-landing-zones
    │   ├── contoso-dev
    │   ├── contoso-staging
    │   └── contoso-prod
    ├── contoso-sandbox
    └── contoso-decommissioned
```

### Flux de déploiement

1. **Management Groups** → Création de la hiérarchie organisationnelle
2. **Policy Definitions** → Définition des règles de gouvernance
3. **Policy Initiatives** → Regroupement des policies en ensembles cohérents
4. **Platform Resources** → Déploiement du Log Analytics Workspace et Sentinel
5. **Policy Assignments** → Application des policies aux Management Groups

## ✅ Prérequis

### Outils requis

- **Azure CLI** >= 2.50.0
- **Bicep CLI** >= 0.24.0
- **PowerShell** >= 7.0 (pour les scripts de déploiement)
- **Git** (pour le versioning)

### Permissions Azure requises

- **User Access Administrator** au niveau Tenant Root Group
- **Contributor** sur la subscription de management
- **Policy Contributor** au niveau Tenant Root Group

### Installation des outils

```bash
# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Bicep CLI
az bicep install

# PowerShell 7
wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.0/powershell_7.4.0-1.deb_amd64.deb
sudo dpkg -i powershell_7.4.0-1.deb_amd64.deb
```

## 📁 Structure du projet

```
azure-landing-zone/
├── platform/
│   ├── main.bicep                    # Orchestrateur principal
│   ├── main.bicepparam               # Paramètres de déploiement
│   ├── management-groups/
│   ├── policy/
│   │   ├── definitions/
│   │   │   └── custom-policies.bicep
│   │   └── assignments/
│   ├── logging/
│   └── security/
├── modules/
│   └── management/
│       ├── management-group/
│       ├── policy-definition/
│       ├── policy-assignment/
│       ├── policy-initiative/
│       ├── log-analytics-workspace/
│       └── diagnostic-settings/
└── scripts/
    └── deploy-platform.ps1
```

## 🚀 Déploiement

### 1. Configuration initiale

Éditez le fichier `platform/main.bicepparam` avec vos paramètres :

```bicep
param organizationName = 'votre-organisation'
param managementSubscriptionId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
param devSubscriptionIds = ['sub-id-1', 'sub-id-2']
param stagingSubscriptionIds = ['sub-id-3']
param prodSubscriptionIds = ['sub-id-4', 'sub-id-5']
```

### 2. Connexion à Azure

```bash
az login
az account set --subscription "Management-Subscription"
```

### 3. Validation (WhatIf)

```powershell
# Valider sans déployer
.\scripts\deploy-platform.ps1 -Environment prod -Location canadacentral -WhatIf
```

### 4. Déploiement

```powershell
# Déploiement complet
.\scripts\deploy-platform.ps1 -Environment prod -Location canadacentral
```

### 5. Déploiement manuel avec Azure CLI

```bash
# Déploiement au niveau Tenant
az deployment tenant create \
  --name platform-deployment \
  --location canadacentral \
  --template-file platform/main.bicep \
  --parameters platform/main.bicepparam
```

## 🧩 Modules disponibles

### Management Group

Crée un Management Group dans la hiérarchie Azure.

```bicep
module mg 'modules/management/management-group/main.bicep' = {
  scope: managementGroup()
  params: {
    managementGroupId: 'mg-prod'
    displayName: 'Production'
    parentManagementGroupId: 'mg-root'
    subscriptionIds: ['sub-id-1']
  }
}
```

### Policy Definition

Définit une Azure Policy personnalisée.

```bicep
module policy 'modules/management/policy-definition/main.bicep' = {
  scope: managementGroup('mg-root')
  params: {
    policyName: 'require-tags'
    displayName: 'Require mandatory tags'
    mode: 'Indexed'
    policyRule: { ... }
  }
}
```

### Policy Initiative

Regroupe plusieurs policies en une initiative.

```bicep
module initiative 'modules/management/policy-initiative/main.bicep' = {
  scope: managementGroup('mg-root')
  params: {
    initiativeName: 'baseline-security'
    displayName: 'Baseline Security Policies'
    policyDefinitions: [...]
  }
}
```

### Policy Assignment

Assigne une policy ou initiative à un scope.

```bicep
module assignment 'modules/management/policy-assignment/main.bicep' = {
  scope: managementGroup('mg-prod')
  params: {
    assignmentName: 'prod-baseline'
    policyDefinitionId: initiative.outputs.initiativeId
    identityType: 'SystemAssigned'
    enforcementMode: 'Default'
  }
}
```

### Log Analytics Workspace

Déploie un workspace Log Analytics centralisé.

```bicep
module law 'modules/management/log-analytics-workspace/main.bicep' = {
  scope: resourceGroup('rg-management')
  params: {
    workspaceName: 'law-platform-prod'
    retentionInDays: 90
    enableSentinel: true
    solutions: ['SecurityInsights', 'Updates']
  }
}
```

## 🔒 Gestion des Policies

### Policies personnalisées incluses

1. **enforce-https-storage-accounts** : Force HTTPS uniquement pour les Storage Accounts
2. **enforce-minimum-tls-version** : Force TLS 1.2 minimum
3. **deny-public-ip-addresses** : Empêche la création de Public IPs (sauf exceptions)
4. **require-private-endpoints-paas** : Exige des Private Endpoints pour les PaaS
5. **require-diagnostic-settings** : Force l'activation des logs de diagnostic
6. **enforce-naming-convention** : Applique les conventions de nommage
7. **allowed-vm-skus** : Limite les SKUs de VMs autorisées

### Mode d'enforcement par environnement

- **Production** : `Default` (Enforcement activé)
- **Staging** : `Default` (Enforcement activé)
- **Dev** : `DoNotEnforce` (Audit uniquement)
- **Sandbox** : `DoNotEnforce` (Audit uniquement)

### Ajout d'une nouvelle policy

1. Créer le fichier de définition dans `platform/policy/definitions/`
2. Ajouter la policy à l'initiative dans `platform/main.bicep`
3. Assigner l'initiative mise à jour aux Management Groups appropriés

## 📊 Logging et monitoring

### Log Analytics Workspace

Tous les logs sont centralisés dans un workspace Log Analytics unique :

- **Retention** : 90 jours par défaut (configurable)
- **Solutions déployées** :
  - SecurityInsights (Sentinel)
  - Updates
  - VMInsights
  - ChangeTracking
  - AzureActivity
  - AgentHealthAssessment

### Diagnostic Settings

Les diagnostic settings sont automatiquement configurés via Policy sur :

- Storage Accounts
- Key Vaults
- SQL Databases
- Virtual Networks
- Network Security Groups
- Virtual Machines

### Requêtes KQL utiles

```kql
// Ressources non-conformes aux policies
PolicyResources
| where type == "microsoft.policyinsights/policystates"
| where properties.complianceState == "NonCompliant"
| summarize Count = count() by tostring(properties.policyDefinitionName)

// Activité d'administration
AzureActivity
| where OperationNameValue contains "write" or OperationNameValue contains "delete"
| summarize Count = count() by Caller, OperationNameValue
| order by Count desc
```

## 📚 Bonnes pratiques

### Naming conventions

Suivez les conventions Microsoft pour nommer vos ressources :

- Management Groups : `{org}-{environment}` (ex: `contoso-prod`)
- Resource Groups : `rg-{workload}-{environment}-{region}` (ex: `rg-platform-prod-canadacentral`)
- Log Analytics : `law-{purpose}-{environment}` (ex: `law-platform-prod`)

### Tagging strategy

Tags obligatoires (appliqués via Policy) :

- **Environment** : dev, staging, prod
- **CostCenter** : Centre de coûts
- **Owner** : Équipe responsable
- **ManagedBy** : Bicep, Terraform, Portal

### Sécurité

- ✅ Toujours activer les Private Endpoints pour les PaaS
- ✅ Forcer HTTPS et TLS 1.2 minimum
- ✅ Activer les diagnostic settings sur toutes les ressources
- ✅ Utiliser des Managed Identities plutôt que des secrets
- ✅ Appliquer le principe du moindre privilège (RBAC)

### Déploiements

- ✅ Toujours tester avec `--what-if` avant de déployer
- ✅ Utiliser des fichiers de paramètres séparés par environnement
- ✅ Versionner tous les changements dans Git
- ✅ Automatiser via Azure DevOps Pipelines
- ✅ Implémenter des approbations manuelles pour la production

## 🔧 Troubleshooting

### Erreur : Insufficient permissions

**Problème** : Vous n'avez pas les permissions nécessaires au niveau Tenant Root.

**Solution** :
```bash
# Demandez à un administrateur de vous accorder le rôle User Access Administrator
az role assignment create \
  --assignee <your-user-id> \
  --role "User Access Administrator" \
  --scope "/"
```

### Erreur : Management Group already exists

**Problème** : Le Management Group existe déjà.

**Solution** : Modifiez le nom dans les paramètres ou supprimez l'ancien Management Group.

### Erreur : Policy assignment failed

**Problème** : L'assignment de policy échoue.

**Solution** : Vérifiez que la policy definition ou initiative existe et que vous avez les permissions nécessaires.

## 📞 Support

Pour toute question ou problème :

1. Consultez la [documentation Microsoft Azure Landing Zones](https://aka.ms/alz)
2. Ouvrez une issue dans ce repository
3. Contactez l'équipe Cloud Platform Engineering

## 📝 Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

---

**Dernière mise à jour** : Février 2026  
**Version** : 1.0.0  
**Mainteneur** : CloudOps Team