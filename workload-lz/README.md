# Azure Landing Zone - Workload (3-Tier Application)

Ce repository contient les modules Bicep pour déployer une **Workload Landing Zone** complète avec une architecture 3-tier.

## 📋 Vue d'ensemble

Cette Workload Landing Zone déploie une application complète avec :

- **Spoke VNet** : Réseau isolé avec 4 sous-réseaux (web, app, data, private endpoints)
- **App Service** : Application web avec Private Endpoint et VNet integration
- **Azure SQL Database** : Base de données avec Private Endpoint et Azure AD auth
- **Storage Account** : Stockage avec Private Endpoint
- **Key Vault** : Gestion des secrets avec Private Endpoint et RBAC
- **Application Insights** : Monitoring applicatif
- **Managed Identity** : Authentification sans secret
- **NSGs & Routes** : Sécurité réseau et routage via Firewall

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Hub VNet (10.0.0.0/16)                   │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Firewall   │  │  VPN Gateway │  │   Bastion    │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└──────────────────────────┬──────────────────────────────────┘
                           │ VNet Peering
                           ▼
┌─────────────────────────────────────────────────────────────┐
│              Spoke VNet (10.3.0.0/20) - CRM App             │
│                                                             │
│  ┌─────────────────────────────────────────────────┐        │
│  │  Web Tier (10.3.0.0/24)                         │        │
│  │  - App Service (Private Endpoint)               │        │
│  │  - Inbound: HTTPS from Internet (via Firewall)  │        │
│  │  - Outbound: App tier only                      │        │
│  └─────────────────────────────────────────────────┘        │
│                           │                                 │
│                           ▼                                 │
│  ┌─────────────────────────────────────────────────┐        │
│  │  App Tier (10.3.1.0/24)                         │        │
│  │  - App Service VNet Integration                 │        │
│  │  - Business logic, API calls                    │        │
│  │  - Inbound: Web tier only                       │        │
│  │  - Outbound: Data tier, Private Endpoints       │        │
│  └─────────────────────────────────────────────────┘        │
│                           │                                 │
│                           ▼                                 │
│  ┌─────────────────────────────────────────────────┐        │
│  │  Data Tier (10.3.2.0/24)                        │        │
│  │  - SQL Server (Private Endpoint)                │        │
│  │  - No direct internet access                    │        │
│  │  - Inbound: App tier only                       │        │
│  └─────────────────────────────────────────────────┘        │
│                                                             │
│  ┌─────────────────────────────────────────────────┐        │
│  │  Private Endpoints Subnet (10.3.4.0/24)         │        │
│  │  - Key Vault PE                                 │        │
│  │  - Storage Account PE                           │        │
│  │  - SQL Server PE                                │        │
│  │  - App Service PE                               │        │
│  └─────────────────────────────────────────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

## 📦 Composants déployés

### Infrastructure Réseau

| Ressource | Nom | CIDR | Usage |
|-----------|-----|------|-------|
| VNet | vnet-contoso-crm-prod | 10.3.0.0/20 | Réseau spoke isolé |
| Subnet Web | snet-crm-web-prod | 10.3.0.0/24 | Tier web (App Service PE) |
| Subnet App | snet-crm-app-prod | 10.3.1.0/24 | Tier app (VNet integration) |
| Subnet Data | snet-crm-data-prod | 10.3.2.0/24 | Tier data (DB) |
| Subnet PE | snet-crm-privateendpoints-prod | 10.3.4.0/24 | Private Endpoints |
| NSG Web | nsg-crm-web-prod | - | Sécurité tier web |
| NSG App | nsg-crm-app-prod | - | Sécurité tier app |
| NSG Data | nsg-crm-data-prod | - | Sécurité tier data |
| NSG PE | nsg-crm-pe-prod | - | Sécurité PE |
| Route Table | rt-crm-web/app/data-prod | - | Routage via Firewall |

### Services Applicatifs

| Ressource | Nom | SKU | Configuration |
|-----------|-----|-----|---------------|
| App Service Plan | asp-contoso-crm-prod | P1v3 | Linux, .NET 8 |
| App Service | app-contoso-crm-prod | - | Private Endpoint, VNet Integration |
| SQL Server | sql-contoso-crm-prod | - | Private Endpoint, Azure AD auth |
| SQL Database | crm-db-prod | GP_Gen5_2 | 256 GB, Zone redundant |
| Storage Account | stcontosocrmproduniqueXXX | Standard_GRS | Private Endpoint, Soft delete |
| Key Vault | kv-crm-prod-uniqueXXX | Premium | Private Endpoint, RBAC |
| Application Insights | appi-contoso-crm-prod | - | 90 days retention |

### Sécurité

- **Managed Identity** : User-Assigned pour l'App Service
- **RBAC** : 
  - App Service → Key Vault Secrets User
  - App Service → Storage Blob Data Contributor
- **Private Endpoints** : Tous les services PaaS
- **Network Isolation** : Pas d'accès public direct
- **TLS 1.2** : Obligatoire partout
- **Encryption** : TDE pour SQL, encryption at rest pour Storage

