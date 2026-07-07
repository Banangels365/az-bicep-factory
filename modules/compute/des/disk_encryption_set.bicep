// modules/compute/des/disk_encryption_set.bicep
// Azure Disk Encryption Set avec clé CMK stockée dans Azure Key Vault ou Managed HSM.

targetScope = 'resourceGroup'

@description('Nom du Disk Encryption Set.')
param name string

@description('Région de déploiement. Par défaut, la région du resource group.')
param location string = resourceGroup().location

@description('Tags à appliquer au Disk Encryption Set.')
param tags object = {}

@description('Type de chiffrement des disques utilisant ce DES.')
@allowed([
  'EncryptionAtRestWithCustomerKey'
  'EncryptionAtRestWithPlatformAndCustomerKeys'
  'ConfidentialVmEncryptedWithCustomerKey'
])
param encryptionType string = 'EncryptionAtRestWithPlatformAndCustomerKeys'

@description('Client ID d\'application fédérée pour accéder à un Key Vault situé dans un autre tenant.') // Utiliser 'None' pour ne pas renseigner la propriété.
param federatedClientId string = 'None'

@description('Active la création des permissions nécessaires sur la clé Key Vault pour les identités user-assigned fournies.')
param enableKeyPermissions bool = false

@description('Indique si le Key Vault cible utilise RBAC au lieu des access policies.')
param keyVaultUsesRbac bool = true

@description('Active l\'identité système sur le Disk Encryption Set.')
param systemAssignedIdentity bool = true

@description('Liste des IDs des identités user-assigned à associer au Disk Encryption Set.')
param userAssignedIdentityResourceIds array = []

@description('Définition de la clé CMK utilisée par le Disk Encryption Set.')
param customerManagedKey object

@description('Paramètres de verrouillage de la ressource.') // Exemple : { kind: 'CanNotDelete', name: 'lock-des', notes: 'Protection DES' }.
param lock object = {}

// Variables

var formattedUserAssignedIdentities = reduce(
  map(userAssignedIdentityResourceIds, id => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

var identity = {
  type: systemAssignedIdentity
    ? (!empty(userAssignedIdentityResourceIds) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
    : (!empty(userAssignedIdentityResourceIds) ? 'UserAssigned' : 'None')
  userAssignedIdentities: !empty(userAssignedIdentityResourceIds) ? formattedUserAssignedIdentities : null
}

var isHsmManagedCmk = length(split(customerManagedKey.keyVaultResourceId, '/')) > 7 && split(
  customerManagedKey.keyVaultResourceId,
  '/'
)[7] == 'managedHSMs'

var keyVaultSubscriptionId = split(customerManagedKey.keyVaultResourceId, '/')[2]

var keyVaultResourceGroupName = split(customerManagedKey.keyVaultResourceId, '/')[4]

var keyVaultName = last(split(customerManagedKey.keyVaultResourceId, '/'))

// Création des ressources

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2025-01-02' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    activeKey: {
      sourceVault: !isHsmManagedCmk && keyVaultSubscriptionId == subscription().subscriptionId
        ? {
            id: customerManagedKey.keyVaultResourceId
          }
        : null
      keyUrl: !empty(customerManagedKey.?keyVersion)
        ? '${customerManagedKey.keyVaultUri}/keys/${customerManagedKey.keyName}/${customerManagedKey.keyVersion}'
        : '${customerManagedKey.keyVaultUri}/keys/${customerManagedKey.keyName}'
    }
    encryptionType: encryptionType
    federatedClientId: federatedClientId == 'None' ? null : federatedClientId
    rotationToLatestKeyVersionEnabled: customerManagedKey.?autoRotationEnabled ?? true
  }
}

// Attribution facultative des permissions sur la clé Key Vault pour les identités user-assigned.
module keyVaultPermissions './key_vault_permissions.bicep' = [
  for (uamiId, index) in userAssignedIdentityResourceIds: if (enableKeyPermissions && !isHsmManagedCmk) {
    name: 'des-kv-permissions-${uniqueString(name, uamiId, string(index))}'
    scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName)
    params: {
      keyVaultResourceId: customerManagedKey.keyVaultResourceId
      keyName: customerManagedKey.keyName
      userAssignedIdentityResourceId: uamiId
      rbacAuthorizationEnabled: keyVaultUsesRbac
      location: location
    }
  }
]

resource diskEncryptionSetLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock) && lock.?kind != 'None') {
  name: lock.?name ?? '${name}-lock'
  scope: diskEncryptionSet
  properties: {
    level: lock.kind
    notes: lock.?notes ?? (lock.kind == 'CanNotDelete'
      ? 'Cannot delete the resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

// Outputs

@description('ID de ressource du Disk Encryption Set.')
output resourceId string = diskEncryptionSet.id

@description('Nom du Disk Encryption Set.')
output name string = diskEncryptionSet.name

@description('Nom du resource group de déploiement.')
output resourceGroupName string = resourceGroup().name

@description('Localisation du Disk Encryption Set.')
output location string = diskEncryptionSet.location

@description('Principal ID de l\'identité système du Disk Encryption Set, si activée.')
output systemAssignedMIPrincipalId string = systemAssignedIdentity ? diskEncryptionSet.identity.principalId : ''

@description('Bloc d\'identités attaché au Disk Encryption Set.')
output identities object = diskEncryptionSet.identity

@description('Nom du Key Vault hébergeant la clé.')
output keyVaultName string = keyVaultName

@description('URL complète de la clé active utilisée par le Disk Encryption Set.')
output keyUrl string = diskEncryptionSet.properties.activeKey.keyUrl
