# Configuration du VNet Peering entre VNet ExpressRoute et VNet GitHub

## Prérequis

- Droits suffisants sur les deux VNets (rôle Network Contributor minimum)
- Les espaces d'adressage IP des deux VNets ne doivent **pas se chevaucher**
- Le VNet existant doit avoir une passerelle ExpressRoute configurée

## Étape 1 : Vérifier les espaces d'adressage

### Via le portail Azure
1. Accédez au **portail Azure**
2. Recherchez votre **VNet existant** (celui avec ExpressRoute)
3. Dans le menu de gauche, cliquez sur **Address space**
4. Notez les plages d'adresses (ex: 10.0.0.0/16)
5. Répétez pour le **VNet GitHub**
6. **Vérifiez qu'il n'y a pas de chevauchement**

### Via Azure CLI
```bash
# VNet existant
az network vnet show --name VNet-Existant --resource-group RG-Existant --query addressSpace.addressPrefixes

# VNet GitHub
az network vnet show --name VNet-GitHub --resource-group RG-GitHub --query addressSpace.addressPrefixes
```

## Étape 2 : Créer le peering depuis le VNet existant vers le VNet GitHub

### Via le portail Azure
1. Accédez à votre **VNet existant** (celui avec ExpressRoute)
2. Dans le menu de gauche, sélectionnez **Peerings**
3. Cliquez sur **+ Add**
4. Configurez les paramètres suivants :

**Section "This virtual network":**
- **Peering link name**: `Peering-Existant-to-GitHub`
- **Traffic to remote virtual network**: `Allow (default)`
- **Traffic forwarded from remote virtual network**: `Allow (default)`
- **Virtual network gateway or Route Server**: **Cochez "Use this virtual network's gateway"**

**Section "Remote virtual network":**
- **Peering link name**: `Peering-GitHub-to-Existant`
- **Virtual network deployment model**: `Resource manager`
- **Subscription**: Sélectionnez l'abonnement du VNet GitHub
- **Virtual network**: Sélectionnez le **VNet-GitHub**
- **Traffic to remote virtual network**: `Allow (default)`
- **Traffic forwarded from remote virtual network**: `Allow (default)`
- **Virtual network gateway or Route Server**: **Cochez "Use the remote virtual network's gateway"**

5. Cliquez sur **Add**

### Via Azure CLI
```bash
# Créer le peering depuis le VNet existant
az network vnet peering create \
  --name Peering-Existant-to-GitHub \
  --resource-group RG-Existant \
  --vnet-name VNet-Existant \
  --remote-vnet /subscriptions/{subscription-id}/resourceGroups/RG-GitHub/providers/Microsoft.Network/virtualNetworks/VNet-GitHub \
  --allow-vnet-access \
  --allow-forwarded-traffic \
  --allow-gateway-transit
```

## Étape 3 : Créer le peering depuis le VNet GitHub vers le VNet existant

**Note**: Si vous avez créé le peering via le portail à l'étape 2, cette étape est automatiquement effectuée. Sinon, suivez ces instructions.

### Via le portail Azure
1. Accédez à votre **VNet GitHub**
2. Dans le menu de gauche, sélectionnez **Peerings**
3. Cliquez sur **+ Add**
4. Configurez les paramètres suivants :

**Section "This virtual network":**
- **Peering link name**: `Peering-GitHub-to-Existant`
- **Traffic to remote virtual network**: `Allow (default)`
- **Traffic forwarded from remote virtual network**: `Allow (default)`
- **Virtual network gateway or Route Server**: **Cochez "Use the remote virtual network's gateway"**

**Section "Remote virtual network":**
- **Peering link name**: `Peering-Existant-to-GitHub`
- **Virtual network**: Sélectionnez le **VNet-Existant**
- **Traffic to remote virtual network**: `Allow (default)`
- **Traffic forwarded from remote virtual network**: `Allow (default)`
- **Virtual network gateway or Route Server**: **Cochez "Use this virtual network's gateway"**

5. Cliquez sur **Add**

