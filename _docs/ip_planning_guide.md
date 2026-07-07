# Guide de Planification IP pour Azure Landing Zones

Ce document fournit un plan d'adressage IP recommandé pour une Landing Zone Azure avec topologie Hub-Spoke.

## 📐 Principes de planification

### Règles générales

1. **Espaces non-routables** : Utiliser RFC 1918 (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
2. **Éviter les overlaps** : Aucun chevauchement entre VNets et réseaux on-premises
3. **Prévoir la croissance** : Allouer des blocs plus grands que nécessaire
4. **Sous-réseaux standard** : /24 minimum pour les workloads, /27 pour les gateways
5. **Réserver des ranges** : Garder des blocs pour l'expansion future

### Adresses réservées par Azure

Azure réserve 5 adresses IP par subnet :
- `.0` : Adresse réseau
- `.1` : Gateway par défaut
- `.2` et `.3` : DNS Azure
- `.255` : Broadcast réseau (dernière adresse)

**Exemple** : Un /27 (32 IPs) a seulement 27 IPs utilisables après réservations Azure.

## 🏗️ Plan d'adressage recommandé

### Hub Network (10.0.0.0/16)

| Subnet | CIDR | Plage IP | IPs utilisables | Usage |
|--------|------|----------|-----------------|-------|
| GatewaySubnet | 10.0.0.0/27 | 10.0.0.0 - 10.0.0.31 | 27 | VPN/ExpressRoute Gateway |
| AzureFirewallSubnet | 10.0.1.0/26 | 10.0.1.0 - 10.0.1.63 | 59 | Azure Firewall |
| AzureFirewallManagementSubnet | 10.0.1.64/26 | 10.0.1.64 - 10.0.1.127 | 59 | Firewall Management (Basic SKU) |
| AzureBastionSubnet | 10.0.2.0/27 | 10.0.2.0 - 10.0.2.31 | 27 | Azure Bastion |
| snet-hub-management | 10.0.3.0/24 | 10.0.3.0 - 10.0.3.255 | 251 | Jump boxes, management VMs |
| snet-hub-shared | 10.0.4.0/24 | 10.0.4.0 - 10.0.4.255 | 251 | Services partagés |
| ApplicationGatewaySubnet | 10.0.5.0/24 | 10.0.5.0 - 10.0.5.255 | 251 | Application Gateway (optionnel) |
| **Réservé** | 10.0.6.0/23 | 10.0.6.0 - 10.0.7.255 | 507 | Expansion future |

### Spoke Networks - Development (10.1.0.0/16)

| VNet/Subnet | CIDR | Plage IP | Usage |
|-------------|------|----------|-------|
| **vnet-dev-app1** | **10.1.0.0/20** | 10.1.0.0 - 10.1.15.255 | Application 1 Dev |
| snet-web | 10.1.0.0/24 | 10.1.0.0 - 10.1.0.255 | Web tier |
| snet-app | 10.1.1.0/24 | 10.1.1.0 - 10.1.1.255 | Application tier |
| snet-data | 10.1.2.0/24 | 10.1.2.0 - 10.1.2.255 | Data tier |
| snet-integration | 10.1.3.0/24 | 10.1.3.0 - 10.1.3.255 | Service integration |
| snet-privateendpoints | 10.1.4.0/24 | 10.1.4.0 - 10.1.4.255 | Private Endpoints |
| **vnet-dev-app2** | **10.1.16.0/20** | 10.1.16.0 - 10.1.31.255 | Application 2 Dev |
| snet-web | 10.1.16.0/24 | | Web tier |
| snet-app | 10.1.17.0/24 | | Application tier |
| snet-data | 10.1.18.0/24 | | Data tier |
| **Réservé** | **10.1.32.0/19** | 10.1.32.0 - 10.1.63.255 | Futures apps dev |

### Spoke Networks - Staging (10.2.0.0/16)

| VNet/Subnet | CIDR | Plage IP | Usage |
|-------------|------|----------|-------|
| **vnet-staging-app1** | **10.2.0.0/20** | 10.2.0.0 - 10.2.15.255 | Application 1 Staging |
| snet-web | 10.2.0.0/24 | 10.2.0.0 - 10.2.0.255 | Web tier |
| snet-app | 10.2.1.0/24 | 10.2.1.0 - 10.2.1.255 | Application tier |
| snet-data | 10.2.2.0/24 | 10.2.2.0 - 10.2.2.255 | Data tier |
| snet-integration | 10.2.3.0/24 | 10.2.3.0 - 10.2.3.255 | Service integration |
| snet-privateendpoints | 10.2.4.0/24 | 10.2.4.0 - 10.2.4.255 | Private Endpoints |
| **vnet-staging-app2** | **10.2.16.0/20** | 10.2.16.0 - 10.2.31.255 | Application 2 Staging |
| **Réservé** | **10.2.32.0/19** | 10.2.32.0 - 10.2.63.255 | Futures apps staging |

### Spoke Networks - Production (10.3.0.0/16)

| VNet/Subnet | CIDR | Plage IP | Usage |
|-------------|------|----------|-------|
| **vnet-prod-app1** | **10.3.0.0/20** | 10.3.0.0 - 10.3.15.255 | Application 1 Prod |
| snet-web | 10.3.0.0/24 | 10.3.0.0 - 10.3.0.255 | Web tier (LB frontend) |
| snet-app | 10.3.1.0/24 | 10.3.1.0 - 10.3.1.255 | Application tier |
| snet-data | 10.3.2.0/24 | 10.3.2.0 - 10.3.2.255 | Data tier |
| snet-integration | 10.3.3.0/24 | 10.3.3.0 - 10.3.3.255 | Service integration |
| snet-privateendpoints | 10.3.4.0/24 | 10.3.4.0 - 10.3.4.255 | Private Endpoints |
| snet-aks | 10.3.5.0/23 | 10.3.5.0 - 10.3.6.255 | AKS nodes (si applicable) |
| **vnet-prod-app2** | **10.3.16.0/20** | 10.3.16.0 - 10.3.31.255 | Application 2 Prod |
| **vnet-prod-shared** | **10.3.32.0/20** | 10.3.32.0 - 10.3.47.255 | Services partagés prod |
| **Réservé** | **10.3.48.0/20** | 10.3.48.0 - 10.3.63.255 | Futures apps prod |

### Plages réservées

| Bloc | CIDR | Usage prévu |
|------|------|-------------|
| 10.4.0.0/16 | 10.4.0.0 - 10.4.255.255 | Sandbox / Expérimentation |
| 10.5.0.0/16 | 10.5.0.0 - 10.5.255.255 | DR (Disaster Recovery) site |
| 10.6.0.0/16 | 10.6.0.0 - 10.6.255.255 | Expansion future |
| 10.7.0.0/16 | 10.7.0.0 - 10.7.255.255 | Expansion future |

## 📋 Tailles de subnet recommandées

### Selon le type de ressource

| Type de ressource | Taille recommandée | Justification |
|-------------------|-------------------|---------------|
| GatewaySubnet | /27 (32 IPs) | Minimum Azure, suffisant pour la plupart des cas |
| AzureFirewallSubnet | /26 (64 IPs) | Minimum Azure, permettre scaling |
| AzureBastionSubnet | /27 (32 IPs) | Minimum Azure pour Standard SKU |
| ApplicationGatewaySubnet | /24 (256 IPs) | Pour autoscaling jusqu'à 125 instances |
| Web tier | /24 (256 IPs) | VM scale sets, conteneurs |
| App tier | /24 (256 IPs) | VM scale sets, AKS nodes |
| Data tier | /24 (256 IPs) | Bases de données, storage |
| Private Endpoints | /24 (256 IPs) | 1 IP par Private Endpoint |
| AKS nodes | /23 (512 IPs) | Minimum pour production (30-100 nodes) |
| AKS pods (Azure CNI) | /16 (65536 IPs) | Subnet séparé, beaucoup d'IPs requis |

### Calcul du nombre d'IPs requis

**Pour VM Scale Sets** :
- Instance count max × 1.5 (buffer) = IPs requis
- Exemple : 50 VMs max → 75 IPs → /25 (128 IPs) minimum

**Pour AKS avec Azure CNI** :
- (Nodes max × pods per node) + buffer
- Exemple : 50 nodes × 30 pods = 1500 IPs → /21 minimum

**Pour Private Endpoints** :
- 1 IP par endpoint
- Exemple : 50 services PaaS → /26 (64 IPs) minimum

## 🔧 Outils de calcul

### Calculateur de subnet en ligne
- [Visual Subnet Calculator](https://www.davidc.net/sites/default/subnets/subnets.html)
- [IP Address Guide](https://www.ipaddressguide.com/cidr)

### PowerShell

```powershell
# Calculer les IPs disponibles dans un subnet
function Get-SubnetInfo {
    param([string]$CIDR)
    
    $prefix = $CIDR.Split('/')[1]
    $totalIPs = [Math]::Pow(2, (32 - $prefix))
    $usableIPs = $totalIPs - 5  # Azure réserve 5 IPs
    
    Write-Host "CIDR: $CIDR"
    Write-Host "Total IPs: $totalIPs"
    Write-Host "Usable IPs: $usableIPs"
}

Get-SubnetInfo "10.0.0.0/24"
```

### Azure CLI

```bash
# Vérifier les IPs disponibles dans un subnet
az network vnet subnet show \
  --resource-group rg-hub-prod \
  --vnet-name vnet-hub-prod \
  --name snet-management \
  --query "addressPrefix" -o tsv
```

## ⚠️ Erreurs communes à éviter

### 1. Subnets trop petits
❌ **Erreur** : Utiliser /28 pour des workloads de production
✅ **Bonne pratique** : Minimum /24 pour prévoir la croissance

### 2. Overlapping d'adresses
❌ **Erreur** : Dev = 10.1.0.0/16, Staging = 10.1.0.0/16
✅ **Bonne pratique** : Dev = 10.1.0.0/16, Staging = 10.2.0.0/16

### 3. Pas de place pour l'expansion
❌ **Erreur** : Utiliser tout le /16 sans réserver d'espace
✅ **Bonne pratique** : Réserver 25-50% pour l'expansion

### 4. Ignorer les subnets Azure spéciaux
❌ **Erreur** : Nommer un subnet "GatewaySubnet1" ou utiliser /28
✅ **Bonne pratique** : Nom exact "GatewaySubnet", minimum /27

### 5. Subnet unique pour tout
❌ **Erreur** : Mettre web, app, et data dans le même /24
✅ **Bonne pratique** : Séparer par tier pour la sécurité

## 📝 Template de documentation

Documentez votre plan d'adressage dans un fichier partagé :

```markdown
# Plan d'adressage IP - [Nom Organisation]

## Vue d'ensemble
- Range global : 10.0.0.0/8
- Hub : 10.0.0.0/16
- Spokes : 10.1.0.0/15 à 10.7.0.0/16

## Détails par environnement

### Hub Network
| Subnet | CIDR | IPs | Statut |
|--------|------|-----|--------|
| GatewaySubnet | 10.0.0.0/27 | 27 | ✅ Déployé |
| AzureFirewallSubnet | 10.0.1.0/26 | 59 | ✅ Déployé |

### Production Spokes
| Application | VNet CIDR | Statut | Notes |
|-------------|-----------|--------|-------|
| App1 | 10.3.0.0/20 | ✅ Déployé | CRM |
| App2 | 10.3.16.0/20 | 🔨 En cours | ERP |
| App3 | 10.3.32.0/20 | 📅 Planifié | Q2 2026 |

## Changelog
- 2026-02-12 : Création initiale
- 2026-02-15 : Ajout App2 production
```

## 🔗 Intégration avec on-premises

### Considérations pour hybrid connectivity

1. **Obtenir les ranges on-prem** : Documenter TOUS les réseaux existants
2. **Éviter les conflits** : Ne jamais utiliser les mêmes ranges qu'on-prem
3. **Route summarization** : Utiliser des blocs contigus pour le routage
4. **BGP planning** : Si BGP est utilisé, planifier les AS numbers

### Exemple avec on-premises

```
On-premises networks:
- Corporate LAN: 172.16.0.0/16
- Branch offices: 172.17.0.0/16 - 172.20.0.0/16
- Data center: 192.168.0.0/16

Azure Landing Zone:
- Hub: 10.0.0.0/16 ✅ Pas de conflit
- Spokes: 10.1.0.0/15 à 10.7.0.0/16 ✅ Pas de conflit

Advertise to on-prem via BGP:
- 10.0.0.0/8 (summary route)
```

---

**Important** : Ce plan est un point de départ. Adaptez-le selon vos besoins spécifiques et la taille de votre organisation.