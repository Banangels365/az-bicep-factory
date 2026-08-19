# Modules pour compte de stockage Azure

Ce dossier contient des modules Bicep pour déployer et configurer des comptes de stockage Azure. Ces modules permettent de créer des comptes de stockage avec des configurations personnalisées, y compris les types de comptes, les niveaux de performance, les règles de pare-feu, les points de terminaison privés, et plus encore. Ils sont conçus pour être réutilisables et adaptables à différents scénarios de stockage dans Azure.

## Modules disponibles

- `storage_account.bicep`: Module principal pour déployer un compte de stockage avec des configurations flexibles, incluant les types de comptes, les niveaux de performance, les règles de pare-feu, les private endpoints, et plus encore.
- `storage_blob_service.bicep`: Module pour déployer des services de blob dans un compte de stockage existant.
- `storage_blob_container.bicep`: Module pour déployer des conteneurs de blob dans un compte de stockage existant.
- `storage_blob_container_immutability_policy.bicep`: Module pour déployer des politiques d'immutabilité dans des conteneurs de blob existants.
- `storage_file_service.bicep`: Module pour déployer des services de fichiers dans un compte de stockage existant.
- `storage_file_share.bicep`: Module pour déployer des partages de fichiers dans un compte de stockage existant.
- `storage_queue_service.bicep`: Module pour déployer des services de file d'attente dans un compte de stockage existant.
- `storage_queue.bicep`: Module pour déployer des files d'attente dans un compte de stockage existant.
- `storage_table_service.bicep`: Module pour déployer des services de table dans un compte de stockage existant.
- `storage_table.bicep`: Module pour déployer des tables dans un compte de stockage existant.
- `types.bicep`: Module pour la gestion de l'assignation des rôles et des identités managées dans les comptes de stockage.

## Description du module storage_account

Le module `storage_account.bicep` permet de déployer un compte de stockage avec des configurations flexibles, incluant les types de comptes, les niveaux de performance, les règles de pare-feu, les private endpoints, et plus encore. Il prend en charge la configuration de différents paramètres pour le compte de stockage lui-même, ainsi que l'intégration avec d'autres services Azure pour une gestion complète du stockage. Le module retourne des informations clés sur le compte de stockage déployé, telles que son Resource ID, son nom, et son URI.

### Paramètres du module storage_account

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module storage_account

```bicep
module storageAccount './modules/storage/storage_account.bicep' = {
  name: 'stprod001'
  params: {
    name: 'stprod001'
    location: 'eastus'
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    enableHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    networkRules: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '10.0.0.0/16'
        }
      ]
    }
  }
}
```

### Description du module storage_blob_service

Le module `storage_blob_service.bicep` permet de déployer des services de blob dans un compte de stockage existant. Il prend en charge la configuration de différents paramètres pour le service de blob, ainsi que l'intégration avec d'autres services Azure pour une gestion complète du stockage de blobs. Le module retourne des informations clés sur le service de blob déployé, telles que son Resource ID, son nom, et le nom du compte de stockage parent.

### Paramètres du module storage_blob_service

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module storage_blob_service

```bicep
module blobService './modules/storage/storage_blob_service.bicep' = {
  name: 'blobService-prod-001'
  params: {
    storageAccountName: 'stprod001'
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    isVersioningEnabled: true
    isChangeFeedEnabled: true
    isContainerDeleteRetentionPolicyEnabled: true
    containerDeleteRetentionPolicyDays: 7
  }
}
```

### Description du module storage_blob_container

Le module `storage_blob_container.bicep` permet de déployer des conteneurs de blob dans un compte de stockage existant. Il prend en charge la configuration de différents paramètres pour les conteneurs de blob, ainsi que l'intégration avec d'autres services Azure pour une gestion complète du stockage de blobs. Le module retourne des informations clés sur les conteneurs de blob déployés, telles que leurs Resource IDs, leurs noms, et le nom du compte de stockage parent.

### Paramètres du module storage_blob_container

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module storage_blob_container

