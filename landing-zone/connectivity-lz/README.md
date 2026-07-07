# Connectivity Landing Zone - Orchestrateur réseau Hub and Spoke

> **Version** : 1.0.0  
> **Région supportée** : `canadacentral` (`cace`), `canadaeast` (`caea`)  
> **Mainteneur** : Angeles Banaka  
> **Dernière mise à jour** : Juillet 2026
----

## Contenu du dossier

Ce dossier contient l’orchestrateur Bicep de la landing zone de connectivité pour une topologie hub-spoke.

```text
connectivity-lz/
├── connectivity.bicep
├── connectivity.bicepparam
└── README.md
```

### Fichiers présents

- connectivity.bicep : template principal au scope subscription qui déploie le hub réseau.
- connectivity.bicepparam : fichier de paramètres d’exemple pour un déploiement sandbox.
- README.md : documentation du dossier.

> Le dossier ne contient pas de sous-répertoire local de modules. L’orchestrateur référence des modules partagés dans ../../modules/networking.

## Ce que déploie l’orchestrateur

Le template principal déploie les composants suivants :

- un VNet hub avec les sous-réseaux dédiés : GatewaySubnet, AzureFirewallSubnet, AzureBastionSubnet et snet-hub-management
- deux NSGs distincts : un NSG pour le subnet management et un NSG dédié au subnet Bastion
- des IP publiques pour le VPN Gateway, Azure Firewall et Azure Bastion
- Azure Firewall avec une route par défaut vers l’appliance
- une route table de gestion avec UDR
- un VPN Gateway optionnel
- Azure Bastion optionnel
- un plan DDoS optionnel

## Prérequis

Avant le déploiement, vérifier les points suivants :

- le resource group de connectivité existe déjà
- un workspace Log Analytics est disponible et son ID est fourni
- le principal de déploiement dispose des permissions réseau suffisantes sur le resource group cible
- les sous-réseaux réservés Azure sont configurés avec les tailles minimales attendues

## Déploiement

Depuis la racine du dépôt, exécuter les commandes suivantes :

```bash
# 1. Validation du déploiement
az deployment sub what-if \
  --name connectivity-lz-deploy \
  --location canadaeast \
  --template-file landing-zone/connectivity-lz/connectivity.bicep \
  --parameters landing-zone/connectivity-lz/connectivity.bicepparam

# 2. Déploiement
az deployment sub create \
  --name connectivity-lz-deploy \
  --location canadaeast \
  --template-file landing-zone/connectivity-lz/connectivity.bicep \
  --parameters landing-zone/connectivity-lz/connectivity.bicepparam

# 3. Récupération des outputs
az deployment sub show \
  --name connectivity-lz-deploy \
  --query properties.outputs
```

## Paramètres principaux

Le fichier de paramètres permet de piloter les éléments suivants :

- organizationName, environment et location
- connectivityResourceGroupName
- deployVpnGateway, deployAzureFirewall, deployBastion et deployDdosProtection
- vpnGatewaySku et vpnGatewayGeneration
- firewallSkuTier
- availabilityZones
- logAnalyticsWorkspaceId
- tags

## Notes de conception

- Cet élément est un orchestrateur de haut niveau ; il ne contient pas les définitions de modules locales.
- Les ressources réseau détaillées sont déployées via des modules partagés situés dans ../../modules/networking.
- La structure actuelle est volontairement simple afin de centraliser la logique de déploiement du hub dans un seul point d’entrée.

## Ressources utiles

- Hub-Spoke Network Topology
- Azure Firewall documentation
- Azure Bastion NSG requirements
- VPN Gateway planning
