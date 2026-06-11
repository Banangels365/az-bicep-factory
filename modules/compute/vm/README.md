# Modules pour Machines Virtuelles Azure
Ce dossier contient des modules Bicep pour déployer et configurer des machines virtuelles Azure avec une grande flexibilité. Les modules inclus permettent de gérer les configurations de base des machines virtuelles, les disques, les interfaces réseau, les extensions, et les options de backup. Chaque module est conçu pour être réutilisable et configurable, avec des paramètres adaptés aux besoins spécifiques de chaque déploiement de machine virtuelle.

## Modules disponibles
- `virtual_machine_core.bicep` : Module principal pour déployer une machine virtuelle Azure avec une configuration de base.
- `virtual_machine_disk.bicep` : Module pour créer un disque managé Azure qui peut être attaché à une machine virtuelle.
- `virtual_machine_nic_configuration.bicep` : Module pour déployer une interface réseau (NIC) pour une machine virtuelle Azure, avec des options de configuration avancées.
- `virtual_machine_extension.bicep` : Module pour déployer une extension sur une machine virtuelle existante, avec des paramètres spécifiques à l'extension.
- `virtual_machine_backup.bicep` : Module pour déployer une configuration de backup pour une machine virtuelle Azure, en associant la VM à une policy de backup définie dans un Recovery Services Vault.  
- `virtual_machine.bicep` : Module tout-en-un pour déployer une machine virtuelle Azure avec une configuration complète, intégrant les fonctionnalités des modules précédents.

## Description du module Virtual Machine Core
Le module `virtual_machine_core.bicep` permet de déployer une machine virtuelle Azure avec une configuration flexible pour les systèmes d'exploitation Linux et Windows. Il prend en charge la gestion des disques, des identités managées, des interfaces réseau, et d'autres paramètres essentiels. Le module intègre également les meilleures pratiques pour la configuration des machines virtuelles, telles que l'activation des diagnostics et la configuration de la mise à jour automatique des correctifs. 

### Paramètres du module Virtual Machine Core

#### Inputs

| Paramètre | Type | Défaut | Obligatoire | Description |
|---|---|---|---|---|
| `name` | string | - | Oui | Nom de la machine virtuelle |
| `computerName` | string | - | Oui | Nom de l'ordinateur dans l'OS. |
| `location` | string | - | Oui | Région Azure pour le déploiement |  
| `resourceGroupName` | string | - | Oui | Nom du groupe de ressources |
| `vmSize` | string | 'Standard_DS1_v2' | Non | Taille de la machine virtuelle |
| `adminUsername` | string | - | Oui | Nom d'utilisateur administrateur pour la machine virtuelle |
| `adminPassword` | string | - | Oui | Mot de passe administrateur pour la machine virtuelle |
| `osType` | string | 'Windows' | Non | Type de système d'exploitation (Windows ou Linux) |
| `diagnosticsStorageAccountId` | string | - | Non | Resource ID d'un compte de stockage pour les diagnostics de démarrage |
| `patchingMode` | string | 'AutomaticByPlatform' | Non | Mode de mise à jour des correctifs (AutomaticByPlatform, AutomaticByOS, Manual) | 


#### Outputs

| Output | Type | Description |
|---|---|---|
| `vmId` | string | Resource ID de la machine virtuelle créée |
| `vmName` | string | Nom de la machine virtuelle créée |       
| `principalId` | string | ID de l'identité managée de la machine virtuelle créée |
| `resourceGroupName` | string | Nom du groupe de ressources de la machine virtuelle créée |

#### Ressources créées
-


### Exemple d'utilisation du module Virtual Machine Core
```bicep
module virtualMachineCore './modules/vm/virtual_machine_core.bicep' = {
    name: 'vm-core-prod-001'
    params: {
        name: 'vm-core-prod-001'
        computerName: 'vmcoreprod001'
        location: 'canadaeast'
        resourceGroupName: 'rg-prod-001'
        vmSize: 'Standard_DS2_v2'
        adminUsername: 'adminuser'
        adminPassword: 'P@ssw0rd1234!'
        osType: 'Windows'
        diagnosticsStorageAccountId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}'
        patchingMode: 'AutomaticByPlatform'
    }
}

```

## Description du module Virtual Machine Disk
Le module `virtual_machine_disk.bicep` permet de créer un disque managé Azure qui peut être attaché à une machine virtuelle. Il prend en charge la configuration des paramètres du disque, tels que la taille, le type de stockage, et les options de performance. Le module retourne des informations clés sur le disque créé, telles que son Resource ID et son nom.

### Paramètres du module Virtual Machine Disk

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Virtual Machine Disk
```bicep
module virtualMachineDisk './modules/vm/virtual_machine_disk.bicep' = {
  name: 'vm-disk-prod-001'
  params: {
    name: 'vm-disk-prod-001'
    location: 'canadaeast'
    resourceGroupName: 'rg-prod-001'
    diskSizeGB: 128
    storageAccountType: 'Premium_LRS'
  }
}
```