### Via Azure CLI
```bash
# Créer le peering depuis le VNet GitHub
az network vnet peering create \
  --name Peering-GitHub-to-Existant \
  --resource-group RG-GitHub \
  --vnet-name VNet-GitHub \
  --remote-vnet /subscriptions/{subscription-id}/resourceGroups/RG-Existant/providers/Microsoft.Network/virtualNetworks/VNet-Existant \
  --allow-vnet-access \
  --allow-forwarded-traffic \
  --use-remote-gateways
```

## Étape 4 : Vérifier le statut du peering

### Via le portail Azure
1. Accédez à chaque VNet
2. Allez dans **Peerings**
3. Vérifiez que le statut est **"Connected"** pour les deux peerings

### Via Azure CLI
```bash
# Vérifier le peering du VNet existant
az network vnet peering show \
  --name Peering-Existant-to-GitHub \
  --resource-group RG-Existant \
  --vnet-name VNet-Existant \
  --query peeringState

# Vérifier le peering du VNet GitHub
az network vnet peering show \
  --name Peering-GitHub-to-Existant \
  --resource-group RG-GitHub \
  --vnet-name VNet-GitHub \
  --query peeringState
```

Les deux commandes doivent retourner `"Connected"`

## Étape 5 : Modifier le NSG GitHub pour autoriser le trafic vers on-premise

Le NSG actuel du VNet GitHub (`actions_NSG`) contient uniquement des règles sortantes vers les services GitHub et Azure Storage. Il faut ajouter une règle pour permettre la communication avec votre réseau on-premise via ExpressRoute.

### Option A : Via le portail Azure

1. Accédez au **NSG** nommé `actions_NSG` (ou le nom que vous avez défini)
2. Dans le menu de gauche, cliquez sur **Outbound security rules**
3. Cliquez sur **+ Add**
4. Configurez la nouvelle règle :
   - **Source**: `VirtualNetwork` ou `Any`
   - **Source port ranges**: `*`
   - **Destination**: `VirtualNetwork` (pour autoriser le trafic vers le VNet existant et on-premise)
   - **Service**: `Custom`
   - **Destination port ranges**: `*` (ou spécifiez les ports nécessaires comme `443,3389,22,1433`)
   - **Protocol**: `Any`
   - **Action**: `Allow`
   - **Priority**: `190` (priorité plus haute que la règle existante à 200)
   - **Name**: `AllowOnPremiseOutbound`
   - **Description**: `Autoriser le trafic vers le réseau on-premise via ExpressRoute`
5. Cliquez sur **Add**

### Option B : Via Azure CLI

```bash
az network nsg rule create \
  --resource-group RG-GitHub \
  --nsg-name actions_NSG \
  --name AllowOnPremiseOutbound \
  --priority 190 \
  --direction Outbound \
  --source-address-prefixes VirtualNetwork \
  --source-port-ranges '*' \
  --destination-address-prefixes VirtualNetwork \
  --destination-port-ranges '*' \
  --access Allow \
  --protocol '*' \
  --description "Autoriser le trafic vers le réseau on-premise via ExpressRoute"
```

### Option C : Modifier le fichier Bicep

Si vous souhaitez mettre à jour votre déploiement Infrastructure as Code, ajoutez cette règle dans le tableau `securityRules` :

```bicep
{
  name: 'AllowOnPremiseOutbound'
  properties: {
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: 'VirtualNetwork'
    destinationAddressPrefix: 'VirtualNetwork'
    access: 'Allow'
    priority: 190
    direction: 'Outbound'
    destinationAddressPrefixes: []
  }
}
```

**Note importante** : Placez cette règle **avant** la règle `AllowVnetOutBoundOverwrite` dans le fichier pour respecter l'ordre de priorité.

### Configuration plus restrictive (recommandée)

Si vous connaissez les plages IP de votre réseau on-premise, vous pouvez être plus spécifique :

```bash
az network nsg rule create \
  --resource-group RG-GitHub \
  --nsg-name actions_NSG \
  --name AllowOnPremiseOutbound \
  --priority 190 \
  --direction Outbound \
  --source-address-prefixes VirtualNetwork \
  --source-port-ranges '*' \
  --destination-address-prefixes "10.x.x.x/16" "192.168.x.x/24" \
  --destination-port-ranges "443" "3389" "22" "1433" \
  --access Allow \
  --protocol 'Tcp' \
  --description "Autoriser le trafic vers le réseau on-premise (plages spécifiques)"
```

