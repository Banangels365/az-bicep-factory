# Azure Landing Zone - Identity

Ce repository contient les modules et scripts pour déployer l'**Identity Landing Zone** incluant la gestion Entra ID (Azure AD), Managed Identities et RBAC.

## 📋 Vue d'ensemble

L'Identity Landing Zone déploie :

- **Entra ID Groups** : Groupes organisés par fonction et environnement
- **Service Principals** : Identités pour l'automatisation
- **Managed Identities** : Identités pour les ressources Azure
- **RBAC Assignments** : Permissions basées sur les rôles
- **Conditional Access Policies** : Politiques de sécurité Zero Trust
- **Custom Role Definitions** : Rôles personnalisés pour besoins spécifiques

## 🏗️ Architecture Identity

```
┌─────────────────────────────────────────────────────┐
│           Entra ID (Azure AD)                       │
│                                                     │
│  ┌──────────────────┐  ┌──────────────────┐       │
│  │  Groups          │  │  Service          │       │
│  │  - Platform      │  │  Principals       │       │
│  │  - Network       │  │  - Platform SP    │       │
│  │  - Security      │  │  - Network SP     │       │
│  │  - Dev/Prod      │  │  - App Deploy SP  │       │
│  └──────────────────┘  └──────────────────┘       │
│                                                     │
│  ┌──────────────────┐  ┌──────────────────┐       │
│  │  Conditional     │  │  PIM (Privileged │       │
│  │  Access          │  │  Identity Mgmt)  │       │
│  │  - Require MFA   │  │  - JIT Access    │       │
│  │  - Block Legacy  │  │  - Approval      │       │
│  └──────────────────┘  └──────────────────┘       │
└─────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────┐
│           Azure Resources                           │
│                                                     │
│  ┌──────────────────┐  ┌──────────────────┐       │
│  │  Managed         │  │  RBAC             │       │
│  │  Identities      │  │  Assignments      │       │
│  │  - Platform MI   │  │  - Subscription   │       │
│  │  - Network MI    │  │  - Resource Group │       │
│  │  - Backup MI     │  │  - Resource       │       │
│  └──────────────────┘  └──────────────────┘       │
└─────────────────────────────────────────────────────┘
```

## 📦 Composants

### 1. Entra ID Groups

Groupes organisés par fonction :

**Platform Teams** :
- `contoso-Platform-Admins` : Administrateurs de la plateforme
- `contoso-Platform-Contributors` : Contributeurs plateforme
- `contoso-Network-Admins` : Administrateurs réseau
- `contoso-Security-Admins` : Administrateurs sécurité

**Environment Teams** :
- `contoso-Dev-Admins/Contributors/Readers`
- `contoso-Staging-Admins/Contributors`
- `contoso-Prod-Admins/Contributors/Readers`

**Application Teams** :
- `contoso-App-Developers` : Développeurs d'applications
- `contoso-App-Deployers` : Équipe de déploiement
- `contoso-DB-Admins` : Administrateurs de bases de données

**Cost Management** :
- `contoso-Cost-Managers` : Gestionnaires de coûts
- `contoso-Billing-Readers` : Lecteurs facturation

### 2. Service Principals

Service Principals pour l'automatisation :

- `sp-contoso-platform-prod` : Gestion de la plateforme
- `sp-contoso-network-prod` : Gestion du réseau
- `sp-contoso-app-deploy-prod` : Déploiement d'applications
- `sp-contoso-monitoring-prod` : Monitoring (lecture seule)
- `sp-contoso-backup-prod` : Opérations de sauvegarde

### 3. Managed Identities

Identités managées pour les ressources Azure :

- `mi-contoso-platform-prod` : Identity pour ressources plateforme
- `mi-contoso-network-prod` : Identity pour ressources réseau
- `mi-contoso-app-deploy-prod` : Identity pour déploiements
- `mi-contoso-backup-prod` : Identity pour sauvegardes
- `mi-contoso-monitoring-prod` : Identity pour monitoring

### 4. Conditional Access Policies

Politiques Zero Trust :

- **CA001** : Require MFA for Administrators (Enabled)
- **CA002** : Require MFA for All Users (Report-Only)
- **CA003** : Block Legacy Authentication (Enabled)
- **CA004** : Require Compliant Device (Report-Only)
- **CA005** : Require Approved App for Mobile (Report-Only)
- **CA006** : Require MFA from Untrusted Locations (Report-Only)

