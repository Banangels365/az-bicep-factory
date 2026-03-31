# Azure Landing Zone - Connectivity (Hub Network)

Ce repository contient les modules Bicep pour déployer la **Connectivity Landing Zone** avec une topologie Hub-Spoke.

## 📋 Vue d'ensemble

La Connectivity Landing Zone déploie :

- **Hub Virtual Network** : Réseau central avec sous-réseaux dédiés
- **Azure Firewall** : Pare-feu managé pour le filtrage du trafic
- **VPN Gateway** : Connectivité site-à-site et point-à-site
- **Azure Bastion** : Accès RDP/SSH sécurisé sans exposition publique
- **Network Security Groups** : Règles de sécurité par sous-réseau
- **Route Tables** : Routage du trafic via le Firewall
- **DDoS Protection** : Protection contre les attaques DDoS (optionnel)

## 🏗️ Architecture Hub-Spoke

```
                    ┌─────────────────────────────────┐
                    │         Hub VNet                │
                    │      (10.0.0.0/16)             │
                    │                                 │
                    │  ┌──────────────────────────┐  │
                    │  │   Azure Firewall         │  │
                    │  │   (10.0.1.0/26)         │  │
                    │  └──────────────────────────┘  │
                    │                                 │
                    │  ┌──────────────────────────┐  │
                    │  │   VPN Gateway            │  │
                    │  │   (10.0.0.0/27)         │  │
                    │  └──────────────────────────┘  │
                    │                                 │
                    │  ┌──────────────────────────┐  │
                    │  │   Azure Bastion          │  │
                    │  │   (10.0.2.0/27)         │  │
                    │  └──────────────────────────┘  │
                    │                                 │
                    └─────────┬───────────────────────┘
                              │
                ┌─────────────┼─────────────┐
                │             │             │
                │             │             │
        ┌───────▼──────┐ ┌────▼───────┐ ┌────▼──────────┐
        │ Spoke VNet 1 │ │ Spoke 2    │ │ Spoke 3       │
        │ (Prod)       │ │ (Logging)  │ │ (Quarantine)  │
        └──────────────┘ └────────────┘ └───────────────┘
```

## 📦 Modules disponibles

### 1. Virtual Network (VNet)
Crée un réseau virtuel avec subnets, NSGs et diagnostic settings.

**Paramètres clés** :
- `addressPrefixes` : Espaces d'adressage CIDR
- `subnets` : Configuration des sous-réseaux
- `enableDdosProtection` : Active la protection DDoS

**Exemple** :
```bicep
module vnet 'modules/networking/virtual-network/main.bicep' = {
  params: {
    vnetName: 'vnet-hub-prod'
    addressPrefixes: ['10.0.0.0/16']
    subnets: [
      {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.0.0/27'
      }
    ]
  }
}
```

### 2. Network Security Group (NSG)
Définit les règles de sécurité réseau avec flow logs.

**Paramètres clés** :
- `securityRules` : Liste des règles de sécurité
- `enableFlowLogs` : Active les flow logs NSG

**Exemple** :
```bicep
module nsg 'modules/networking/nsg/main.bicep' = {
  params: {
    nsgName: 'nsg-subnet-web'
    securityRules: [
      {
        name: 'AllowHTTPS'
        protocol: 'Tcp'
        destinationPortRange: '443'
        access: 'Allow'
        priority: 100
        direction: 'Inbound'
      }
    ]
  }
}
```

### 3. Azure Firewall
Pare-feu managé avec support Premium/Standard.

**Paramètres clés** :
- `skuTier` : 'Standard' ou 'Premium'
- `firewallPolicyId` : ID de la Firewall Policy
- `zones` : Zones de disponibilité

**Exemple** :
```bicep
module firewall 'modules/networking/azure-firewall/main.bicep' = {
  params: {
    firewallName: 'afw-hub-prod'
    skuTier: 'Premium'
    subnetId: '${vnet.outputs.vnetId}/subnets/AzureFirewallSubnet'
    publicIpAddressIds: [pip.outputs.publicIpId]
    zones: ['1', '2', '3']
  }
}
```

### 4. VPN Gateway
Passerelle VPN pour connectivité hybride.

**Paramètres clés** :
- `gatewaySku` : VpnGw1, VpnGw2, VpnGw3 (+ AZ pour zone redundancy)
- `enableBgp` : Active BGP pour le routage dynamique
- `activeActive` : Mode actif-actif