## 🚀 Déploiement

### Prérequis

Les Landing Zones suivantes doivent être déployées au préalable :

1. ✅ **Platform** : Management Groups, Policies, Log Analytics
2. ✅ **Connectivity** : Hub VNet, Firewall, VPN, Bastion
3. ✅ **Identity** : Groups, Managed Identities, RBAC

### Préparer les Private DNS Zones

Avant le déploiement, créer les Private DNS Zones dans le Hub :

```bash
# Se connecter à la subscription Hub
az account set --subscription "Connectivity-Subscription"

RG_HUB="rg-contoso-hub-prod-canadacentral"
HUB_VNET_ID="/subscriptions/xxx/resourceGroups/$RG_HUB/providers/Microsoft.Network/virtualNetworks/vnet-contoso-hub-prod-canadacentral"

# Créer les Private DNS Zones
az network private-dns zone create \
  --resource-group $RG_HUB \
  --name privatelink.azurewebsites.net

az network private-dns zone create \
  --resource-group $RG_HUB \
  --name privatelink.database.windows.net

az network private-dns zone create \
  --resource-group $RG_HUB \
  --name privatelink.blob.core.windows.net

az network private-dns zone create \
  --resource-group $RG_HUB \
  --name privatelink.vaultcore.azure.net

# Lier les zones au Hub VNet
for zone in privatelink.azurewebsites.net \
            privatelink.database.windows.net \
            privatelink.blob.core.windows.net \
            privatelink.vaultcore.azure.net; do
  az network private-dns link vnet create \
    --resource-group $RG_HUB \
    --zone-name $zone \
    --name link-to-hub \
    --virtual-network $HUB_VNET_ID \
    --registration-enabled false
done
```

### Modifier les paramètres

Éditez `workloads/app-example/main.bicepparam` :

1. **Remplacer les IDs** :
   - `hubVnetId` : ID du Hub VNet
   - `managedIdentityId` : ID de la Managed Identity
   - `logAnalyticsWorkspaceId` : ID du Log Analytics Workspace
   - Private DNS Zone IDs

2. **Configurer l'application** :
   - `workloadName` : Nom de votre application
   - `appServicePlanSku` : Taille selon besoin
   - `sqlDatabaseSku` : Taille selon besoin

3. **Sécurité** :
   - `sqlAdminPassword` : Utilisez un secret fort (ou Azure DevOps variable)
   - `sqlAzureADAdminObjectId` : Group ID des DB Admins

### Déployer la Workload

```bash
# Se connecter à Azure
az login
az account set --subscription "Prod-Subscription"

# Valider le déploiement
az deployment sub validate \
  --location canadacentral \
  --template-file workloads/app-example/main.bicep \
  --parameters workloads/app-example/main.bicepparam

# Déployer
az deployment sub create \
  --name crm-workload-deployment \
  --location canadacentral \
  --template-file workloads/app-example/main.bicep \
  --parameters workloads/app-example/main.bicepparam
```

Le déploiement prend environ **15-20 minutes**.

## 🔒 Sécurité et Conformité

### Flux réseau

```
Internet → Azure Firewall → Web Subnet → App Subnet → Data Subnet
                                ↓
                         Private Endpoints Subnet
                         (Key Vault, Storage, SQL)
```

### Règles NSG (Résumé)

**Web Tier** :
- ✅ Allow : HTTPS (443) from Internet
- ✅ Allow : HTTP (80) from Internet (redirect to HTTPS)
- ✅ Allow : All to App tier
- ❌ Deny : All other inbound

**App Tier** :
- ✅ Allow : All from Web tier
- ✅ Allow : All to Data tier
- ✅ Allow : All to Private Endpoints subnet
- ❌ Deny : All other inbound

**Data Tier** :
- ✅ Allow : SQL (1433) from App tier
- ❌ Deny : All to Internet
- ❌ Deny : All other inbound

### Authentification

- **App Service** → SQL : Managed Identity (Azure AD)
- **App Service** → Key Vault : Managed Identity (RBAC)
- **App Service** → Storage : Managed Identity (RBAC)
- **Pas de secrets** dans le code ou configuration

### Conformité

- ✅ Pas d'accès public aux PaaS
- ✅ Encryption en transit (TLS 1.2)
- ✅ Encryption au repos (TDE, Storage)
- ✅ Logs centralisés (Log Analytics)
- ✅ Soft delete activé
- ✅ Backup automatique
- ✅ Zone redundancy (prod)

## 📊 Monitoring

### Application Insights

Toutes les métriques et logs applicatifs sont envoyés à Application Insights :

```kql
// Requêtes HTTP (dernières 24h)
requests
| where timestamp > ago(24h)
| summarize count() by resultCode, bin(timestamp, 1h)
| render timechart

// Exceptions
exceptions
| where timestamp > ago(24h)
| summarize count() by type, outerMessage

// Performance
requests
| where timestamp > ago(1h)
| summarize avg(duration) by name
| order by avg_duration desc
```

### Log Analytics