## 🚀 Déploiement

### Prérequis

1. **Permissions Azure AD** :
   - Global Administrator OU
   - Privileged Role Administrator + Groups Administrator

2. **Permissions Azure** :
   - Owner sur les subscriptions cibles
   - User Access Administrator au niveau root

3. **Outils** :
   - Azure CLI >= 2.50.0
   - PowerShell 7+ avec Microsoft.Graph module
   - Bicep CLI >= 0.24.0

### Ordre de déploiement

```bash
# Étape 1 : Créer les groupes Entra ID
cd scripts/identity
chmod +x create-entra-groups.sh
./create-entra-groups.sh

# Étape 2 : Créer les Service Principals
chmod +x create-service-principals.sh
./create-service-principals.sh

# Étape 3 : Configurer Conditional Access
pwsh configure-conditional-access.ps1

# Étape 4 : Déployer Managed Identities et RBAC avec Bicep
cd ../../identity
az deployment sub create \
  --name identity-deployment \
  --location canadacentral \
  --template-file main.bicep \
  --parameters main.bicepparam
```

### Déploiement complet via script

```bash
# Script de déploiement complet
./scripts/deploy-identity-complete.sh
```

## 🔐 Gestion des groupes

### Ajouter un utilisateur à un groupe

```bash
# Obtenir l'Object ID de l'utilisateur
USER_ID=$(az ad user show --id user@contoso.com --query id -o tsv)

# Obtenir l'Object ID du groupe
GROUP_ID=$(az ad group show --group "contoso-Dev-Admins" --query id -o tsv)

# Ajouter l'utilisateur au groupe
az ad group member add \
  --group $GROUP_ID \
  --member-id $USER_ID
```

### Lister les membres d'un groupe

```bash
az ad group member list \
  --group "contoso-Platform-Admins" \
  --query "[].{Name: displayName, Email: mail, Type: '@odata.type'}" \
  --output table
```

## 👤 Gestion des Service Principals

### Créer un nouveau Service Principal

```bash
# Créer avec secret
az ad sp create-for-rbac \
  --name "sp-myapp-prod" \
  --role Contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/{rg-name}

# Sortie (SAUVEGARDER LE SECRET!)
{
  "appId": "xxx",
  "displayName": "sp-myapp-prod",
  "password": "xxx",  # À stocker dans Key Vault
  "tenant": "xxx"
}
```

### Configurer Federated Identity pour GitHub Actions

```bash
APP_ID="xxx"  # App ID du Service Principal

az ad app federated-credential create \
  --id $APP_ID \
  --parameters '{
    "name": "github-prod",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:myorg/myrepo:environment:production",
    "audiences": ["api://AzureADTokenExchange"]
  }'
```

## 🎯 RBAC Best Practices

### Principe du moindre privilège

```bicep
// ❌ MAUVAIS : Donner Owner à tout le monde
roleDefinitionIdOrName: 'Owner'

// ✅ BON : Donner le rôle minimum nécessaire
roleDefinitionIdOrName: 'Storage Blob Data Contributor'
```

### Utiliser les groupes, pas les utilisateurs individuels

```bicep
// ❌ MAUVAIS : Assigner directement à un utilisateur
principalId: 'user-object-id'

// ✅ BON : Assigner à un groupe
principalId: 'dev-admins-group-id'
principalType: 'Group'
```

### Utiliser Managed Identities au lieu de Service Principals

```bicep
// ❌ ÉVITER : Service Principal avec secret
// Requiert gestion du secret, rotation, etc.

// ✅ PRÉFÉRER : Managed Identity
resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
}
```

## 📊 Rôles RBAC courants

### Built-in Roles

| Rôle | Usage | Scope recommandé |
|------|-------|------------------|
| Owner | Administration complète | Subscription (limité) |
| Contributor | Gérer ressources (pas RBAC) | Resource Group |
| Reader | Lecture seule | Subscription |
| Network Contributor | Gérer réseaux | Subscription/RG |
| Storage Blob Data Contributor | Gérer données blob | Storage Account |
| Key Vault Secrets User | Lire secrets | Key Vault |
| AcrPull | Pull images container | Container Registry |
| Monitoring Reader | Voir métriques | Subscription |
| Cost Management Reader | Voir coûts | Subscription |

### Custom Roles (Exemples)