**Exemple** :
```bicep
module vpnGw 'modules/networking/vpn-gateway/main.bicep' = {
  params: {
    vpnGatewayName: 'vpngw-hub-prod'
    gatewaySku: 'VpnGw1AZ'
    enableBgp: true
    activeActive: true
  }
}
```

### 5. Azure Bastion
Service de connexion RDP/SSH sécurisé.

**Paramètres clés** :
- `sku` : 'Basic' ou 'Standard'
- `enableTunneling` : Native client support
- `enableFileCopy` : Upload/download de fichiers

**Exemple** :
```bicep
module bastion 'modules/networking/bastion/main.bicep' = {
  params: {
    bastionName: 'bas-hub-prod'
    sku: 'Standard'
    enableTunneling: true
    enableFileCopy: true
  }
}
```

### 6. Load Balancer
Équilibreur de charge Layer 4.

**Paramètres clés** :
- `type` : 'Public' ou 'Internal'
- `loadBalancingRules` : Règles de répartition
- `probes` : Health probes

### 7. Application Gateway
Équilibreur de charge Layer 7 avec WAF.

**Paramètres clés** :
- `tier` : 'Standard_v2' ou 'WAF_v2'
- `enableAutoscaling` : Autoscaling basé sur les métriques
- `wafConfiguration` : Configuration du Web Application Firewall

### 8. VNet Peering
Connexion entre VNets pour topologie Hub-Spoke.

**Paramètres clés** :
- `allowForwardedTraffic` : Autorise le trafic transitant
- `useRemoteGateways` : Utilise les gateways du hub

### 9. Route Table
Tables de routage pour diriger le trafic.

**Paramètres clés** :
- `routes` : Liste des routes
- `disableBgpRoutePropagation` : Désactive la propagation BGP

### 10. Public IP Address
Adresse IP publique avec protection DDoS.

**Paramètres clés** :
- `sku` : 'Basic' ou 'Standard'
- `zones` : Zone redundancy
- `ddosProtectionMode` : Protection DDoS

### 11. NAT Gateway
Sortie internet pour sous-réseaux privés.

**Paramètres clés** :
- `publicIpAddressIds` : IPs publiques associées
- `idleTimeoutInMinutes` : Timeout des connexions

### 12. Private DNS Zone
Zones DNS privées pour Private Endpoints.

**Paramètres clés** :
- `privateDnsZoneName` : Nom de la zone (ex: privatelink.blob.core.windows.net)
- `vnetLinksVnetIds` : VNets à lier à la zone

### 13. DDoS Protection Plan
Plan de protection DDoS Network (coûteux, évaluer le besoin).

## 🚀 Déploiement

### Prérequis

1. **Subscription dédiée** : Recommandé d'avoir une subscription séparée pour Connectivity
2. **IP addressing** : Planifier l'adressage IP (éviter les overlaps)
3. **Log Analytics Workspace** : Doit être déployé au préalable (Platform)

### Déploiement du Hub Network

```bash
# Connexion Azure
az login
az account set --subscription "Connectivity-Subscription"

# Validation
az deployment sub validate \
  --location canadacentral \
  --template-file connectivity/hub/main.bicep \
  --parameters connectivity/hub/main.bicepparam

# Déploiement
az deployment sub create \
  --name hub-network-deployment \
  --location canadacentral \
  --template-file connectivity/hub/main.bicep \
  --parameters connectivity/hub/main.bicepparam
```

### Déploiement d'un Spoke

```bicep
// workloads/app-1/spoke-vnet.bicep
module spokeVnet '../../modules/networking/virtual-network/main.bicep' = {
  params: {
    vnetName: 'vnet-app1-prod'
    addressPrefixes: ['10.1.0.0/16']
    subnets: [
      {
        name: 'snet-app'
        addressPrefix: '10.1.1.0/24'
      }
    ]
  }
}

module peering '../../modules/networking/vnet-peering/main.bicep' = {
  params: {
    localVnetName: 'vnet-app1-prod'
    remoteVnetId: hubVnetId
    allowForwardedTraffic: true
    useRemoteGateways: true
  }
}
```

## 🔒 Sécurité

### Bonnes pratiques

