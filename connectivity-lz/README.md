# Connectivity Landing Zone — Modules et utilisation

Ce document décrit les modules Bicep fournis dans `connectivity-lz/modules`, leur rôle, leurs entrées/sorties, ressources créées et dépendances. Il est structuré pour faciliter l'utilisation selon les bonnes pratiques IaC.

## Description

Ce dossier contient des modules réutilisables pour déployer les éléments de la Connectivity Landing Zone avec topologie Hub-Spoke :
- `virtual_network.bicep` : création de réseaux virtuels avec subnets et diagnostic settings.
- `subnet.bicep` : création de subnets individuels au sein d'un VNet.
- `network_security_group.bicep` : création de NSGs avec règles de sécurité et flow logs.
- `public_ip.bicep` : création d'adresses IP publiques avec protection DDoS optionnelle.
- `azure_firewall.bicep` : déploiement du firewall managé Azure Firewall.
- `vpn_gateway.bicep` : création de passerelles VPN pour connectivité hybride.
- `azure_bastion.bicep` : déploiement d'Azure Bastion pour accès sécurisé RDP/SSH.
- `virtual_network_peering.bicep` : établissement du peering VNet pour topologie Hub-Spoke.
- `route_table.bicep` : création de tables de routage avec routes personnalisées.
- `nat_gateway.bicep` : déploiement de NAT Gateway pour sortie internet.
- `azure_load_balancer.bicep` : création de load balancers (Layer 4).
- `application_gateway.bicep` : déploiement d'Application Gateway (Layer 7) avec WAF optionnel.
- `private_dns_zone.bicep` : création de zones DNS privées pour Private Endpoints.
- `network_watcher_flowlogs.bicep` : configuration des flow logs NSG.
- `ddos_protection.bicep` : création de plans de protection DDoS.

## Utilisation

Principes d'utilisation :
- Appeler chaque module depuis un template d'orchestration (ex. `connectivity/hub/main.bicep`).
- Spécifier correctement le `scope` du module (`subscription`, `resourceGroup`, etc.).
- Utiliser des fichiers de paramètres séparés par environnement (`.bicepparam`).
- Tester avec `--what-if` avant déploiement réel.
- Utiliser des `outputs` de module comme entrées de modules ultérieurs pour conserver la traçabilité.

### Exemples d'appel complets

```bicep
// 1. Créer un VNet avec subnets
module vnetHub 'modules/virtual_network.bicep' = {
  name: 'vnet-hub-prod'
  scope: resourceGroup(rgName)
  params: {
    vnetName: 'vnet-hub-canadacentral'
    location: 'cace'
    addressPrefixes: ['10.0.0.0/16']
    enableDdosProtection: false
    enableDiagnostics: true
    logAnalyticsWorkspaceId: lawId
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        addressPrefix: '10.0.1.0/26'
      }
      {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.0.0/27'
      }
    ]
  }
}

// 2. Créer une IP publique pour le Firewall
module pipFirewall 'modules/public_ip.bicep' = {
  name: 'pip-afw-prod'
  scope: resourceGroup(rgName)
  params: {
    publicIpName: 'pip-afw-prod'
    location: 'cace'
    sku: 'Standard'
    allocationMethod: 'Static'
    domainNameLabel: 'afw-prod-company'
    enableDiagnostics: true
    logAnalyticsWorkspaceId: lawId
  }
}

// 3. Déployer le Firewall
module firewallHub 'modules/azure_firewall.bicep' = {
  name: 'afw-hub-prod'
  scope: resourceGroup(rgName)
  params: {
    firewallName: 'afw-hub-prod'
    location: 'cace'
    skuTier: 'Standard'
    skuName: 'AZFW_VNet'
    subnetId: '${vnetHub.outputs.vnetId}/subnets/AzureFirewallSubnet'
    publicIpAddressIds: [pipFirewall.outputs.publicIpId]
    threatIntelMode: 'Alert'
    enableDiagnostics: true
    logAnalyticsWorkspaceId: lawId
  }
}

// 4. Créer une table de routage pour diriger le trafic via le Firewall
module rtgWildcard 'modules/route_table.bicep' = {
  name: 'rtg-internet-prod'
  scope: resourceGroup(rgName)
  params: {
    routeTableName: 'rtg-internet-prod'
    location: 'cace'
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'route-internet-via-fw'
        addressPrefix: '0.0.0.0/0'
        nextHopType: 'VirtualAppliance'
        nextHopIpAddress: firewallHub.outputs.privateIpAddress
      }
    ]
  }
}

// 5. Créer un VNet Spoke avec peering
module vnetSpoke 'modules/virtual_network.bicep' = {
  name: 'vnet-spoke-prod'
  scope: resourceGroup(rgName)
  params: {
    vnetName: 'vnet-spoke-app-prod'
    location: 'cace'
    addressPrefixes: ['10.1.0.0/16']
    subnets: [
      {
        name: 'snet-app'
        addressPrefix: '10.1.1.0/24'
        routeTableId: rtgWildcard.outputs.routeTableId
      }
    ]
    enableDiagnostics: true
    logAnalyticsWorkspaceId: lawId
  }
}

// 6. Établir le peering Hub->Spoke
module peeringHubToSpoke 'modules/virtual_network_peering.bicep' = {
  name: 'peering-hub-spoke'
  scope: resourceGroup(rgName)
  params: {
    localVnetName: vnetHub.outputs.vnetName
    remoteVnetId: vnetSpoke.outputs.vnetId
    allowForwardedTraffic: true
    allowGatewayTransit: true
  }
}
```