```bicep
module blobContainer './modules/storage/storage_blob_container.bicep' = [
  {
    name: 'blob-container-prod-001'
    params: {
      storageAccountName: 'stprod001'
      containerName: 'container001'
      publicAccess: 'None'
      metadata: {
        environment: 'production'
        department: 'finance'
      }
    }
  },
  {
    name: 'blob-container-prod-002'
    params: {
      storageAccountName: 'stprod001'
      containerName: 'container002'
      publicAccess: 'Blob'
      metadata: {
        environment: 'production'
        department: 'marketing'
      }
    }
  },
  {
    name: 'blob-container-prod-003'    
    params: {
      storageAccountName: 'stprod001'
      containerName: 'container003'
      publicAccess: 'Container'
      metadata: {
        environment: 'production'
        department: 'sales'
      }
    }
  }
]
```

### Description du module storage_blob_container_immutability_policy

Le module `storage_blob_container_immutability_policy.bicep` permet de déployer des politiques d'immutabilité dans des conteneurs de blob existants. Il prend en charge la configuration de différents paramètres pour les politiques d'immutabilité, ainsi que l'intégration avec d'autres services Azure pour une gestion complète du stockage de blobs. Le module retourne des informations clés sur les politiques d'immutabilité déployées, telles que leurs Resource IDs, leurs noms, et le nom du conteneur de blob parent.

### Paramètres du module storage_blob_container_immutability_policy

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module storage_blob_container_immutability_policy

```bicep
module immutabilityPolicy './modules/storage/storage_blob_container_immutability_policy.bicep' = [
  {
    name: 'immutability-policy-prod-001'
    params: {
      storageAccountName: 'stprod001'
      containerName: 'container001'
      immutabilityPeriodSinceCreationInDays: 30
    }
  },
  {
    name: 'immutability-policy-prod-002'
    params: {
      storageAccountName: 'stprod001'
      containerName: 'container002'
      immutabilityPeriodSinceCreationInDays: 60
    }
  },
  {
    name: 'immutability-policy-prod-003'    
    params: {
      storageAccountName: 'stprod001'
      containerName: 'container003'
      immutabilityPeriodSinceCreationInDays: 90
    }
  }
]
```

### Description du module storage_file_service

Le module `storage_file_service.bicep` permet de déployer des services de fichiers dans un compte de stockage existant. Il prend en charge la configuration de différents paramètres pour le service de fichiers, ainsi que l'intégration avec d'autres services Azure pour une gestion complète du stockage de fichiers. Le module retourne des informations clés sur le service de fichiers déployé, telles que son Resource ID, son nom, et le nom du compte de stockage parent.

### Paramètres du module storage_file_service

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module storage_file_service

```bicep
module fileService './modules/storage/storage_file_service.bicep' = {
  name: 'fileService-prod-001'
  params: {
    storageAccountName: 'stprod001'
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    isVersioningEnabled: true
  }
}
```

### Description du module storage_file_share

Le module `storage_file_share.bicep` permet de déployer des partages de fichiers dans un compte de stockage existant. Il prend en charge la configuration de différents paramètres pour les partages de fichiers, ainsi que l'intégration avec d'autres services Azure pour une gestion complète du stockage de fichiers. Le module retourne des informations clés sur les partages de fichiers déployés, telles que leurs Resource IDs, leurs noms, et le nom du compte de stockage parent.

### Paramètres du module storage_file_share

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module storage_file_share

```bicep
module fileShare './modules/storage/storage_file_share.bicep' = [
  {
    name: 'file-share-prod-001'
    params: {
      storageAccountName: 'stprod001'
      shareName: 'share001'
      metadata: {
        environment: 'production'
        department: 'finance'
      }
    }
  },
  {
    name: 'file-share-prod-002'
    params: {
      storageAccountName: 'stprod001'
      shareName: 'share002'
      metadata: {
        environment: 'production'
        department: 'marketing'
      }
    }
  },
  {
    name: 'file-share-prod-003'    
    params: {
      storageAccountName: 'stprod001'
      shareName: 'share003'
      metadata: {
        environment: 'production'
        department: 'sales'
      }
    }
  }
]
```

