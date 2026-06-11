# Modules pour Key Vault
Ce dossier contient des modules Bicep pour déployer et configurer Azure Key Vault. Ces modules permettent de créer des Key Vaults avec des configurations personnalisées, y compris les politiques d'accès, les secrets, les clés, les points de terminaison privés, et plus encore. Ils sont conçus pour être réutilisables et adaptables à différents scénarios de sécurité et de gestion des clés dans Azure.

## Modules disponibles
- `key_vault_key.bicep`: Module pour déployer des clés dans un Key Vault.
- `key_vault_secret.bicep`: Module pour déployer des secrets dans un Key Vault.
- `key_vault_access_policy.bicep`: Module pour configurer les politiques d'accès dans un Key Vault. 
- `key_vault.bicep`: Module principal pour déployer un Key Vault avec des configurations flexibles, incluant les access policies, secrets, clés, private endpoints, et plus encore.

## Description du module Key Vault Key
Le module `key_vault_key.bicep` permet de déployer des clés dans un Key Vault existant. Il prend en charge la configuration de différents types de clés, de tailles, et d'opérations autorisées. Le module retourne des informations clés sur la clé déployée, telles que son Resource ID, son nom, et le nom du Key Vault parent.  

### Paramètres du module Key Vault Key

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Key Vault Key
```bicep
module keyVaultKeys './modules/key-vault/key_vault_key.bicep' = [
  {
    name: 'key-prod-001'
    params: {
      keyVaultName: 'kv-prod-001'
      name: 'key-prod-001'
      keyType: 'RSA'
      keySize: 2048
      keyOperations: ['encrypt', 'decrypt', 'sign', 'verify']
    }
    },  
    {
    name: 'key-prod-002'
    params: {
      keyVaultName: 'kv-prod-001'
      name: 'key-prod-002'
      keyType: 'RSA'
      keySize: 2048
      keyOperations: ['encrypt', 'decrypt', 'sign', 'verify']   
    }
    }
    {
    name: 'key-prod-003'    
    params: {
      keyVaultName: 'kv-prod-001'
      name: 'key-prod-003'
      keyType: 'RSA'
      keySize: 2048
      keyOperations: ['encrypt', 'decrypt', 'sign', 'verify']   
    }
    }
]
```

### Description du module Key Vault Secret
Le module `key_vault_secret.bicep` permet de déployer des secrets dans un Key Vault existant. Il prend en charge la configuration de différents types de secrets, de valeurs, et de content types. Le module retourne des informations clés sur le secret déployé, telles que son Resource ID, son nom, et le nom du Key Vault parent.

### Paramètres du module Key Vault Secret

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Key Vault Secret
```bicep
module keyVaultSecrets './modules/key-vault/key_vault_secret.bicep' = [
  {
    name: 'secret-prod-001'
    params: {
      keyVaultName: 'kv-prod-001'
      name: 'secret-prod-001'
      value: 'mySecretValue'
      contentType: 'text/plain'
    }
  },
  {
    name: 'secret-prod-002'
    params: {
      keyVaultName: 'kv-prod-001'
      name: 'secret-prod-002'
      value: 'myOtherSecretValue'
      contentType: 'text/plain'    
    }
  },
  {
    name: 'secret-prod-003'    
    params: {
      keyVaultName: 'kv-prod-001'
      name: 'secret-prod-003'
      value: 'yetAnotherSecretValue'
      contentType: 'text/plain'    
    }
  }
]
```

### Description du module Key Vault Access Policy
Le module `key_vault_access_policy.bicep` permet de configurer les politiques d'accès dans un Key Vault existant. Il prend en charge la configuration de différentes permissions pour les clés, les secrets, et les certificats, ainsi que l'association de ces permissions à des identités spécifiques. Le module retourne des informations clés sur la politique d'accès configurée, telles que son Resource ID, son nom, et le nom du Key Vault parent.

