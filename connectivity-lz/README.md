# Connectivity Landing Zone — Bicep Modules

> **Version** : 2.0.0 | **Région supportée** : `canadacentral` (`cace`), `canadaeast` (`caea`)  
> **Mainteneur** : NetworkOps Team | **Dernière mise à jour** : Mai 2026

---

## Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Architecture](#architecture)
- [Ordre de déploiement](#ordre-de-déploiement)
- [Modules](#modules)
  - [virtual_network.bicep](#virtual_networkbicep)
  - [subnet.bicep](#subnetbicep)
  - [network_security_group.bicep](#network_security_groupbicep)
  - [public_ip.bicep](#public_ipbicep)
  - [azure_firewall.bicep](#azure_firewallbicep)
  - [vpn_gateway.bicep](#vpn_gatewaybicep)
  - [azure_bastion.bicep](#azure_bastionbicep)
  - [virtual_network_peering.bicep](#virtual_network_peeringbicep)
  - [route_table.bicep](#route_tablebicep)
  - [nat_gateway.bicep](#nat_gatewaybicep)
  - [azure_load_balancer.bicep](#azure_load_balancerbicep)
  - [application_gateway.bicep](#application_gatewaybicep)
  - [private_dns_zone.bicep](#private_dns_zonebicep)
  - [network_watcher_flowlogs.bicep](#network_watcher_flowlogsbicep)
  - [ddos_protection.bicep](#ddos_protectionbicep)
- [Bonnes pratiques IaC](#bonnes-pratiques-iac)
- [Troubleshooting](#troubleshooting)
- [Ressources](#ressources)

---

## Vue d'ensemble

La Connectivity Landing Zone déploie et gère l'infrastructure réseau Hub-Spoke de la plateforme.
Elle constitue le socle de connectivité sur lequel toutes les autres Landing Zones s'appuient.

**Ce que déploie cette Landing Zone :**

- **Hub VNet** avec subnets dédiés (Firewall, Gateway, Bastion, Management)
- **Azure Firewall** pour l'inspection et le filtrage du trafic inter-spoke et internet
- **VPN Gateway** pour la connectivité hybride (site-to-site, point-to-site)
- **Azure Bastion** pour l'accès RDP/SSH sécurisé sans IP publique sur les VMs
- **Route Tables** pour forcer le trafic via le Firewall (UDR)
- **NSGs** dédiés par subnet avec règles minimales requises
- **Private DNS Zones** pour la résolution DNS des Private Endpoints
- **NAT Gateway**, **Load Balancers**, **Application Gateway** selon les besoins workload

> **Topologie Hub-Spoke** : Le hub est déployé une seule fois via cet orchestrateur.
> Chaque spoke est déployé indépendamment dans sa propre Landing Zone et orchestre
> lui-même les deux directions du peering VNet (spoke→hub et hub→spoke).

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│  connectivity-lz (déployé UNE FOIS)                             │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Hub VNet                                               │   │
│  │                                                         │   │
│  │  GatewaySubnet        AzureFirewallSubnet               │   │
│  │  ┌──────────────┐     ┌──────────────┐                 │   │
│  │  │ VPN Gateway  │     │ Azure Firewall│                 │   │
│  │  └──────────────┘     └──────────────┘                 │   │
│  │                                                         │   │
│  │  AzureBastionSubnet   snet-hub-management               │   │
│  │  ┌──────────────┐     ┌──────────────┐                 │   │
│  │  │ Azure Bastion│     │ Mgmt VMs     │                 │   │
│  │  └──────────────┘     └──────────────┘                 │   │
│  └─────────────────────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────────────────────┘
                        │ Peering (piloté par chaque spoke-lz)
          ┌─────────────┴──────────────┐
          ▼                            ▼
┌──────────────────┐        ┌──────────────────┐
│  spoke-lz prod   │        │  spoke-lz logs   │
│  VNet spoke      │        │  VNet spoke      │
└──────────────────┘        └──────────────────┘
```

---

## Ordre de déploiement

```bash
# 1. Valider le déploiement avec --what-if
az deployment sub what-if \
  --name connectivity-lz-deploy \
  --location canadaeast \
  --template-file connectivity-lz/connectivity.bicep \
  --parameters connectivity-lz/connectivity.bicepparam

# 2. Déployer la Connectivity Landing Zone
az deployment sub create \
  --name connectivity-lz-deploy \
  --location canadaeast \
  --template-file connectivity-lz/connectivity.bicep \
  --parameters connectivity-lz/connectivity.bicepparam

# 3. Récupérer les outputs pour les spokes
az deployment sub show \
  --name connectivity-lz-deploy \
  --query properties.outputs
```

> **Prérequis** : Le resource group de connectivité doit exister avant le déploiement.
> Les spokes sont déployés séparément après le hub et reçoivent `hubVnetId` en paramètre.

---

## Modules

---

### `virtual_network.bicep`

#### Description

Crée un réseau virtuel avec subnets, diagnostic settings et flow logs optionnels.
Supporte la protection DDoS, les DNS personnalisés et la VM Protection.

Les propriétés optionnelles des subnets (`networkSecurityGroupId`, `routeTableId`, `natGatewayId`)
sont omises via `union()` plutôt que passées à `null` — ce qui évite de dissocier
silencieusement des ressources existantes lors d'un redéploiement.

#### Utilisation

```bicep
// Hub VNet avec subnets dédiés
module hubVnet './modules/virtual_network.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-hub-vnet'
  params: {
    vnetName:         'vnet-acmy-hub-sbox-caea'
    location:         'caea'
    addressPrefixes:  ['10.0.0.0/16']
    subnets: [
      {
        name:          'GatewaySubnet'
        addressPrefix: '10.0.0.0/27'
        // Pas de NSG ni de route table — requis par Azure
      }
      {
        name:          'AzureFirewallSubnet'
        addressPrefix: '10.0.1.0/26'
        // Pas de NSG ni de route table — requis par Azure
      }
      {
        name:                  'AzureBastionSubnet'
        addressPrefix:         '10.0.2.0/26'  // /26 minimum requis
        networkSecurityGroupId: nsgBastion.outputs.nsgId  // NSG dédié Bastion obligatoire
        // Pas de route table — requis par Azure
      }
      {
        name:                  'snet-hub-management'
        addressPrefix:         '10.0.3.0/24'
        networkSecurityGroupId: nsgManagement.outputs.nsgId
        // routeTableId ajouté en phase 2 après déploiement du Firewall
      }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics:       true
    tags:                    tags
  }
}
```

#### Requis

- Le resource group cible doit exister avant le déploiement
- `AzureBastionSubnet` exige un NSG dédié avec les règles Bastion obligatoires
- `AzureBastionSubnet` exige un préfixe `/26` minimum (64 IPs)
- `GatewaySubnet` et `AzureFirewallSubnet` ne doivent pas avoir de NSG ni de route table

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `vnetName` | string | — | ✅ | Nom du VNet (2-64 caractères) |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `addressPrefixes` | array | — | ✅ | Espaces d'adressage CIDR |
| `subnets` | array | `[]` | ❌ | Configuration des subnets |
| `enableDdosProtection` | bool | `false` | ❌ | Active la protection DDoS |
| `ddosProtectionPlanId` | string | `''` | ❌ | ID du plan DDoS |
| `enableVmProtection` | bool | `false` | ❌ | Active la protection des VMs |
| `dnsServers` | array | `[]` | ❌ | Serveurs DNS personnalisés |
| `enableDiagnostics` | bool | `true` | ❌ | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ❌ | ID du Log Analytics Workspace |
| `enableFlowLogs` | bool | `false` | ❌ | Active les flow logs |
| `flowLogsStorageAccountId` | string | `''` | ❌ | ID du compte de stockage pour flow logs |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `vnetId` | string | Resource ID complet du VNet |
| `vnetName` | string | Nom du VNet |
| `addressPrefixes` | array | Espaces d'adressage du VNet |
| `subnetIds` | array | Resource IDs de tous les subnets |
| `subnets` | array | Détails (nom, ID, préfixe) de chaque subnet |

#### Ressources créées

- `Microsoft.Network/virtualNetworks`
- `Microsoft.Insights/diagnosticSettings`
- `Microsoft.Network/networkWatchers/flowLogs` (si `enableFlowLogs = true`)

#### Dépendances

Aucune dépendance directe. Si DDoS activé, `ddos_protection.bicep` doit être déployé avant.

---

### `subnet.bicep`

#### Description

Crée ou met à jour un subnet individuel au sein d'un VNet existant. Utilisé en **phase 2**
pour appliquer une route table sur le subnet management après le déploiement du Firewall —
sans recréer le VNet entier.

Les propriétés optionnelles sont omises via `union()` pour éviter la dissociation
de ressources existantes lors d'un redéploiement.

> **Note** : Ce module doit être appelé avec `scope: resourceGroup(...)` pointant
> vers le resource group contenant le VNet parent.

#### Utilisation

```bicep
// Phase 2 — Appliquer la route table sur le subnet management
// après que le Firewall et son IP privée sont disponibles
module managementSubnet './modules/subnet.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-subnet-management-phase2'
  params: {
    vnetName:               hubVnetName
    subnetName:             'snet-hub-management'
    addressPrefix:          '10.0.3.0/24'
    networkSecurityGroupId: nsgManagement.outputs.nsgId
    routeTableId:           routeTableManagement.outputs.routeTableId
  }
}
```

#### Requis

- Le VNet parent doit exister (`vnetName` référence un VNet existant)
- Permissions : `Network Contributor` sur le resource group contenant le VNet

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `vnetName` | string | — | ✅ | Nom du VNet parent |
| `subnetName` | string | — | ✅ | Nom du subnet |
| `addressPrefix` | string | — | ✅ | Préfixe CIDR du subnet |
| `networkSecurityGroupId` | string | `''` | ❌ | ID du NSG à associer |
| `routeTableId` | string | `''` | ❌ | ID de la route table |
| `serviceEndpoints` | array | `[]` | ❌ | Service endpoints à activer |
| `delegations` | array | `[]` | ❌ | Délégations de subnet |
| `privateEndpointNetworkPolicies` | string | `Disabled` | ❌ | Politique Private Endpoints |
| `privateLinkServiceNetworkPolicies` | string | `Enabled` | ❌ | Politique Private Link |
| `natGatewayId` | string | `''` | ❌ | ID du NAT Gateway |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `subnetId` | string | Resource ID complet du subnet |
| `subnetName` | string | Nom du subnet |
| `addressPrefix` | string | Préfixe CIDR du subnet |

#### Ressources créées

- `Microsoft.Network/virtualNetworks/subnets`

#### Dépendances

Dépend d'un VNet existant référencé par `vnetName`.

---

### `network_security_group.bicep`

#### Description

Crée un NSG avec règles de sécurité et flow logs optionnels. Les règles supportent
à la fois les propriétés simples (`sourcePortRange`) et multiples (`sourcePortRanges`)
via `union()` — les propriétés absentes sont omises plutôt que passées à `null`.

> **Règle importante** : `AzureBastionSubnet` exige un NSG **dédié** avec des règles
> spécifiques (voir exemple ci-dessous). Ne jamais partager le NSG du subnet management
> avec `AzureBastionSubnet` — Azure valide la conformité à la création et rejette
> tout NSG non conforme.

#### Utilisation

```bicep
// NSG dédié pour AzureBastionSubnet — règles obligatoires Microsoft
module nsgBastion './modules/network_security_group.bicep' = if (deployBastion) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-nsg-bastion'
  params: {
    nsgName:  'nsg-bastion-acmy-sbox-caea'
    location: 'caea'
    securityRules: [
      // ── INBOUND obligatoires ──────────────────────────────
      { name: 'AllowHttpsInbound'               protocol: 'Tcp' sourcePortRange: '*' destinationPortRange: '443'  sourceAddressPrefix: 'Internet'        destinationAddressPrefix: '*'              access: 'Allow' priority: 100 direction: 'Inbound' }
      { name: 'AllowGatewayManagerInbound'      protocol: 'Tcp' sourcePortRange: '*' destinationPortRange: '443'  sourceAddressPrefix: 'GatewayManager'  destinationAddressPrefix: '*'              access: 'Allow' priority: 110 direction: 'Inbound' }
      { name: 'AllowAzureLoadBalancerInbound'   protocol: 'Tcp' sourcePortRange: '*' destinationPortRange: '443'  sourceAddressPrefix: 'AzureLoadBalancer' destinationAddressPrefix: '*'             access: 'Allow' priority: 120 direction: 'Inbound' }
      { name: 'AllowBastionHostCommunication'   protocol: '*'   sourcePortRange: '*' destinationPortRanges: ['5701','8080'] sourceAddressPrefix: 'VirtualNetwork' destinationAddressPrefix: 'VirtualNetwork' access: 'Allow' priority: 130 direction: 'Inbound' }
      // ── OUTBOUND obligatoires ─────────────────────────────
      { name: 'AllowSshRdpOutbound'             protocol: '*'   sourcePortRange: '*' destinationPortRanges: ['22','3389'] sourceAddressPrefix: '*' destinationAddressPrefix: 'VirtualNetwork' access: 'Allow' priority: 100 direction: 'Outbound' }
      { name: 'AllowAzureCloudOutbound'         protocol: 'Tcp' sourcePortRange: '*' destinationPortRange: '443'  sourceAddressPrefix: '*' destinationAddressPrefix: 'AzureCloud'        access: 'Allow' priority: 110 direction: 'Outbound' }
      { name: 'AllowBastionCommunicationOutbound' protocol: '*' sourcePortRange: '*' destinationPortRanges: ['5701','8080'] sourceAddressPrefix: '*' destinationAddressPrefix: 'VirtualNetwork' access: 'Allow' priority: 120 direction: 'Outbound' }
      { name: 'AllowGetSessionInformation'      protocol: '*'   sourcePortRange: '*' destinationPortRange: '80'   sourceAddressPrefix: '*' destinationAddressPrefix: 'Internet'          access: 'Allow' priority: 130 direction: 'Outbound' }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics:       true
    tags:                    tags
  }
}

// NSG pour subnet management — règles métier uniquement
module nsgManagement './modules/network_security_group.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-nsg-management'
  params: {
    nsgName:  'nsg-hub-acmy-sbox-caea'
    location: 'caea'
    securityRules: [
      { name: 'AllowRDP'       protocol: 'Tcp' sourcePortRange: '*' destinationPortRange: '3389' sourceAddressPrefix: bastionSubnetPrefix destinationAddressPrefix: managementSubnetPrefix access: 'Allow' priority: 100 direction: 'Inbound' }
      { name: 'AllowSSH'       protocol: 'Tcp' sourcePortRange: '*' destinationPortRange: '22'   sourceAddressPrefix: bastionSubnetPrefix destinationAddressPrefix: managementSubnetPrefix access: 'Allow' priority: 110 direction: 'Inbound' }
      { name: 'DenyAllInbound' protocol: '*'   sourcePortRange: '*' destinationPortRange: '*'    sourceAddressPrefix: '*'                 destinationAddressPrefix: '*'                   access: 'Deny'  priority: 4096 direction: 'Inbound' }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics:       true
    tags:                    tags
  }
}
```

#### Requis

- Permissions : `Network Contributor` sur le resource group cible
- Pour les flow logs : Network Watcher doit exister dans `networkWatcherRg`

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `nsgName` | string | — | ✅ | Nom du NSG |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `securityRules` | array | `[]` | ❌ | Règles de sécurité |
| `enableDiagnostics` | bool | `true` | ❌ | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ❌ | ID du Log Analytics Workspace |
| `enableFlowLogs` | bool | `false` | ❌ | Active les flow logs NSG |
| `flowLogsStorageAccountId` | string | `''` | ❌ | ID du compte de stockage |
| `flowLogsRetentionDays` | int | `7` | ❌ | Rétention des flow logs (jours) |
| `networkWatcherRg` | string | `NetworkWatcherRG` | ❌ | Resource group du Network Watcher |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `nsgId` | string | Resource ID complet du NSG |
| `nsgName` | string | Nom du NSG |
| `securityRules` | array | Règles de sécurité définies |

#### Ressources créées

- `Microsoft.Network/networkSecurityGroups`
- `Microsoft.Insights/diagnosticSettings` (logs uniquement — NSG ne supporte pas les métriques)
- Module `network_watcher_flowlogs.bicep` (si `enableFlowLogs = true`)

#### Dépendances

Optionnellement dépend d'un Network Watcher existant pour les flow logs.

---

### `public_ip.bicep`

#### Description

Crée une adresse IP publique Standard avec protection DDoS optionnelle.
Les zones de disponibilité se configurent ici — c'est la PIP qui porte
la redondance de zone pour les ressources associées (Firewall, Bastion, Gateway).

Les diagnostic settings sont conditionnels : les catégories de logs DDoS
ne sont activées que si `ddosProtectionMode != 'Disabled'` — elles n'existent pas
sans DDoS Standard actif.

#### Utilisation

```bicep
// IP publique pour Azure Firewall
module pipFirewall './modules/public_ip.bicep' = if (deployAzureFirewall) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-pip-firewall'
  params: {
    publicIpName:            'pip-afw-acmy-sbox'
    location:                'caea'
    sku:                     'Standard'
    allocationMethod:        'Static'
    zones:                   availabilityZones  // zone-redundancy portée par la PIP
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics:       true
    tags:                    tags
  }
}

// IP publique avec domainNameLabel (FQDN)
module pipBastion './modules/public_ip.bicep' = if (deployBastion) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-pip-bastion'
  params: {
    publicIpName:     'pip-bas-acmy-sbox'
    location:         'caea'
    domainNameLabel:  'bastion-acmy-sbox'  // → bastion-acmy-sbox.canadaeast.cloudapp.azure.com
    tags:             tags
  }
}
```

#### Requis

- SKU `Standard` obligatoire pour Azure Firewall, Bastion, VPN Gateway AZ, et Load Balancer Standard
- `allocationMethod: 'Static'` obligatoire avec SKU Standard

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `publicIpName` | string | — | ✅ | Nom de l'adresse IP publique |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `sku` | string | `Standard` | ❌ | `Basic` ou `Standard` |
| `allocationMethod` | string | `Static` | ❌ | `Static` ou `Dynamic` |
| `publicIpAddressVersion` | string | `IPv4` | ❌ | `IPv4` ou `IPv6` |
| `idleTimeoutInMinutes` | int | `4` | ❌ | Timeout d'inactivité (4-30 min) |
| `domainNameLabel` | string | `''` | ❌ | Label DNS pour FQDN |
| `zones` | array | `[]` | ❌ | Zones de disponibilité |
| `ddosProtectionMode` | string | `VirtualNetworkInherited` | ❌ | `Disabled`, `Enabled`, `VirtualNetworkInherited` |
| `ddosProtectionPlanId` | string | `''` | ❌ | ID du plan DDoS (si `Enabled`) |
| `enableDiagnostics` | bool | `true` | ❌ | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ❌ | ID du Log Analytics Workspace |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `publicIpId` | string | Resource ID complet de la PIP |
| `publicIpName` | string | Nom de la PIP |
| `ipAddress` | string | Adresse IP (disponible après allocation) |
| `fqdn` | string | FQDN complet (si `domainNameLabel` fourni) |

#### Ressources créées

- `Microsoft.Network/publicIPAddresses`
- `Microsoft.Insights/diagnosticSettings` (métriques seules si DDoS désactivé, logs + métriques si DDoS actif)

#### Dépendances

Aucune dépendance directe.

---

### `azure_firewall.bicep`

#### Description

Déploie Azure Firewall avec support des Firewall Policies, DNS proxy et Threat Intelligence.
Supporte les SKUs Standard, Premium et Basic, ainsi que le mode multi-IP publiques.

L'IP privée du Firewall est exposée en output et utilisée comme `nextHopIpAddress`
dans la route table pour forcer le trafic des spokes via le Firewall (UDR).

#### Utilisation

```bicep
module azureFirewall './modules/azure_firewall.bicep' = if (deployAzureFirewall) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-azure-firewall'
  params: {
    firewallName:            'afw-acmy-hub-sbox-caea'
    location:                'caea'
    skuName:                 'AZFW_VNet'
    skuTier:                 'Standard'
    subnetId:                '${hubVnet.outputs.vnetId}/subnets/AzureFirewallSubnet'
    publicIpAddressIds:      [pipFirewall.outputs.publicIpId]
    zones:                   availabilityZones
    enableDnsProxy:          true
    threatIntelMode:         'Alert'
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics:       true
    tags:                    tags
  }
}

// Utiliser l'IP privée pour la route table (UDR)
module routeTable './modules/route_table.bicep' = {
  params: {
    routes: [
      {
        name:             'DefaultToFirewall'
        addressPrefix:    '0.0.0.0/0'
        nextHopType:      'VirtualAppliance'
        nextHopIpAddress: azureFirewall.outputs.privateIpAddress  // ← output direct
      }
    ]
  }
}
```

#### Requis

- `AzureFirewallSubnet` doit exister dans le VNet hub (nom exact obligatoire)
- `AzureFirewallSubnet` ne doit pas avoir de NSG ni de route table
- SKU `Standard` des PIPs associées obligatoire

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `firewallName` | string | — | ✅ | Nom du Firewall |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `skuName` | string | `AZFW_VNet` | ❌ | `AZFW_VNet` ou `AZFW_Hub` |
| `skuTier` | string | `Standard` | ❌ | `Standard`, `Premium`, `Basic` |
| `subnetId` | string | — | ✅ | ID de `AzureFirewallSubnet` |
| `publicIpAddressIds` | array | — | ✅ | IDs des PIPs (au moins une) |
| `firewallPolicyId` | string | `''` | ❌ | ID de la Firewall Policy |
| `managementSubnetId` | string | `''` | ❌ | Subnet de gestion (SKU Basic uniquement) |
| `managementPublicIpId` | string | `''` | ❌ | PIP de gestion (SKU Basic uniquement) |
| `zones` | array | `[]` | ❌ | Zones de disponibilité |
| `enableDnsProxy` | bool | `true` | ❌ | Active le proxy DNS |
| `dnsServers` | array | `[]` | ❌ | Serveurs DNS personnalisés |
| `threatIntelMode` | string | `Alert` | ❌ | `Alert`, `Deny`, `Off` |
| `enableDiagnostics` | bool | `true` | ❌ | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ❌ | ID du Log Analytics Workspace |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `firewallId` | string | Resource ID complet du Firewall |
| `firewallName` | string | Nom du Firewall |
| `privateIpAddress` | string | **IP privée — utilisée pour les routes UDR** |
| `publicIpAddresses` | array | Détails des IPs publiques associées |

#### Ressources créées

- `Microsoft.Network/azureFirewalls`
- `Microsoft.Insights/diagnosticSettings`

#### Dépendances

Dépend de `public_ip.bicep` (au moins une PIP) et de `virtual_network.bicep` (subnet `AzureFirewallSubnet`).

---

### `vpn_gateway.bicep`

#### Description

Crée une passerelle VPN pour la connectivité hybride (site-to-site S2S et point-to-site P2S).
Supporte le mode active-active, BGP et les configurations P2S avec certificats, RADIUS ou Azure AD.

Les propriétés optionnelles (`bgpSettings`, `vpnClientConfiguration`) sont omises
via `union()` quand elles ne sont pas requises — évitant toute dissociation lors d'un redéploiement.

> **Délai** : Le déploiement d'un VPN Gateway prend 25-45 minutes. Planifier en conséquence.

#### Utilisation

```bicep
module vpnGateway './modules/vpn_gateway.bicep' = if (deployVpnGateway) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-vpn-gateway'
  params: {
    vpnGatewayName:          'vpngw-acmy-hub-sbox'
    location:                'caea'
    gatewaySku:              'VpnGw1'
    gatewayType:             'Vpn'
    vpnType:                 'RouteBased'
    vpnGatewayGeneration:    'Generation1'
    subnetId:                '${hubVnet.outputs.vnetId}/subnets/GatewaySubnet'
    publicIpAddressId:       pipVpnGateway.outputs.publicIpId
    enableBgp:               false
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics:       true
    tags:                    tags
  }
}
```

#### Requis

- `GatewaySubnet` doit exister dans le VNet hub (nom exact obligatoire, `/27` minimum)
- `GatewaySubnet` ne doit pas avoir de NSG ni de route table
- `Generation2` obligatoire pour les SKUs `VpnGw4`, `VpnGw5` et tous les SKUs `AZ`

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `vpnGatewayName` | string | — | ✅ | Nom de la VPN Gateway |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `gatewayType` | string | `Vpn` | ❌ | `Vpn` ou `ExpressRoute` |
| `vpnType` | string | `RouteBased` | ❌ | `RouteBased` ou `PolicyBased` |
| `gatewaySku` | string | `VpnGw1` | ❌ | `Basic`, `VpnGw1`–`VpnGw5`, `VpnGw1AZ`–`VpnGw5AZ` |
| `vpnGatewayGeneration` | string | `Generation1` | ❌ | `Generation1`, `Generation2`, `None` |
| `subnetId` | string | — | ✅ | ID de `GatewaySubnet` |
| `publicIpAddressId` | string | — | ✅ | ID de la PIP principale |
| `publicIpAddressId2` | string | `''` | ❌ | ID de la PIP secondaire (active-active) |
| `enableBgp` | bool | `false` | ❌ | Active BGP |
| `bgpAsn` | int | `65515` | ❌ | Numéro ASN BGP |
| `bgpPeeringAddress` | string | `''` | ❌ | Adresse de peering BGP |
| `activeActive` | bool | `false` | ❌ | Mode active-active |
| `customBgpIpAddresses` | array | `[]` | ❌ | IPs BGP custom (active-active) |
| `p2sConfiguration` | object | `{}` | ❌ | Configuration point-to-site |
| `enableDiagnostics` | bool | `true` | ❌ | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ❌ | ID du Log Analytics Workspace |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `vpnGatewayId` | string | Resource ID complet de la VPN Gateway |
| `vpnGatewayName` | string | Nom de la VPN Gateway |
| `bgpSettings` | object | Paramètres BGP (si BGP activé, sinon `{}`) |
| `publicIpAddress` | string | Adresse IP publique de la gateway |

#### Ressources créées

- `Microsoft.Network/virtualNetworkGateways`
- `Microsoft.Insights/diagnosticSettings`

#### Dépendances

Dépend de `public_ip.bicep` et de `virtual_network.bicep` (subnet `GatewaySubnet`).

---

### `azure_bastion.bicep`

#### Description

Déploie Azure Bastion pour l'accès RDP/SSH sécurisé aux VMs sans exposer de port public.
Supporte les SKUs Basic et Standard — les fonctionnalités avancées (tunneling, file copy,
shareable link) sont réservées au SKU Standard.

> **Contrainte réseau critique** : `AzureBastionSubnet` doit avoir un NSG **dédié**
> avec les règles obligatoires Microsoft. Un NSG non conforme bloque le déploiement
> avec l'erreur `NetworkSecurityGroupNotCompliantForAzureBastionSubnet`.

#### Utilisation

```bicep
module bastion './modules/azure_bastion.bicep' = if (deployBastion) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-bastion'
  params: {
    bastionName:             'bas-acmy-hub-sbox'
    location:                'caea'
    sku:                     'Standard'
    subnetId:                '${hubVnet.outputs.vnetId}/subnets/AzureBastionSubnet'
    publicIpAddressId:       pipBastion.outputs.publicIpId
    enableFileCopy:          true
    enableTunneling:         true
    scaleUnits:              2
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics:       true
    tags:                    tags
  }
}
```

#### Requis

- `AzureBastionSubnet` doit exister avec un préfixe `/26` minimum (SKU Standard)
- NSG dédié avec règles Microsoft obligatoires (voir `network_security_group.bicep`)
- Pas de route table sur `AzureBastionSubnet`

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `bastionName` | string | — | ✅ | Nom du Bastion |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `sku` | string | `Standard` | ❌ | `Basic` ou `Standard` |
| `subnetId` | string | — | ✅ | ID de `AzureBastionSubnet` |
| `publicIpAddressId` | string | — | ✅ | ID de la PIP |
| `enableIpConnect` | bool | `false` | ❌ | IP Connect (Standard uniquement) |
| `enableShareableLink` | bool | `false` | ❌ | Lien partageable (Standard uniquement) |
| `enableTunneling` | bool | `false` | ❌ | Tunneling natif (Standard uniquement) |
| `enableFileCopy` | bool | `false` | ❌ | Copie de fichiers (Standard uniquement) |
| `scaleUnits` | int | `2` | ❌ | Unités d'échelle (1 pour Basic, 2-50 pour Standard) |
| `enableDiagnostics` | bool | `true` | ❌ | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ❌ | ID du Log Analytics Workspace |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `bastionId` | string | Resource ID complet du Bastion |
| `bastionName` | string | Nom du Bastion |
| `dnsName` | string | Nom DNS du Bastion (pour connexion) |

#### Ressources créées

- `Microsoft.Network/bastionHosts`
- `Microsoft.Insights/diagnosticSettings`

#### Dépendances

Dépend de `public_ip.bicep` et de `network_security_group.bicep` (NSG dédié Bastion).

---

### `virtual_network_peering.bicep`

#### Description

Crée un peering VNet **unidirectionnel** entre deux VNets. Pour une topologie Hub-Spoke
complète, ce module doit être appelé **deux fois** — une fois depuis le spoke (spoke→hub)
et une fois depuis le hub (hub→spoke). Les deux appels sont orchestrés depuis `spoke.bicep`,
pas depuis l'orchestrateur connectivity.

> **Conception Hub-Spoke** : Le hub ne connaît pas les spokes. C'est chaque spoke
> qui orchestre les deux directions du peering depuis son propre orchestrateur,
> en passant `hubVnetId` reçu en paramètre depuis les outputs connectivity.

#### Utilisation

```bicep
// Dans spoke.bicep — les deux directions du peering

// Direction 1 : Spoke → Hub
module peeringSpokeToHub '../shared/modules/virtual_network_peering.bicep' = {
  scope: resourceGroup(spokeRg)
  name: 'peering-spoke-to-hub'
  params: {
    localVnetName:        spokeVnet.outputs.vnetName
    remoteVnetId:         hubVnetId               // output de connectivity-lz
    allowForwardedTraffic: true
    allowGatewayTransit:  false
    useRemoteGateways:    true                    // utilise la VPN Gateway du hub
  }
}

// Direction 2 : Hub → Spoke (scope cross-RG)
module peeringHubToSpoke '../shared/modules/virtual_network_peering.bicep' = {
  scope: resourceGroup(hubSubscriptionId, hubVnetResourceGroup)
  name: 'peering-hub-to-spoke'
  params: {
    localVnetName:        last(split(hubVnetId, '/'))
    remoteVnetId:         spokeVnet.outputs.vnetId
    allowForwardedTraffic: true
    allowGatewayTransit:  true                    // offre la gateway aux spokes
    useRemoteGateways:    false
  }
}
```

#### Requis

- Les deux VNets doivent exister avant le peering
- Le service principal de déploiement doit avoir `Network Contributor` sur les deux resource groups
- `allowGatewayTransit` et `useRemoteGateways` sont mutuellement exclusifs — le module applique une garde automatique

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `localVnetName` | string | — | ✅ | Nom du VNet local (source du peering) |
| `remoteVnetId` | string | — | ✅ | Resource ID du VNet distant |
| `peeringName` | string | `''` | ❌ | Nom du peering (auto-calculé si vide) |
| `allowVirtualNetworkAccess` | bool | `true` | ❌ | Autorise le trafic entre les VNets |
| `allowForwardedTraffic` | bool | `true` | ❌ | Autorise le trafic transmis |
| `allowGatewayTransit` | bool | `false` | ❌ | Offre la gateway aux VNets peérés (hub uniquement) |
| `useRemoteGateways` | bool | `false` | ❌ | Utilise la gateway du VNet distant (spokes uniquement) |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `peeringId` | string | Resource ID complet du peering |
| `peeringName` | string | Nom du peering |
| `peeringState` | string | État du peering (`Connected`, `Initiated`, `Disconnected`) |

#### Ressources créées

- `Microsoft.Network/virtualNetworks/virtualNetworkPeerings`

#### Dépendances

Dépend des deux VNets (local existant via `existing`, distant référencé par ID).

---

### `route_table.bicep`

#### Description

Crée une table de routage avec routes personnalisées (UDR). Utilisée principalement
pour forcer le trafic des subnets spoke via Azure Firewall (`nextHopType: 'VirtualAppliance'`).

`nextHopIpAddress` est omis via `union()` pour les types de hop qui ne le requièrent pas
(`Internet`, `VnetLocal`, `VirtualNetworkGateway`, `None`) — passer cette propriété
sur ces types cause une erreur ARM.

> **BGP** : `disableBgpRoutePropagation: true` est recommandé pour les subnets spoke
> dont le trafic doit transiter par le Firewall — sinon les routes BGP apprises
> par la VPN Gateway peuvent contourner les UDR.

#### Utilisation

```bicep
module routeTableManagement './modules/route_table.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-rt-management'
  params: {
    routeTableName:             'rt-hub-acmy-sbox-caea'
    location:                   'caea'
    disableBgpRoutePropagation: true
    routes: deployAzureFirewall ? [
      {
        name:             'DefaultToFirewall'
        addressPrefix:    '0.0.0.0/0'
        nextHopType:      'VirtualAppliance'
        nextHopIpAddress: azureFirewall.outputs.privateIpAddress  // ← IP privée du Firewall
      }
    ] : []
    tags: tags
  }
}
```

#### Requis

- Pour `nextHopType: 'VirtualAppliance'` : `nextHopIpAddress` obligatoire
- Pour tous les autres types : `nextHopIpAddress` doit être absent (géré automatiquement)

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `routeTableName` | string | — | ✅ | Nom de la route table |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `disableBgpRoutePropagation` | bool | `false` | ❌ | Désactive la propagation des routes BGP |
| `routes` | array | `[]` | ❌ | Routes personnalisées |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `routeTableId` | string | Resource ID complet de la route table |
| `routeTableName` | string | Nom de la route table |
| `routes` | array | Routes définies dans la table |

#### Ressources créées

- `Microsoft.Network/routeTables`

#### Dépendances

Pour les routes `VirtualAppliance`, dépend de `azure_firewall.bicep` (IP privée).

---

### `nat_gateway.bicep`

#### Description

Crée un NAT Gateway Standard pour la sortie internet des subnets sans IP publique directe.
L'association subnet ↔ NAT Gateway se fait sur le subnet (via `natGatewayId` dans
`virtual_network.bicep` ou `subnet.bicep`) — pas sur la ressource NAT Gateway elle-même.

NAT Gateway ne supporte qu'**une seule zone de disponibilité** (ou aucune pour le mode régional).

#### Utilisation

```bicep
module natGateway './modules/nat_gateway.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-nat-gateway'
  params: {
    natGatewayName:       'natgw-acmy-sbox-caea'
    location:             'caea'
    publicIpAddressIds:   [pipNatGateway.outputs.publicIpId]
    idleTimeoutInMinutes: 10
    zones:                ['1']  // une seule zone — NAT Gateway ne supporte pas la multi-zone
    enableDiagnostics:    true
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    tags:                 tags
  }
}

// Associer au subnet via virtual_network.bicep ou subnet.bicep
{
  name:          'snet-workloads'
  addressPrefix: '10.0.4.0/24'
  natGatewayId:  natGateway.outputs.natGatewayId  // ← association ici, pas sur la ressource NAT
}
```

#### Requis

- SKU Standard uniquement (forcé dans le module)
- Maximum une zone dans le tableau `zones`

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `natGatewayName` | string | — | ✅ | Nom du NAT Gateway |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `publicIpAddressIds` | array | `[]` | ❌ | IDs des PIPs associées |
| `publicIpPrefixIds` | array | `[]` | ❌ | IDs des préfixes IP publics |
| `idleTimeoutInMinutes` | int | `4` | ❌ | Timeout d'inactivité (4-120 min) |
| `zones` | array | `[]` | ❌ | Zone de disponibilité (0 ou 1 élément) |
| `enableDiagnostics` | bool | `true` | ❌ | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ❌ | ID du Log Analytics Workspace |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `natGatewayId` | string | Resource ID complet du NAT Gateway |
| `natGatewayName` | string | Nom du NAT Gateway |

#### Ressources créées

- `Microsoft.Network/natGateways`
- `Microsoft.Insights/diagnosticSettings` (métriques uniquement — NAT Gateway n'a pas de logs)

#### Dépendances

Dépend de `public_ip.bicep` (au moins une PIP ou un préfixe IP public).

---

### `azure_load_balancer.bicep`

#### Description

Crée un Load Balancer Layer 4 public ou interne. La redondance de zone est portée
par la Public IP associée (pas par le Load Balancer lui-même — la propriété `zones`
n'existe pas sur `Microsoft.Network/loadBalancers`).

#### Utilisation

```bicep
// Load Balancer public Standard
module lbPublic './modules/azure_load_balancer.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-lb-public'
  params: {
    loadBalancerName: 'lb-acmy-sbox-caea'
    location:         'caea'
    sku:              'Standard'
    type:             'Public'
    publicIpAddressId: pipLb.outputs.publicIpId
    backendAddressPools: [{ name: 'backendPool' }]
    probes: [
      { name: 'healthProbe' properties: { protocol: 'Tcp' port: 80 intervalInSeconds: 5 numberOfProbes: 2 } }
    ]
    loadBalancingRules: [
      { name: 'rule-http' properties: { frontendIPConfigurationName: 'frontendIpConfig' backendAddressPoolName: 'backendPool' probeName: 'healthProbe' protocol: 'Tcp' frontendPort: 80 backendPort: 80 } }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics:       true
    tags:                    tags
  }
}
```

#### Requis

- SKU `Standard` requis pour les zones de disponibilité et les règles outbound
- La zone-redondance se configure sur la PIP associée, pas sur le LB

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `loadBalancerName` | string | — | ✅ | Nom du Load Balancer |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `sku` | string | `Standard` | ❌ | `Basic`, `Standard`, `Gateway` |
| `type` | string | `Public` | ❌ | `Public` ou `Internal` |
| `publicIpAddressId` | string | `''` | ❌ | ID de la PIP (LB public) |
| `subnetId` | string | `''` | ❌ | ID du subnet (LB interne) |
| `privateIpAddress` | string | `''` | ❌ | IP privée fixe (LB interne) |
| `privateIpAllocationMethod` | string | `Dynamic` | ❌ | `Dynamic` ou `Static` |
| `frontendIpConfigurations` | array | `[]` | ❌ | Configs frontend personnalisées |
| `backendAddressPools` | array | `[]` | ❌ | Pools backend |
| `loadBalancingRules` | array | `[]` | ❌ | Règles de load balancing |
| `probes` | array | `[]` | ❌ | Health probes |
| `inboundNatRules` | array | `[]` | ❌ | Règles NAT entrantes |
| `outboundRules` | array | `[]` | ❌ | Règles sortantes |
| `enableDiagnostics` | bool | `true` | ❌ | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ❌ | ID du Log Analytics Workspace |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `loadBalancerId` | string | Resource ID complet du Load Balancer |
| `loadBalancerName` | string | Nom du Load Balancer |
| `frontendIpConfigurationIds` | array | IDs des configurations frontend |
| `backendAddressPoolIds` | array | IDs des pools backend |
| `privateIpAddress` | string | IP privée frontend (LB interne uniquement) |

#### Ressources créées

- `Microsoft.Network/loadBalancers`
- `Microsoft.Insights/diagnosticSettings` (métriques uniquement — les catégories de logs Basic sont dépréciées)

#### Dépendances

Dépend de `public_ip.bicep` (si LB public) ou d'un subnet existant (si LB interne).

---

### `application_gateway.bicep`

#### Description

Déploie un Application Gateway Layer 7 avec WAF optionnel (SKU `WAF_v2`).
Supporte l'autoscaling, les certificats SSL et les règles de routage basées sur les URLs.

La catégorie de log `ApplicationGatewayFirewallLog` n'est activée
que pour le SKU `WAF_v2` — elle n'existe pas sur `Standard_v2`.

#### Utilisation

```bicep
module appGateway './modules/application_gateway.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-app-gateway'
  params: {
    applicationGatewayName: 'agw-acmy-sbox-caea'
    location:               'caea'
    skuName:                'Standard_v2'
    tier:                   'Standard_v2'
    enableAutoscaling:      true
    minCapacity:            2
    maxCapacity:            10
    subnetId:               '${spokeVnet.outputs.vnetId}/subnets/snet-agw'
    publicIpAddressId:      pipAgw.outputs.publicIpId
    backendAddressPools:    [{ name: 'backendPool' addresses: [] }]
    backendHttpSettingsCollection: [
      { name: 'httpSettings' properties: { port: 80 protocol: 'Http' cookieBasedAffinity: 'Disabled' requestTimeout: 30 } }
    ]
    httpListeners: [
      { name: 'httpListener' properties: { frontendIPConfigurationName: 'appGwPublicFrontendIp' frontendPortName: 'port_80' protocol: 'Http' } }
    ]
    requestRoutingRules: [
      { name: 'routingRule' properties: { ruleType: 'Basic' priority: 100 httpListenerName: 'httpListener' backendAddressPoolName: 'backendPool' backendHttpSettingsName: 'httpSettings' } }
    ]
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    enableDiagnostics:       true
    tags:                    tags
  }
}
```

#### Requis

- Subnet dédié pour l'Application Gateway (non partageable avec d'autres ressources)
- PIP SKU Standard obligatoire pour `Standard_v2` et `WAF_v2`

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `applicationGatewayName` | string | — | ✅ | Nom de l'Application Gateway |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `skuName` | string | `Standard_v2` | ❌ | `Standard_v2` ou `WAF_v2` |
| `tier` | string | `Standard_v2` | ❌ | `Standard_v2` ou `WAF_v2` |
| `capacity` | int | `2` | ❌ | Instances (si autoscaling désactivé) |
| `enableAutoscaling` | bool | `true` | ❌ | Active l'autoscaling |
| `minCapacity` | int | `2` | ❌ | Minimum d'instances (autoscaling) |
| `maxCapacity` | int | `10` | ❌ | Maximum d'instances (autoscaling) |
| `subnetId` | string | — | ✅ | ID du subnet dédié |
| `publicIpAddressId` | string | — | ✅ | ID de la PIP |
| `backendAddressPools` | array | — | ✅ | Pools d'adresses backend |
| `backendHttpSettingsCollection` | array | — | ✅ | Paramètres HTTP backend |
| `httpListeners` | array | — | ✅ | Écouteurs HTTP/HTTPS |
| `requestRoutingRules` | array | — | ✅ | Règles de routage des requêtes |
| `frontendPorts` | array | `[80, 443]` | ❌ | Ports frontend |
| `sslCertificates` | array | `[]` | ❌ | Certificats SSL |
| `wafConfiguration` | object | `{}` | ❌ | Configuration WAF (`WAF_v2` uniquement) |
| `zones` | array | `[]` | ❌ | Zones de disponibilité |
| `enableDiagnostics` | bool | `true` | ❌ | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ❌ | ID du Log Analytics Workspace |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `applicationGatewayId` | string | Resource ID complet de l'Application Gateway |
| `applicationGatewayName` | string | Nom de l'Application Gateway |
| `backendAddressPoolIds` | array | IDs des pools backend |

#### Ressources créées

- `Microsoft.Network/applicationGateways`
- `Microsoft.Insights/diagnosticSettings`

#### Dépendances

Dépend de `public_ip.bicep` et d'un subnet dédié dans `virtual_network.bicep`.

---

### `private_dns_zone.bicep`

#### Description

Crée une zone DNS privée pour la résolution des Private Endpoints. La zone est créée
avec `location: 'global'` (obligatoire pour les zones DNS privées) et peut être liée
à plusieurs VNets via des Virtual Network Links.

> **Limite** : `enableAutoRegistration: true` n'est supporté que pour **une seule**
> liaison VNet par zone DNS privée. Utiliser `false` (défaut) pour les zones
> de Private Endpoints — l'enregistrement automatique est réservé aux VMs.

#### Utilisation

```bicep
// Zone DNS pour Azure Storage Blob (Private Endpoint)
module privateDnsBlob './modules/private_dns_zone.bicep' = {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-dns-privatelink-blob'
  params: {
    privateDnsZoneName:   'privatelink.blob.core.windows.net'
    vnetLinksVnetIds:     [
      hubVnet.outputs.vnetId
      spokeVnet.outputs.vnetId  // lier les spokes qui utilisent ce service
    ]
    enableAutoRegistration: false  // false pour Private Endpoints
    tags:                   tags
  }
}

// Zones courantes pour les services PaaS Azure
// privatelink.blob.core.windows.net       → Azure Blob Storage
// privatelink.file.core.windows.net       → Azure Files
// privatelink.vaultcore.azure.net         → Azure Key Vault
// privatelink.database.windows.net        → Azure SQL
// privatelink.azurecr.io                  → Azure Container Registry
// privatelink.azurewebsites.net           → Azure App Service
```

#### Requis

- Les VNets à lier doivent exister avant la création des liens
- Permissions : `Private DNS Zone Contributor` sur le resource group

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `privateDnsZoneName` | string | — | ✅ | Nom FQDN de la zone (ex: `privatelink.blob.core.windows.net`) |
| `vnetLinksVnetIds` | array | `[]` | ❌ | Resource IDs des VNets à lier |
| `enableAutoRegistration` | bool | `false` | ❌ | Enregistrement auto des VMs — **une seule liaison par zone** |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `privateDnsZoneId` | string | Resource ID complet de la zone DNS |
| `privateDnsZoneName` | string | Nom FQDN de la zone |
| `vnetLinkIds` | array | Resource IDs des Virtual Network Links créés |

#### Ressources créées

- `Microsoft.Network/privateDnsZones`
- `Microsoft.Network/privateDnsZones/virtualNetworkLinks` (une par VNet lié)

#### Dépendances

Aucune dépendance directe. Les VNets référencés doivent exister.

---

### `network_watcher_flowlogs.bicep`

#### Description

Configure les Flow Logs NSG via un Network Watcher existant. Déployé dans le scope
du resource group du Network Watcher (`NetworkWatcherRG` par défaut).
Appelé automatiquement par `network_security_group.bicep` quand `enableFlowLogs = true`.

#### Utilisation

```bicep
// Appelé automatiquement depuis network_security_group.bicep
// Appel direct depuis un orchestrateur :
module flowLogs './modules/network_watcher_flowlogs.bicep' = {
  scope: resourceGroup(networkWatcherRg)
  name: 'deploy-flowlogs-${nsgName}'
  params: {
    networkWatcherName:      'NetworkWatcher_canadaeast'
    nsgId:                   nsg.outputs.nsgId
    flowLogsStorageAccountId: storageAccountId
    location:                'canadaeast'    // résolu, pas abrégé
    flowLogsRetentionDays:   30
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    flowLogName:             '${nsgName}-flowlogs'
    tags:                    tags
  }
}
```

#### Requis

- Network Watcher doit exister dans `networkWatcherRg` pour la région cible
- Compte de stockage doit exister dans la même région

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `networkWatcherName` | string | — | ✅ | Nom du Network Watcher existant |
| `nsgId` | string | — | ✅ | Resource ID du NSG à monitorer |
| `flowLogsStorageAccountId` | string | — | ✅ | Resource ID du compte de stockage |
| `location` | string | — | ✅ | Région (nom complet — ex: `canadaeast`) |
| `flowLogsRetentionDays` | int | — | ✅ | Rétention des logs en jours |
| `logAnalyticsWorkspaceId` | string | — | ✅ | ID du Log Analytics Workspace |
| `flowLogName` | string | — | ✅ | Nom de la ressource flow log |
| `tags` | object | — | ✅ | Tags à appliquer |

#### Outputs

Aucun output — la ressource est configurée directement sous le Network Watcher.

#### Ressources créées

- `Microsoft.Network/networkWatchers/flowLogs`

#### Dépendances

Dépend d'un Network Watcher existant et d'un compte de stockage.

---

### `ddos_protection.bicep`

#### Description

Crée un plan de protection DDoS Network Standard. Ce plan est associé aux VNets
via le paramètre `ddosProtectionPlanId` dans `virtual_network.bicep`.

> **Coût** : Un plan DDoS Network Standard représente un coût fixe mensuel significatif
> (~$2,944 CAD/mois). Désactiver en sandbox (`deployDdosProtection: false`).

#### Utilisation

```bicep
module ddosProtection './modules/ddos_protection.bicep' = if (deployDdosProtection) {
  scope: resourceGroup(connectivityResourceGroupName)
  name: 'deploy-ddos-protection'
  params: {
    ddosProtectionPlanName: 'ddos-acmy-sbox'
    location:               'caea'
    tags:                   tags
  }
}

// Associer au VNet (avec opérateur ?. pour module conditionnel)
module hubVnet './modules/virtual_network.bicep' = {
  params: {
    enableDdosProtection: deployDdosProtection
    ddosProtectionPlanId: ddosProtection.?outputs.ddosProtectionPlanId ?? ''
  }
}
```

#### Requis

- Un seul plan DDoS Standard peut protéger plusieurs VNets dans le même tenant
- Permissions : `Contributor` sur la subscription

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `ddosProtectionPlanName` | string | — | ✅ | Nom du plan DDoS |
| `location` | string | — | ✅ | Région (`cace` ou `caea`) |
| `tags` | object | `{}` | ❌ | Tags à appliquer |

#### Outputs

| Output | Type | Description |
|---|---|---|
| `ddosProtectionPlanId` | string | Resource ID complet du plan DDoS |
| `ddosProtectionPlanName` | string | Nom du plan DDoS |

#### Ressources créées

- `Microsoft.Network/ddosProtectionPlans`

#### Dépendances

Aucune dépendance directe. À associer aux VNets via `virtual_network.bicep`.

---

## Bonnes pratiques IaC

### Subnets réservés — contraintes Azure

```bicep
// ❌ Ne jamais attacher NSG ou route table sur ces subnets
{ name: 'GatewaySubnet'        ... }  // VPN/ExpressRoute Gateway
{ name: 'AzureFirewallSubnet'  ... }  // Azure Firewall
{ name: 'AzureFirewallManagementSubnet' ... }  // Azure Firewall Basic

// ❌ Ne jamais attacher de route table sur ce subnet
{ name: 'AzureBastionSubnet'   ... }  // NSG dédié obligatoire, pas de route table

// ✅ Taille minimale requise
'AzureBastionSubnet'  → /26 minimum  (SKU Standard)
'AzureFirewallSubnet' → /26 minimum
'GatewaySubnet'       → /27 minimum
```

### Déploiement en deux phases pour éviter les dépendances circulaires

```bicep
// Phase 1 — VNet sans route table sur le subnet management
module hubVnet '...' = {
  params: {
    subnets: [
      { name: 'snet-hub-management'  networkSecurityGroupId: nsgManagement.outputs.nsgId }
      // routeTableId absent — Firewall pas encore déployé
    ]
  }
}

// Phase 2 — Appliquer la route table après déploiement du Firewall
module managementSubnet './modules/subnet.bicep' = {
  params: {
    routeTableId: routeTableManagement.outputs.routeTableId  // IP Firewall maintenant disponible
  }
}
```

### Modules conditionnels — opérateur `?.` obligatoire

```bicep
// ❌ Erreur de compilation si deployBastion = false
networkSecurityGroupId: nsgBastion.outputs.nsgId

// ✅ Opérateur ?. pour accéder à l'output d'un module conditionnel
networkSecurityGroupId: nsgBastion.?outputs.nsgId ?? ''
```

### `union()` plutôt que `null` pour les propriétés optionnelles

```bicep
// ❌ null dissocie la ressource existante lors d'un redéploiement
routeTable: !empty(routeTableId) ? { id: routeTableId } : null

// ✅ union() omet la propriété — ARM ignore ce qui n'est pas spécifié
properties: union(
  { addressPrefix: addressPrefix },
  !empty(routeTableId) ? { routeTable: { id: routeTableId } } : {}
)
```

### Diagnostic settings — règles de compatibilité

```bicep
// ❌ NSG ne supporte PAS les métriques
metrics: [{ category: 'AllMetrics' enabled: true }]  // → erreur ARM sur NSG

// ❌ NAT Gateway et Load Balancer n'ont PAS de logs
logs: [{ categoryGroup: 'allLogs' enabled: true }]   // → erreur ARM

// ✅ Référence rapide
// NSG           → logs uniquement (categoryGroup: 'allLogs')
// NAT Gateway   → métriques uniquement
// Load Balancer → métriques uniquement
// Tous les autres → logs (allLogs) + métriques (AllMetrics)
```

---

## Troubleshooting

### `NetworkSecurityGroupNotCompliantForAzureBastionSubnet`

**Cause** : NSG partagé entre `AzureBastionSubnet` et un autre subnet, ou règles obligatoires manquantes.

**Solution** : Créer un NSG dédié pour `AzureBastionSubnet` avec exactement les 8 règles
obligatoires Microsoft (4 inbound + 4 outbound). Voir exemple dans `network_security_group.bicep`.

### `BadRequest — Diagnostic setting does not support mix of log category and log category group`

**Cause** : Mélange de `category` et `categoryGroup` dans le même bloc `diagnosticSettings`.

**Solution** : Utiliser exclusivement `categoryGroup: 'allLogs'` ou exclusivement des
`category` individuelles — jamais les deux dans la même ressource.

### `BadRequest — Metric export is not enabled`

**Cause** : Bloc `metrics` présent sur une ressource qui ne supporte pas les métriques (NSG).

**Solution** : Retirer le bloc `metrics` du `diagnosticSettings` des NSGs.

### `BadRequest — CategoryGroup: 'audit' is not supported`

**Cause** : `categoryGroup: 'audit'` utilisé sur une ressource qui ne le supporte pas (ex: Azure Firewall).

**Solution** : Utiliser uniquement `categoryGroup: 'allLogs'`. Vérifier le message d'erreur
ARM — il liste explicitement les `categoryGroup` supportés par la ressource.

### Peering en état `Initiated` (pas `Connected`)

**Cause** : Un seul côté du peering a été créé.

**Solution** : Vérifier que les deux directions du peering existent (hub→spoke et spoke→hub).
Le peering doit être créé des deux côtés pour passer à l'état `Connected`.

---

## Ressources

- [Hub-Spoke Network Topology](https://learn.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
- [Azure Firewall Documentation](https://learn.microsoft.com/azure/firewall/)
- [Azure Bastion NSG Requirements](https://learn.microsoft.com/azure/bastion/bastion-nsg)
- [VPN Gateway Planning](https://learn.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Private DNS Zones](https://learn.microsoft.com/azure/dns/private-dns-overview)
- [Network Security Best Practices](https://learn.microsoft.com/azure/security/fundamentals/network-best-practices)
- [Azure Landing Zones](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/)