## Requis
## Requis

- Azure CLI (ou PowerShell) avec connexion active
- Bicep CLI installé
- Log Analytics Workspace déployé (pour l'intégration diagnostics)
- Permissions : `Contributor` ou `Network Contributor` sur la subscription

## Inputs / Outputs (global)

Ce README documente les inputs/outputs par module ci-dessous. Les paramètres attendus doivent être fournis via les appels de module ou le fichier `.bicepparam`.

## Ressources créées

- Virtual Networks : `Microsoft.Network/virtualNetworks`
- Subnets : `Microsoft.Network/virtualNetworks/subnets`
- Network Security Groups : `Microsoft.Network/networkSecurityGroups`
- Public IPs : `Microsoft.Network/publicIPAddresses`
- Azure Firewall : `Microsoft.Network/azureFirewalls`
- VPN Gateway : `Microsoft.Network/virtualNetworkGateways`
- Azure Bastion : `Microsoft.Network/bastionHosts`
- Load Balancer : `Microsoft.Network/loadBalancers`
- Application Gateway : `Microsoft.Network/applicationGateways`
- VNet Peering : `Microsoft.Network/virtualNetworks/virtualNetworkPeerings`
- Route Tables : `Microsoft.Network/routeTables`
- NAT Gateway : `Microsoft.Network/natGateways`
- Private DNS Zones : `Microsoft.Network/privateDnsZones`
- DDoS Protection Plan : `Microsoft.Network/ddosProtectionPlans`

## Dépendances

- `subnet` dépend d'un VNet existant (référencé par `vnetName`).
- `azure_firewall` dépend d'une adresse IP publique et d'un subnet (AzureFirewallSubnet).
- `vpn_gateway` dépend d'une adresse IP publique et du subnet GatewaySubnet.
- `azure_bastion` dépend d'une adresse IP publique et du subnet AzureBastionSubnet.
- `virtual_network_peering` dépend des deux VNets (local et remote).
- `nat_gateway` dépend d'une ou plusieurs adresses IP publiques.

---

## Modules — détails (Inputs / Outputs / Ressources / Dépendances)

### virtual_network.bicep
Description : Crée un réseau virtuel avec subnets, diagnostic settings et flow logs optionnels.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `vnetName` | string | - | Nom du VNet |
| `location` | string | - | Région Azure |
| `addressPrefixes` | array | - | Espaces d'adressage CIDR |
| `subnets` | array | `[]` | Configuration des sous-réseaux |
| `enableDdosProtection` | bool | `false` | Active la protection DDoS |
| `ddosProtectionPlanId` | string | `''` | ID du plan DDoS si protection activée |
| `enableVmProtection` | bool | `false` | Active la protection des VMs |
| `dnsServers` | array | `[]` | Serveurs DNS personnalisés |
| `enableDiagnostics` | bool | `true` | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ID du Log Analytics |
| `enableFlowLogs` | bool | `false` | Active les flow logs |
| `flowLogsStorageAccountId` | string | `''` | ID du compte stockage pour flow logs |
| `enableTrafficAnalytics` | bool | `false` | Active l'analyse de trafic |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `vnetId` | string | ID du VNet |
| `vnetName` | string | Nom du VNet |
| `addressPrefixes` | array | Espaces d'adressage du VNet |
| `subnetIds` | array | IDs de tous les subnets |
| `subnetDetails` | array | Détails de chaque subnet |

Ressources : `Microsoft.Network/virtualNetworks`, `Microsoft.Network/virtualNetworks/subnets`, `Microsoft.Insights/diagnosticSettings`, `Microsoft.Network/networkWatchers/flowLogs`

Dépendances : aucune directe.

### subnet.bicep
Description : Crée un subnet individuel au sein d'un VNet existant.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `vnetName` | string | - | Nom du VNet parent |
| `subnetName` | string | - | Nom du subnet |
| `addressPrefix` | string | - | Préfixe CIDR du subnet |
| `networkSecurityGroupId` | string | `''` | ID du NSG à associer |
| `routeTableId` | string | `''` | ID de la table de routage |
| `serviceEndpoints` | array | `[]` | Points de terminaison de service |
| `delegations` | array | `[]` | Délégations de subnet |
| `privateEndpointNetworkPolicies` | string | `Disabled` | Politique pour Private Endpoints |
| `privateLinkServiceNetworkPolicies` | string | `Enabled` | Politique pour Private Link Services |
| `natGatewayId` | string | `''` | ID du NAT Gateway |

| Output | Type | Description |
|---|---|---|
| `subnetId` | string | ID du subnet |
| `subnetName` | string | Nom du subnet |
| `addressPrefix` | string | Préfixe d'adresse du subnet |

Ressources : `Microsoft.Network/virtualNetworks/subnets`

Dépendances : dépend d'un VNet existant.

### network_security_group.bicep
Description : Crée un NSG avec règles de sécurité et flow logs optionnels.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `nsgName` | string | - | Nom du NSG |
| `location` | string | - | Région Azure |
| `securityRules` | array | `[]` | Règles de sécurité |
| `enableDiagnostics` | bool | `true` | Active les diagnostic settings |
| `logAnalyticsWorkspaceId` | string | `''` | ID du Log Analytics |
| `enableFlowLogs` | bool | `false` | Active les flow logs |
| `flowLogsStorageAccountId` | string | `''` | ID du compte stockage |
| `flowLogsRetentionDays` | int | `7` | Rétention des flow logs |
| `networkWatcherRg` | string | `NetworkWatcherRG` | RG du Network Watcher |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `nsgId` | string | ID du NSG |
| `nsgName` | string | Nom du NSG |
| `securityRules` | array | Règles définies |

Ressources : `Microsoft.Network/networkSecurityGroups`, `Microsoft.Insights/diagnosticSettings`, `Microsoft.Network/networkWatchers/flowLogs`

Dépendances : optionnellement liée à un Network Watcher existant.

### public_ip.bicep
Description : Crée une adresse IP publique avec protection DDoS optionnelle.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `publicIpName` | string | - | Nom de l'adresse IP |
| `location` | string | - | Région Azure |
| `sku` | string | `Standard` | SKU (Basic ou Standard) |
| `allocationMethod` | string | `Static` | Méthode d'allocation |
| `publicIpAddressVersion` | string | `IPv4` | Version IP |
| `idleTimeoutInMinutes` | int | `4` | Timeout d'inactivité |
| `domainNameLabel` | string | `''` | Label pour DNS |
| `zones` | array | `[]` | Zones de disponibilité |
| `ddosProtectionMode` | string | `VirtualNetworkInherited` | Mode protection DDoS |
| `ddosProtectionPlanId` | string | `''` | ID du plan DDoS |
| `enableDiagnostics` | bool | `true` | Active les diagnostics |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `publicIpId` | string | ID de l'adresse IP |
| `publicIpName` | string | Nom de l'adresse IP |
| `ipAddress` | string | Adresse IP (une fois attribuée) |
| `fqdn` | string | FQDN (si domainNameLabel fourni) |

Ressources : `Microsoft.Network/publicIPAddresses`, `Microsoft.Insights/diagnosticSettings`

Dépendances : aucune directe.

### azure_firewall.bicep
Description : Déploie Azure Firewall avec support des policies.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `firewallName` | string | - | Nom du Firewall |
| `location` | string | - | Région Azure |
| `skuName` | string | `AZFW_VNet` | SKU du Firewall |
| `skuTier` | string | `Standard` | Tier (Standard, Premium, Basic) |
| `subnetId` | string | - | ID du subnet AzureFirewallSubnet |
| `publicIpAddressIds` | array | - | IDs des adresses IP publiques |
| `firewallPolicyId` | string | `''` | ID de la Firewall Policy |
| `managementSubnetId` | string | `''` | Subnet de gestion (pour Basic) |
| `managementPublicIpId` | string | `''` | IP publique de gestion (pour Basic) |
| `zones` | array | `[]` | Zones de disponibilité |
| `enableDnsProxy` | bool | `true` | Active le proxy DNS |
| `threatIntelMode` | string | `Alert` | Mode Threat Intelligence |
| `enableDiagnostics` | bool | `true` | Active les diagnostics |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `firewallId` | string | ID du Firewall |
| `firewallName` | string | Nom du Firewall |
| `privateIpAddress` | string | IP privée du Firewall |
| `publicIpAddresses` | array | Détails des IPs publiques |

Ressources : `Microsoft.Network/azureFirewalls`, `Microsoft.Insights/diagnosticSettings`

Dépendances : dépend d'une adresse IP publique et d'un subnet.

### vpn_gateway.bicep
Description : Crée une passerelle VPN pour connectivité hybride.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `vpnGatewayName` | string | - | Nom de la VPN Gateway |
| `location` | string | - | Région Azure |
| `gatewayType` | string | `Vpn` | Type de gateway |
| `vpnType` | string | `RouteBased` | Type VPN |
| `gatewaySku` | string | `VpnGw1` | SKU du Gateway |
| `vpnGatewayGeneration` | string | `Generation1` | Génération |
| `subnetId` | string | - | ID du subnet GatewaySubnet |
| `publicIpAddressId` | string | - | ID de l'adresse IP publique |
| `publicIpAddressId2` | string | `''` | IP publique secondaire (active-active) |
| `enableBgp` | bool | `false` | Active BGP |
| `bgpAsn` | int | `65515` | Numéro ASN BGP |
| `activeActive` | bool | `false` | Mode active-active |
| `p2sConfiguration` | object | `{}` | Configuration point-à-site |
| `enableDiagnostics` | bool | `true` | Active les diagnostics |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `vpnGatewayId` | string | ID de la VPN Gateway |
| `vpnGatewayName` | string | Nom de la VPN Gateway |
| `bgpSettings` | object | Paramètres BGP (si activé) |
| `publicIpAddress` | string | Adresse IP publique |

Ressources : `Microsoft.Network/virtualNetworkGateways`, `Microsoft.Insights/diagnosticSettings`

Dépendances : dépend d'une adresse IP publique et du subnet GatewaySubnet.

### azure_bastion.bicep
Description : Déploie Azure Bastion pour accès RDP/SSH sécurisé.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `bastionName` | string | - | Nom du Bastion |
| `location` | string | - | Région Azure |
| `sku` | string | `Standard` | SKU (Basic ou Standard) |
| `subnetId` | string | - | ID du subnet AzureBastionSubnet |
| `publicIpAddressId` | string | - | ID de l'adresse IP publique |
| `enableIpConnect` | bool | `false` | Active IP Connect (Standard) |
| `enableShareableLink` | bool | `false` | Active lien partageable (Standard) |
| `enableTunneling` | bool | `false` | Active tunneling (Standard) |
| `enableFileCopy` | bool | `false` | Active copie de fichiers (Standard) |
| `scaleUnits` | int | `2` | Unités d'échelle (2-50, Standard) |
| `enableDiagnostics` | bool | `true` | Active les diagnostics |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `bastionId` | string | ID du Bastion |
| `bastionName` | string | Nom du Bastion |
| `dnsName` | string | Nom DNS du Bastion |

Ressources : `Microsoft.Network/bastionHosts`, `Microsoft.Insights/diagnosticSettings`

Dépendances : dépend d'une adresse IP publique et du subnet AzureBastionSubnet.

### virtual_network_peering.bicep
Description : Établit le peering entre deux VNets pour topologie Hub-Spoke.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `localVnetName` | string | - | Nom du VNet local |
| `remoteVnetId` | string | - | ID du VNet distant |
| `peeringName` | string | `''` | Nom du peering |
| `allowVirtualNetworkAccess` | bool | `true` | Autorise accès VNet |
| `allowForwardedTraffic` | bool | `true` | Autorise trafic transmis |
| `allowGatewayTransit` | bool | `false` | Autorise transit gateway |
| `useRemoteGateways` | bool | `false` | Utilise gateways distants |

| Output | Type | Description |
|---|---|---|
| `peeringId` | string | ID du peering |
| `peeringName` | string | Nom du peering |
| `peeringState` | string | État du peering |

Ressources : `Microsoft.Network/virtualNetworks/virtualNetworkPeerings`

Dépendances : dépend des deux VNets (local et distant).

### route_table.bicep
Description : Crée une table de routage avec routes personnalisées.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `routeTableName` | string | - | Nom de la table de routage |
| `location` | string | - | Région Azure |
| `disableBgpRoutePropagation` | bool | - | Désactive propagation BGP |
| `routes` | array | `[]` | Routes à créer |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `routeTableId` | string | ID de la table de routage |
| `routeTableName` | string | Nom de la table de routage |
| `routes` | array | Routes définies |

Ressources : `Microsoft.Network/routeTables`

Dépendances : aucune directe.

### nat_gateway.bicep
Description : Crée un NAT Gateway pour sortie internet.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `natGatewayName` | string | - | Nom du NAT Gateway |
| `location` | string | - | Région Azure |
| `publicIpAddressIds` | array | `[]` | IDs des adresses IP publiques |
| `publicIpPrefixIds` | array | `[]` | IDs des préfixes IP publics |
| `idleTimeoutInMinutes` | int | `4` | Timeout d'inactivité (4-120) |
| `zones` | array | `[]` | Zone de disponibilité |
| `enableDiagnostics` | bool | `true` | Active les diagnostics |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `natGatewayId` | string | ID du NAT Gateway |
| `natGatewayName` | string | Nom du NAT Gateway |

Ressources : `Microsoft.Network/natGateways`, `Microsoft.Insights/diagnosticSettings`

Dépendances : dépend d'une ou plusieurs adresses IP publiques.

### azure_load_balancer.bicep
Description : Crée un Load Balancer (Layer 4) public ou interne.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `loadBalancerName` | string | - | Nom du Load Balancer |
| `location` | string | - | Région Azure |
| `sku` | string | `Standard` | SKU (Basic, Standard, Gateway) |
| `type` | string | `Public` | Type (Public ou Internal) |
| `publicIpAddressId` | string | `''` | ID de l'IP publique (LB public) |
| `subnetId` | string | `''` | ID du subnet (LB interne) |
| `privateIpAddress` | string | `''` | IP privée (LB interne) |
| `frontendIpConfigurations` | array | `[]` | Configurations frontend IP |
| `backendAddressPools` | array | `[]` | Pools d'adresses backend |
| `loadBalancingRules` | array | `[]` | Règles de load balancing |
| `probes` | array | `[]` | Health probes |
| `inboundNatRules` | array | `[]` | Règles NAT entrantes |
| `outboundRules` | array | `[]` | Règles sortantes |
| `enableDiagnostics` | bool | `true` | Active les diagnostics |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `loadBalancerId` | string | ID du Load Balancer |
| `loadBalancerName` | string | Nom du Load Balancer |
| `frontendIpConfigurationIds` | array | IDs des configs frontend |
| `backendAddressPoolIds` | array | IDs des pools backend |

Ressources : `Microsoft.Network/loadBalancers`, `Microsoft.Insights/diagnosticSettings`

Dépendances : dépend d'une adresse IP publique (si public) ou d'un subnet (si interne).

### application_gateway.bicep
Description : Crée un Application Gateway (Layer 7) avec WAF optionnel.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `applicationGatewayName` | string | - | Nom du Application Gateway |
| `location` | string | - | Région Azure |
| `skuName` | string | `Standard_v2` | SKU (Standard_v2 ou WAF_v2) |
| `tier` | string | `Standard_v2` | Tier |
| `capacity` | int | `2` | Capacité (si pas autoscaling) |
| `enableAutoscaling` | bool | `true` | Active autoscaling |
| `minCapacity` | int | `2` | Capacité minimale |
| `maxCapacity` | int | `10` | Capacité maximale |
| `subnetId` | string | - | ID du subnet |
| `publicIpAddressId` | string | - | ID de l'IP publique |
| `backendAddressPools` | array | - | Pools d'adresses backend |
| `backendHttpSettingsCollection` | array | - | Paramètres HTTP backend |
| `httpListeners` | array | - | Écouteurs HTTP |
| `requestRoutingRules` | array | - | Règles de routage |
| `frontendPorts` | array | `[80, 443]` | Ports frontend |
| `sslCertificates` | array | `[]` | Certificats SSL |
| `wafConfiguration` | object | `{}` | Configuration WAF (WAF_v2) |
| `zones` | array | `[]` | Zones de disponibilité |
| `enableDiagnostics` | bool | `true` | Active les diagnostics |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `applicationGatewayId` | string | ID du Application Gateway |
| `applicationGatewayName` | string | Nom du Application Gateway |
| `backendAddressPoolIds` | array | IDs des pools backend |

Ressources : `Microsoft.Network/applicationGateways`, `Microsoft.Insights/diagnosticSettings`

Dépendances : dépend d'une adresse IP publique et d'un subnet.

### private_dns_zone.bicep
Description : Crée une zone DNS privée pour Private Endpoints.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `privateDnsZoneName` | string | - | Nom de la zone DNS (ex: privatelink.blob.core.windows.net) |
| `vnetLinksVnetIds` | array | `[]` | IDs des VNets à lier |
| `enableAutoRegistration` | bool | `false` | Active enregistrement auto VMs |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `privateDnsZoneId` | string | ID de la zone DNS |
| `privateDnsZoneName` | string | Nom de la zone DNS |
| `vnetLinkIds` | array | IDs des liens VNet |

Ressources : `Microsoft.Network/privateDnsZones`, `Microsoft.Network/privateDnsZones/virtualNetworkLinks`

Dépendances : aucune directe (VNets liés optionnellement).

### network_watcher_flowlogs.bicep
Description : Configure les Flow Logs NSG via Network Watcher.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `networkWatcherName` | string | - | Nom du Network Watcher |
| `nsgId` | string | - | ID du NSG |
| `flowLogsStorageAccountId` | string | - | ID du compte de stockage |
| `location` | string | - | Région Azure |
| `flowLogsRetentionDays` | int | - | Rétention des logs (jours) |
| `logAnalyticsWorkspaceId` | string | - | ID du Log Analytics |
| `flowLogName` | string | - | Nom du flow log |
| `tags` | object | - | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| (aucun output explicite) | - | Flow logs configurés via Network Watcher |

Ressources : `Microsoft.Network/networkWatchers/flowLogs`

Dépendances : dépend d'un Network Watcher existant et d'un compte de stockage.

### ddos_protection.bicep
Description : Crée un plan de protection DDoS Network.

| Input | Type | Par défaut | Description |
|---|---|---|---|
| `ddosProtectionPlanName` | string | - | Nom du plan DDoS |
| `location` | string | - | Région Azure |
| `tags` | object | `{}` | Tags à appliquer |

| Output | Type | Description |
|---|---|---|
| `ddosProtectionPlanId` | string | ID du plan DDoS |
| `ddosProtectionPlanName` | string | Nom du plan DDoS |

Ressources : `Microsoft.Network/ddosProtectionPlans`

Dépendances : aucune directe (à associer aux VNets).

---

## Bonnes pratiques spécifiques aux modules

- Utiliser des noms et tags standardisés conformément à la stratégie de nommage de l'entreprise.
- Fournir des paramètres via `.bicepparam` par environnement pour éviter les secrets en clair.
- Activer les diagnostic settings et les flow logs pour tous les NSGs du hub network.
- Associer les route tables aux subnets spoke pour diriger le trafic via le Firewall hub.
- Utiliser des zones de disponibilité pour le Firewall et les gateways en production.
- Tester le peering et les règles de firewall avant de déployer des workloads.

## Exemple rapide — flux recommandé

1. Déployer un DDoS Protection Plan (optionnel, mais recommandé en production).
2. Créer le VNet hub avec subnets (Firewall, Gateway, Bastion).
3. Déployer les adresses IP publiques (Firewall, Gateway, Bastion).
4. Déployer le Firewall hub, Gateway, et Bastion.
5. Créer les VNets spoke avec subnets.
6. Établir le peering hub->spoke.
7. Créer les tables de routage pour diriger le trafic via le Firewall.
8. Configurer les NSGs et flow logs.
9. (Optionnel) Déployer Load Balancers ou Application Gateways selon les besoins workload.

---

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