1. **Network Segmentation** : Un subnet par tier (web, app, data)
2. **NSG par subnet** : Règles restrictives par défaut (deny all)
3. **Route via Firewall** : Forcer le trafic internet via Azure Firewall
4. **Private Endpoints** : Utiliser des Private Endpoints pour les services PaaS
5. **Bastion pour l'accès** : Pas d'accès RDP/SSH direct depuis internet

### Exemple de NSG Rules (Tier Web)

```bicep
securityRules: [
  {
    name: 'AllowHTTPS'
    protocol: 'Tcp'
    sourceAddressPrefix: 'Internet'
    destinationPortRange: '443'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
  }
  {
    name: 'AllowAppTier'
    protocol: 'Tcp'
    sourceAddressPrefix: '10.1.2.0/24' // App subnet
    destinationPortRange: '*'
    access: 'Allow'
    priority: 110
    direction: 'Outbound'
  }
  {
    name: 'DenyAllInbound'
    protocol: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: 4096
    direction: 'Inbound'
  }
]
```

## 📊 Monitoring & Logging

### Logs disponibles

- **NSG Flow Logs** : Trafic autorisé/refusé par les NSGs
- **Azure Firewall Logs** : Application rules, Network rules, DNS proxy
- **VPN Gateway Logs** : Diagnostics des tunnels VPN
- **Bastion Logs** : Audit des connexions RDP/SSH

### Requêtes KQL utiles

```kql
// Top 10 des IPs bloquées par le Firewall
AzureDiagnostics
| where Category == "AzureFirewallNetworkRule"
| where msg_s contains "Deny"
| summarize Count = count() by SrcIP = split(msg_s, " ")[3]
| top 10 by Count desc

// Connexions Bastion
MicrosoftAzureBastionAuditLogs
| where TimeGenerated > ago(24h)
| project TimeGenerated, UserName, ClientIpAddress, TargetResourceId
| order by TimeGenerated desc

// Trafic NSG refusé
AzureDiagnostics
| where Category == "NetworkSecurityGroupEvent"
| where type_s == "block"
| summarize Count = count() by ruleName_s, destinationPort_d
```

## 💰 Coûts

### Estimation mensuelle (Production)

| Ressource | Configuration | Coût mensuel (CAD) |
|-----------|--------------|-------------------|
| Hub VNet | Standard | Gratuit |
| VPN Gateway | VpnGw1AZ | ~$230 |
| Azure Firewall | Standard | ~$1,800 |
| Azure Bastion | Standard (2 units) | ~$220 |
| Public IPs | 3x Standard | ~$12 |
| **Total** | | **~$2,262** |

### Optimisations possibles

- **Firewall** : Utiliser Basic pour dev/test (~$200/mois)
- **VPN** : Utiliser VpnGw1 sans AZ pour dev (~$160/mois)
- **Bastion** : Utiliser Basic pour dev (~$160/mois)

## 🔧 Troubleshooting

### VPN Gateway ne se connecte pas

```bash
# Vérifier l'état du gateway
az network vnet-gateway show \
  --name vpngw-hub-prod \
  --resource-group rg-hub-prod \
  --query 'provisioningState'

# Vérifier les connexions
az network vpn-connection list \
  --resource-group rg-hub-prod \
  --output table
```

### Trafic bloqué par le Firewall

```bash
# Vérifier les règles du Firewall
az network firewall show \
  --name afw-hub-prod \
  --resource-group rg-hub-prod

# Analyser les logs
az monitor log-analytics query \
  --workspace <workspace-id> \
  --analytics-query "AzureDiagnostics | where Category == 'AzureFirewallNetworkRule' | where msg_s contains 'Deny'"
```

### Peering ne fonctionne pas

```bash
# Vérifier l'état du peering
az network vnet peering show \
  --name peering-to-hub \
  --resource-group rg-spoke \
  --vnet-name vnet-spoke \
  --query 'peeringState'

# Le peering doit être "Connected" des deux côtés
```

## 📚 Ressources complémentaires

- [Hub-Spoke Network Topology](https://learn.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
- [Azure Firewall Documentation](https://learn.microsoft.com/azure/firewall/)
- [VPN Gateway Planning](https://learn.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Network Security Best Practices](https://learn.microsoft.com/azure/security/fundamentals/network-best-practices)

---

**Version** : 1.0.0  
**Dernière mise à jour** : Février 2026