## Description du module Virtual Machine NIC Configuration
Le module `virtual_machine_nic_configuration.bicep` permet de déployer une interface réseau (NIC) pour une machine virtuelle Azure, avec une configuration flexible pour les adresses IP, les paramètres de sécurité, et les diagnostics. Il prend en charge la création d'une adresse IP publique associée à la NIC, ainsi que l'association à un groupe de sécurité réseau (NSG) et la configuration de paramètres avancés tels que l'accélération réseau et le transfert IP.

### Paramètres du module Virtual Machine NIC Configuration

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Virtual Machine NIC Configuration
```bicep
module virtualMachineNicConfig './modules/vm/virtual_machine_nic_configuration.bicep' = {
  name: 'vm-nic-config-prod-001'
  params: {
    name: 'vm-nic-config-prod-001'
    location: 'canadaeast'
    resourceGroupName: 'rg-prod-001'
    subnetId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}'
    publicIpAddressId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpName}'
    networkSecurityGroupId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{nsgName}'
    enableAcceleratedNetworking: true
    enableIpForwarding: false
  }
}
```

## Description du module Virtual Machine Extension
Le module `virtual_machine_extension.bicep` permet de déployer une extension sur une machine virtuelle existante. Il prend en charge la configuration des paramètres de l'extension, tels que le type d'extension, les paramètres spécifiques à l'extension, et les options de gestion des extensions. Le module retourne des informations clés sur l'extension déployée, telles que son Resource ID et son nom. 

### Paramètres du module Virtual Machine Extension

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Virtual Machine Extension
```bicep
module virtualMachineExtension './modules/vm/virtual_machine_extension.bicep' = {
  name: 'vm-extension-prod-001'
  params: {
    name: 'vm-extension-prod-001'
    location: 'canadaeast'
    resourceGroupName: 'rg-prod-001'
    vmName: 'vm-core-prod-001'
    extensionType: 'CustomScriptExtension'
    publisher: 'Microsoft.Compute'
    typeHandlerVersion: '1.10'
    settings: {
      fileUris: [
        'https://{storageAccountName}.blob.core.windows.net/scripts/script.ps1'
      ]
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File script.ps1'
    }
}
```

## Description du module Virtual Machine Backup
Le module `virtual_machine_backup.bicep` permet de déployer une configuration de backup pour une machine virtuelle Azure, en associant la VM à une policy de backup définie dans un Recovery Services Vault. Il prend en charge la création d'un protected item dans le vault, qui représente la VM à protéger, et permet de spécifier les paramètres essentiels tels que le type de protected item, l'ID de la policy de backup, et l'ID de la ressource source à protéger. Le module retourne des informations clés sur la configuration de backup déployée, telles que son Resource ID et son nom.

### Paramètres du module Virtual Machine Backup

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Virtual Machine Backup
```bicep
module virtualMachineBackup './modules/vm/virtual_machine_backup.bicep' = {
  name: 'vm-backup-prod-001'
  params: {
    name: 'vm-backup-prod-001'
    location: 'canadaeast'
    resourceGroupName: 'rg-prod-001'
    recoveryServicesVaultId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}'
    backupPolicyId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}'
    sourceResourceId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}'
    protectedItemType: 'AzureIaaSVM'
  }
}
```
### Description du module Virtual Machine
Le module `virtual_machine.bicep` permet de déployer une machine virtuelle Azure avec une configuration complète, en intégrant les fonctionnalités des modules précédents pour les disques, les interfaces réseau, les extensions, et les options de backup. Il offre une solution tout-en-un pour le déploiement de machines virtuelles Azure, avec des paramètres flexibles pour répondre aux besoins spécifiques de chaque scénario de déploiement. Le module retourne des informations clés sur la machine virtuelle créée, telles que son Resource ID, son nom, et l'ID de son identité managée.

### Paramètres du module Virtual Machine

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Virtual Machine
```bicep
module virtualMachine './modules/vm/virtual_machine.bicep' = {
  name: 'vm-prod-001'
  params: {
    name: 'vm-prod-001'
    computerName: 'vmprod001'
    location: 'canadaeast'
    resourceGroupName: 'rg-prod-001'
    vmSize: 'Standard_DS2_v2'
    adminUsername: 'adminuser'
    adminPassword: 'P@ssw0rd1234!'
    osType: 'Windows'
    diagnosticsStorageAccountId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}'
    patchingMode: 'AutomaticByPlatform'
    diskSizeGB: 128
    storageAccountType: 'Premium_LRS'
    subnetId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}'
    publicIpAddressId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/{publicIpName}'
    networkSecurityGroupId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/{nsgName}'
    enableAcceleratedNetworking: true
    enableIpForwarding: false
    extensionType: 'CustomScriptExtension'
    publisher: 'Microsoft.Compute'
    typeHandlerVersion: '1.10'
    settings: {
      fileUris: [
        'https://{storageAccountName}.blob.core.windows.net/scripts/script.ps1'
      ]
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File script.ps1'
    }
    recoveryServicesVaultId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}'
    backupPolicyId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.RecoveryServices/vaults/{vaultName}/backupPolicies/{policyName}'
  }
}
```