Remplacez les plages IP par celles de votre réseau on-premise.

## Étape 6 : Configurer les règles entrantes (si nécessaire)

Si votre réseau on-premise doit initier des connexions vers les GitHub Runners, ajoutez également une règle **Inbound** :

### Via le portail Azure
1. Dans le NSG `actions_NSG`, cliquez sur **Inbound security rules**
2. Cliquez sur **+ Add**
3. Configurez :
   - **Source**: Spécifiez les plages IP on-premise (ex: `10.0.0.0/16`)
   - **Destination**: `VirtualNetwork`
   - **Destination port ranges**: Ports nécessaires (ex: `22,3389`)
   - **Protocol**: `TCP`
   - **Action**: `Allow`
   - **Priority**: `100`
   - **Name**: `AllowOnPremiseInbound`

### Via Azure CLI
```bash
az network nsg rule create \
  --resource-group RG-GitHub \
  --nsg-name actions_NSG \
  --name AllowOnPremiseInbound \
  --priority 100 \
  --direction Inbound \
  --source-address-prefixes "10.0.0.0/16" \
  --destination-address-prefixes VirtualNetwork \
  --destination-port-ranges "22" "3389" \
  --access Allow \
  --protocol Tcp
```

## Étape 7 : Vérifier les tables de routage (si nécessaire)

Si vous utilisez des **User Defined Routes (UDR)** :
1. Accédez à **Route tables** dans le portail
2. Vérifiez qu'aucune route personnalisée ne bloque le trafic vers l'autre VNet
3. Les routes vers le réseau on-premise devraient être automatiquement propagées via ExpressRoute

## Étape 8 : Tester la connectivité

### Test depuis une VM dans le VNet GitHub

```bash
# Tester la connectivité vers une ressource on-premise
ping <ip-ressource-onpremise>

# Tester la résolution DNS (si configurée)
nslookup <nom-ressource-onpremise>

# Tester un port spécifique
Test-NetConnection -ComputerName <ip-ressource-onpremise> -Port 443
```

### Test depuis le réseau on-premise

```bash
# Tester la connectivité vers une VM dans le VNet GitHub
ping <ip-vm-github-vnet>
```

## Dépannage

### Le peering reste en état "Initiated"
- Vérifiez que le peering a été créé dans les deux sens
- Assurez-vous que les espaces d'adressage ne se chevauchent pas

### Le NSG bloque le trafic
- **Vérifiez l'ordre de priorité** : La nouvelle règle doit avoir une priorité plus basse (ex: 190) que les règles existantes (200+)
- **Vérifiez les règles appliquées** : Dans le portail, allez dans NSG > Effective security rules pour voir les règles actives
- **Testez avec NSG Flow Logs** : Activez les logs NSG pour diagnostiquer les blocages

```bash
# Voir les règles effectives sur une interface réseau
az network nic show-effective-nsg \
  --resource-group RG-GitHub \
  --name NIC-GitHub-Runner
```

### Erreur "Cannot use remote gateway"
- Vérifiez que la passerelle ExpressRoute existe bien dans le VNet existant
- Assurez-vous que l'option "Allow gateway transit" est activée sur le VNet avec la passerelle
- Vérifiez que vous n'avez pas déjà une passerelle dans le VNet GitHub

## Points importants à retenir

✅ **Allow gateway transit** doit être activé sur le VNet avec ExpressRoute  
✅ **Use remote gateways** doit être activé sur le VNet GitHub  
✅ Les espaces d'adressage ne doivent **jamais se chevaucher**  
✅ Le peering doit être **bidirectionnel** (créé dans les deux VNets)  
✅ Le VNet GitHub ne doit **pas avoir sa propre passerelle** VPN/ExpressRoute  
✅ **Le NSG GitHub doit autoriser le trafic sortant vers VirtualNetwork** (priorité < 200)  
✅ La règle NSG existante à priorité 200 limite le trafic VNet au port 443 uniquement - votre nouvelle règle doit avoir une priorité plus haute (190)

## Coûts

- Le peering VNet est facturé en fonction du volume de données transférées
- Tarification: données entrantes et sortantes entre VNets dans la même région
- Consultez la page de tarification Azure pour les détails actuels