### Paramètres du module Key Vault Access Policy

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Key Vault Access Policy
```bicep
module keyVaultAccessPolicies './modules/key-vault/key_vault_access_policy.bicep' = [
  {
    name: 'access-policy-prod-001'
    params: {
      keyVaultName: 'kv-prod-001'
      tenantId: '00000000-0000-0000-0000-000000000000'
      objectId: '11111111-1111-1111-1111-111111111111'
      permissions: {
        keys: ['get', 'list', 'create', 'delete']
        secrets: ['get', 'list', 'set', 'delete']
        certificates: ['get', 'list', 'create', 'delete']
      }
    }
  },
  {
    name: 'access-policy-prod-002'
    params: {
      keyVaultName: 'kv-prod-001'
      tenantId: '00000000-0000-0000-0000-000000000000'
      objectId: '22222222-2222-2222-2222-222222222222'
      permissions: {
        keys: ['get', 'list']
        secrets: ['get', 'list']
        certificates: ['get', 'list']
      }    
    }
  },
  {
    name: 'access-policy-prod-003'    
    params: {
      keyVaultName: 'kv-prod-001'
      tenantId: '00000000-0000-0000-0000-000000000000'
      objectId: '33333333-3333-3333-3333-333333333333'
      permissions: {
        keys: ['get']
        secrets: ['get']
        certificates: ['get']
      }    
    }
    }
]
```

### Description du module Key Vault
Le module `key_vault.bicep` permet de déployer un Key Vault avec des configurations flexibles, incluant les access policies, secrets, clés, private endpoints, et plus encore. Il prend en charge la configuration de différents paramètres pour le Key Vault lui-même, ainsi que l'intégration avec d'autres services Azure pour une gestion complète des clés et des secrets. Le module retourne des informations clés sur le Key Vault déployé, telles que son Resource ID, son nom, et son URI.

#### Paramètres du module Key Vault

#### Inputs 

#### Outputs    

#### Ressources créées

### Exemple d'utilisation complète du module Key Vault avec les modules enfants
```bicep
module keyVault './modules/key-vault/key_vault.bicep' = {
    name: 'kv-prod-001'
    params: {
        name: 'kv-prod-001'
        location: 'canadaeast'
        resourceGroupName: 'rg-prod-001'
        tenantId: '00000000-0000-0000-0000-000000000000'
        accessPolicies: [
        {
            tenantId: '00000000-0000-0000-0000-000000000000'
            objectId: '11111111-1111-1111-1111-111111111111'
            permissions: {
            keys: ['get', 'list', 'create', 'delete']
            secrets: ['get', 'list', 'set', 'delete']
            certificates: ['get', 'list', 'create', 'delete']
            }
        },
        {
            tenantId: '00000000-0000-0000-0000-000000000000'
            objectId: '22222222-2222-2222-2222-222222222222'
            permissions: {
            keys: ['get', 'list']
            secrets: ['get', 'list']
            certificates: ['get', 'list']
            }    
        },
        {
            tenantId: '00000000-0000-0000-0000-000000000000'
            objectId: '33333333-3333-3333-3333-333333333333'
            permissions: {
            keys: ['get']
            secrets: ['get']
            certificates: ['get']
            }    
        }
        ]   
        }
        keyVaultSecrets: [
          {
            name: 'secret-prod-001' 
            value: 'mySecretValue'
            contentType: 'text/plain'
            },
            {
            name: 'secret-prod-002'
            value: 'myOtherSecretValue' 
            contentType: 'text/plain'    
            },
            {
            name: 'secret-prod-003'    
            value: 'yetAnotherSecretValue'  
            contentType: 'text/plain'    
            }
        ]
        keyVaultKeys: [
          {
            name: 'key-prod-001'
            keyType: 'RSA'
            keySize: 2048
            keyOperations: ['encrypt', 'decrypt', 'sign', 'verify']
            },  
            {
            name: 'key-prod-002'
            keyType: 'RSA'
            keySize: 2048
            keyOperations: ['encrypt', 'decrypt', 'sign', 'verify']   
            },
            {
            name: 'key-prod-003'    
            keyType: 'RSA'
            keySize: 2048
            keyOperations: ['encrypt', 'decrypt', 'sign', 'verify']   
            }
        ]
        roleAssignments: [
          {
            name: 'ra-prod-001'
            roleDefinitionId: '/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}'
            principalId: '11111111-1111-1111-1111-111111111111'
          },
          {
            name: 'ra-prod-002'
            roleDefinitionId: '/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}'
            principalId: '22222222-2222-2222-2222-222222222222'    
          },
          {
            name: 'ra-prod-003'    
            roleDefinitionId: '/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}'
            principalId: '33333333-3333-3333-3333-333333333333'    
          }
        ]
        tags: {
          environnement: 'prod'
          department: 'IT'
        }
        diagnosticSettings: {
          name: 'diag-prod-001'
          workspaceId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}'
        }
}
```