### Description du module storage_queue_service

Le module `storage_queue_service.bicep` permet de déployer des services de file d'attente dans un compte de stockage existant. Il prend en charge la configuration de différents paramètres pour le service de file d'attente, ainsi que l'intégration avec d'autres services Azure pour une gestion complète du stockage de files d'attente. Le module retourne des informations clés sur le service de file d'attente déployé, telles que son Resource ID, son nom, et le nom du compte de stockage parent.

### Paramètres du module storage_queue_service

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module storage_queue_service

```bicep
module queueService './modules/storage/storage_queue_service.bicep' = {
  name: 'queueService-prod-001'
  params: {
    storageAccountName: 'stprod001'
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    isVersioningEnabled: true
  }
}
```

### Description du module storage_queue

Le module `storage_queue.bicep` permet de déployer des files d'attente dans un compte de stockage existant. Il prend en charge la configuration de différents paramètres pour les files d'attente, ainsi que l'intégration avec d'autres services Azure pour une gestion complète du stockage de files d'attente. Le module retourne des informations clés sur les files d'attente déployées, telles que leurs Resource IDs, leurs noms, et le nom du compte de stockage parent.

### Paramètres du module storage_queue

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module storage_queue

```bicep
module queue './modules/storage/storage_queue.bicep' = [
  {
    name: 'queue-prod-001'
    params: {
      storageAccountName: 'stprod001'
      queueName: 'queue001'
      metadata: {
        environment: 'production'
        department: 'finance'
      }
    }
  },
  {
    name: 'queue-prod-002'
    params: {
      storageAccountName: 'stprod001'
      queueName: 'queue002'
      metadata: {
        environment: 'production'
        department: 'marketing'
      }
    }
  },
  {
    name: 'queue-prod-003'    
    params: {
      storageAccountName: 'stprod001'
      queueName: 'queue003'
      metadata: {
        environment: 'production'
        department: 'sales'
      }
    }
  }
]
```

### Description du module storage_table_service

Le module `storage_table_service.bicep` permet de déployer des services de table dans un compte de stockage existant. Il prend en charge la configuration de différents paramètres pour le service de table, ainsi que l'intégration avec d'autres services Azure pour une gestion complète du stockage de tables. Le module retourne des informations clés sur le service de table déployé, telles que son Resource ID, son nom, et le nom du compte de stockage parent.

### Paramètres du module storage_table_service

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module storage_table_service

```bicep
module tableService './modules/storage/storage_table_service.bicep' = {
  name: 'tableService-prod-001'
  params: {
    storageAccountName: 'stprod001'
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    isVersioningEnabled: true
  }
}
```

### Description du module storage_table

Le module `storage_table.bicep` permet de déployer des tables dans un compte de stockage existant. Il prend en charge la configuration de différents paramètres pour les tables, ainsi que l'intégration avec d'autres services Azure pour une gestion complète du stockage de tables. Le module retourne des informations clés sur les tables déployées, telles que leurs Resource IDs, leurs noms, et le nom du compte de stockage parent.

### Paramètres du module storage_table

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module storage_table

```bicep
module table './modules/storage/storage_table.bicep' = [
  {
    name: 'table-prod-001'
    params: {
      storageAccountName: 'stprod001'
      tableName: 'table001'
      metadata: {
        environment: 'production'
        department: 'finance'
      }
    }
  },
  {
    name: 'table-prod-002'
    params: {
      storageAccountName: 'stprod001'
      tableName: 'table002'
      metadata: {
        environment: 'production'
        department: 'marketing'
      }
    }
  },
  {
    name: 'table-prod-003'    
    params: {
      storageAccountName: 'stprod001'
      tableName: 'table003'
      metadata: {
        environment: 'production'
        department: 'sales'
      }
    }
    }
]
```