```bicep
// Rôle custom : VM Operator (start/stop seulement)
module customRole 'modules/identity/custom-role-definition/main.bicep' = {
  scope: subscription()
  params: {
    roleName: 'Virtual Machine Operator'
    description: 'Can start and stop VMs but cannot delete or modify'
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
  }
}
```

## 🔒 Conditional Access

### Activer progressivement

1. **Phase 1** : Report-Only mode
   ```powershell
   # Toutes les nouvelles policies en report-only
   State = "enabledForReportingButNotEnforced"
   ```

2. **Phase 2** : Tester avec groupe pilote
   ```powershell
   # Ajouter groupe pilote
   IncludeGroups = @("CA-Pilot-Users")
   ```

3. **Phase 3** : Activer pour tous
   ```powershell
   State = "enabled"
   ```

### Groupes d'exclusion critiques

**TOUJOURS** avoir un groupe d'exclusion pour les comptes d'urgence :

```powershell
# Créer groupe break-glass
$breakGlass = New-MgGroup -DisplayName "CA-BreakGlass-Exclusions" `
  -MailEnabled:$false `
  -SecurityEnabled:$true

# Ajouter aux exclusions de TOUTES les policies
ExcludeGroups = @($breakGlass.Id)
```

### Tester les policies

```powershell
# Voir l'impact avant activation
Get-MgIdentityConditionalAccessPolicy | 
  Where-Object {$_.State -eq "enabledForReportingButNotEnforced"} |
  Select-Object DisplayName, State
```

## 📈 Monitoring & Audit

### Requêtes KQL utiles

```kql
// Connexions bloquées par Conditional Access
SigninLogs
| where TimeGenerated > ago(24h)
| where ConditionalAccessStatus == "failure"
| summarize Count = count() by UserPrincipalName, AppDisplayName, ConditionalAccessPolicies
| order by Count desc

// Changements RBAC
AzureActivity
| where TimeGenerated > ago(7d)
| where OperationNameValue contains "roleAssignments"
| project TimeGenerated, Caller, OperationNameValue, ResourceGroup
| order by TimeGenerated desc

// Créations de Service Principals
AuditLogs
| where TimeGenerated > ago(30d)
| where OperationName == "Add service principal"
| project TimeGenerated, InitiatedBy = tostring(InitiatedBy.user.userPrincipalName), 
          TargetResources[0].displayName
```

### Alertes recommandées

1. **Nouvelle assignation Owner** : Alert quand role Owner est assigné
2. **SP credentials exposed** : Alert sur réinitialisation de secret SP
3. **CA policy disabled** : Alert si policy CA est désactivée
4. **Failed admin sign-ins** : Alert sur échecs de connexion admin

## 🛠️ Troubleshooting

### Erreur : Insufficient privileges

**Problème** : "Insufficient privileges to complete the operation"

**Solution** :
```bash
# Vérifier vos rôles
az role assignment list --assignee $(az ad signed-in-user show --query id -o tsv)

# Demander Global Admin ou Privileged Role Admin
```

### Erreur : Group already exists

**Problème** : Le groupe existe déjà

**Solution** :
```bash
# Le script gère déjà les doublons, mais manuellement:
GROUP_ID=$(az ad group show --group "contoso-Platform-Admins" --query id -o tsv)
echo "Groupe existant: $GROUP_ID"
```

### Service Principal sans permissions

**Problème** : SP créé mais sans accès

**Solution** :
```bash
# Lister les role assignments du SP
SP_OBJECT_ID=$(az ad sp show --id $APP_ID --query id -o tsv)
az role assignment list --assignee $SP_OBJECT_ID

# Assigner le rôle manquant
az role assignment create \
  --assignee $SP_OBJECT_ID \
  --role Contributor \
  --scope /subscriptions/{subscription-id}
```

## 📚 Ressources

- [Azure AD Best Practices](https://learn.microsoft.com/entra/architecture/security-operations-introduction)
- [Conditional Access Deployment](https://learn.microsoft.com/entra/identity/conditional-access/plan-conditional-access)
- [Managed Identities](https://learn.microsoft.com/entra/identity/managed-identities-azure-resources/overview)
- [RBAC Best Practices](https://learn.microsoft.com/azure/role-based-access-control/best-practices)
- [Zero Trust Security](https://learn.microsoft.com/security/zero-trust/)

---

**Version** : 1.0.0  
**Dernière mise à jour** : Février 2026  
**Mainteneur** : IdentityOps Team