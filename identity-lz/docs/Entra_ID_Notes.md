# Gestion Entra ID (Azure AD) avec Bicep

## ⚠️ Limitations importantes

### Bicep et Azure AD

**Bicep natif ne supporte PAS** :
- Création de groupes Entra ID
- Création de Service Principals
- Conditional Access Policies
- Gestion des utilisateurs
- Application Registrations

### Pourquoi ?

Bicep est conçu pour gérer les ressources **Azure Resource Manager (ARM)**. Entra ID (anciennement Azure AD) est géré via **Microsoft Graph API**, pas ARM.

## 🔧 Solutions disponibles

### Option 1 : Utiliser l'extension Microsoft Graph (Bicep - Preview)

Microsoft a introduit une extension Bicep expérimentale pour Microsoft Graph :

```bicep
extension microsoftGraph

resource group 'Microsoft.Graph/groups@v1.0' = {
  displayName: 'MyGroup'
  mailEnabled: false
  mailNickname: 'mygroup'
  securityEnabled: true
}
```

**⚠️ Statut** : Preview/Experimental - Non recommandé pour production

### Option 2 : Azure CLI dans les pipelines

Créer un script Azure CLI/PowerShell appelé depuis votre pipeline :

```bash
# create-entra-resources.sh
az ad group create \
  --display-name "Application-Admins" \
  --mail-nickname "app-admins" \
  --description "Administrators for Application"

az ad sp create-for-rbac \
  --name "sp-myapp-prod" \
  --role Contributor \
  --scopes /subscriptions/{subscription-id}
```

### Option 3 : Terraform (Recommandé pour Entra ID)

Utiliser Terraform avec le provider AzureAD pour Entra ID :

```hcl
resource "azuread_group" "app_admins" {
  display_name     = "Application-Admins"
  mail_enabled     = false
  security_enabled = true
}

resource "azuread_service_principal" "app_sp" {
  application_id = azuread_application.app.application_id
}
```

### Option 4 : Deployment Scripts dans Bicep

Utiliser des Deployment Scripts pour exécuter Azure CLI/PowerShell :

```bicep
resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'create-ad-group'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.40.0'
    scriptContent: '''
      az ad group create \
        --display-name "Application-Admins" \
        --mail-nickname "app-admins"
    '''
    retentionInterval: 'P1D'
  }
}
```

## 📋 Approche recommandée pour ce projet

### Architecture hybride : Bicep + Scripts

1. **Bicep** : Pour toutes les ressources Azure (VNets, Storage, VMs, etc.)
2. **Azure CLI Scripts** : Pour les ressources Entra ID
3. **Azure DevOps Pipeline** : Orchestrer les deux

### Workflow suggéré

```yaml
# Pipeline structure
stages:
  - stage: Identity
    jobs:
      - job: CreateEntraIDResources
        steps:
          - script: ./scripts/create-entra-groups.sh
          - script: ./scripts/create-service-principals.sh
          - script: ./scripts/configure-conditional-access.sh
  
  - stage: Infrastructure
    dependsOn: Identity
    jobs:
      - job: DeployBicep
        steps:
          - task: AzureCLI@2
            inputs:
              scriptType: 'bash'
              scriptLocation: 'inlineScript'
              inlineScript: |
                az deployment sub create \
                  --template-file main.bicep \
                  --parameters principalId=$(sp_principal_id)
```

## 🔑 Ce que nous pouvons faire avec Bicep

### ✅ Géré par Bicep natif

- Managed Identities (User-Assigned et System-Assigned)
- RBAC Role Assignments
- Custom RBAC Role Definitions
- Key Vault Access Policies
- Federated Identities (pour GitHub Actions, etc.)

### ❌ Nécessite Azure CLI/PowerShell/Graph API

- Entra ID Groups
- Entra ID Users
- Service Principals / App Registrations
- Conditional Access Policies
- Administrative Units
- Privileged Identity Management (PIM)

## 📝 Templates fournis dans ce projet

Dans les sections suivantes, je fournirai :

1. **Scripts Azure CLI** complets pour Entra ID
2. **Modules Bicep** pour Managed Identities et RBAC
3. **Deployment Scripts Bicep** pour orchestrer Entra ID
4. **Pipeline Azure DevOps** intégrant le tout

Cette approche vous donne le meilleur des deux mondes : Infrastructure as Code avec Bicep + gestion Entra ID scriptée.