```kql
// NSG Flow Logs - Traffic bloqué
AzureDiagnostics
| where Category == "NetworkSecurityGroupFlowEvent"
| where FlowStatus_s == "D" // Denied
| summarize count() by NSGName_s, DestinationIP_s

// SQL Audit
AzureDiagnostics
| where ResourceType == "SERVERS/DATABASES"
| where Category == "SQLSecurityAuditEvents"
| project TimeGenerated, statement_s, client_ip_s, application_name_s
```

## 💰 Estimation des coûts (Production)

| Ressource | Configuration | Coût mensuel (CAD) |
|-----------|--------------|-------------------|
| App Service Plan | P1v3 (3 instances) | ~$450 |
| SQL Database | GP_Gen5_2 (256GB) | ~$900 |
| Storage Account | Standard_GRS (100GB) | ~$25 |
| Key Vault | Premium | ~$5 |
| Application Insights | 5GB/day | ~$15 |
| VNet, NSGs, Routes | Standard | ~$10 |
| Private Endpoints | 4 endpoints | ~$30 |
| Outbound data | 100GB/month | ~$10 |
| **Total estimé** | | **~$1,445/mois** |

*Note : Prix indicatifs, peuvent varier selon l'utilisation réelle*

## 🔧 Post-Déploiement

### 1. Configurer l'application

```bash
# Déployer le code applicatif
az webapp deployment source config-zip \
  --resource-group rg-contoso-crm-prod-canadacentral \
  --name app-contoso-crm-prod \
  --src ./app-package.zip
```

### 2. Configurer le DNS personnalisé

```bash
# Ajouter un custom domain
az webapp config hostname add \
  --webapp-name app-contoso-crm-prod \
  --resource-group rg-contoso-crm-prod-canadacentral \
  --hostname crm.contoso.com

# Ajouter le certificat SSL
az webapp config ssl upload \
  --resource-group rg-contoso-crm-prod-canadacentral \
  --name app-contoso-crm-prod \
  --certificate-file cert.pfx \
  --certificate-password "password"

az webapp config ssl bind \
  --resource-group rg-contoso-crm-prod-canadacentral \
  --name app-contoso-crm-prod \
  --certificate-thumbprint "thumbprint" \
  --ssl-type SNI
```

### 3. Configurer les alertes

```bash
# Alert sur erreurs HTTP 5xx
az monitor metrics alert create \
  --name "CRM-HTTP-5xx-Alert" \
  --resource-group rg-contoso-crm-prod-canadacentral \
  --scopes $(az webapp show -g rg-contoso-crm-prod-canadacentral -n app-contoso-crm-prod --query id -o tsv) \
  --condition "avg Http5xx > 10" \
  --window-size 5m \
  --evaluation-frequency 1m \
  --action email recipient@contoso.com

# Alert sur CPU élevé
az monitor metrics alert create \
  --name "CRM-High-CPU-Alert" \
  --resource-group rg-contoso-crm-prod-canadacentral \
  --scopes $(az appservice plan show -g rg-contoso-crm-prod-canadacentral -n asp-contoso-crm-prod --query id -o tsv) \
  --condition "avg CpuPercentage > 80" \
  --window-size 5m
```

### 4. Peupler la base de données

```bash
# Se connecter à SQL avec Azure AD
sqlcmd -S sql-contoso-crm-prod.database.windows.net -d crm-db-prod -G

# Créer le schéma
-- Votre script SQL ici
```

## 🛠️ Troubleshooting

### App Service ne peut pas accéder à SQL

**Symptôme** : "Cannot connect to SQL Server"

**Solutions** :
1. Vérifier que le Private Endpoint SQL est créé
2. Vérifier les NSG rules (App → Data subnet)
3. Vérifier la résolution DNS privée
4. Vérifier que la Managed Identity a les permissions SQL

```bash
# Tester la résolution DNS depuis App Service
az webapp ssh --resource-group rg-contoso-crm-prod-canadacentral --name app-contoso-crm-prod

# Dans le shell de l'App Service
nslookup sql-contoso-crm-prod.database.windows.net
# Devrait retourner une IP privée (10.3.4.x)
```

### Erreur 403 sur Key Vault

**Symptôme** : "Access denied to Key Vault"

**Solutions** :
1. Vérifier le RBAC assignment (Key Vault Secrets User)
2. Vérifier que la Managed Identity est assignée à l'App Service
3. Vérifier les Network ACLs du Key Vault

```bash
# Vérifier le RBAC
az role assignment list \
  --assignee $(az webapp identity show -g rg-contoso-crm-prod-canadacentral -n app-contoso-crm-prod --query principalId -o tsv) \
  --all
```

## 📚 Ressources

- [App Service Best Practices](https://learn.microsoft.com/azure/app-service/app-service-best-practices)
- [SQL Database Security](https://learn.microsoft.com/azure/azure-sql/database/security-overview)
- [Private Endpoint Planning](https://learn.microsoft.com/azure/private-link/private-endpoint-overview)
- [Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview)

---

**Version** : 1.0.0  
**Dernière mise à jour** : Février 2026