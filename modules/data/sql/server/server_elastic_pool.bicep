// modules/data/sql/server/server_elastic_pool.bicep

/*
  Module : Azure SQL Elastic Pool Deployment
  Fonction :
    Ce module déploie un Elastic Pool Azure SQL sur un serveur SQL existant.
    Il prend en charge :
      - La configuration du SKU (tier, compute, capacité)
      - Les paramètres de haute disponibilité
      - Les paramètres de maintenance
      - Les paramètres de performance par base (perDatabaseSettings)
      - Le chiffrement Always Encrypted (enclave)
      - Le verrouillage de ressource (CanNotDelete / ReadOnly)
      - Les affectations RBAC au niveau de l\'Elastic Pool
*/

targetScope = 'resourceGroup'

import { roleAssignmentType, lockType } from '../types.bicep'

@description('Nom de l\'Elastic Pool à créer.')
param name string

@description('Nom du serveur SQL existant sur lequel le pool sera déployé.')
param serverName string

@description('Tags appliqués à l\'Elastic Pool.')
param tags object = {}

@description('Localisation de l\'Elastic Pool.')
param location string = resourceGroup().location

@description('Configuration du verrouillage de ressource.')
param lock lockType?

@description('Configuration SKU du pool (tier, compute, capacité).')
param sku object = {
  capacity: 2
  name: 'GP_Gen5'
  tier: 'GeneralPurpose'
}

@description('Délai d\'auto-pause pour les bases serverless. -1 désactive l\'auto-pause.')
param autoPauseDelay int = -1

@description('Zone de disponibilité. -1 = NoPreference.')
@allowed([-1, 1, 2, 3])
param availabilityZone int = -1

@description('Nombre de réplicas HA pour Business Critical.')
param highAvailabilityReplicaCount int?

@description('Type de licence SQL (BasePrice ou LicenseIncluded).')
@allowed(['BasePrice', 'LicenseIncluded'])
param licenseType string = 'LicenseIncluded'

@description('ID de configuration de maintenance.')
param maintenanceConfigurationId string?

@description('Taille maximale du pool en bytes.')
param maxSizeBytes int = 34359738368

@description('Capacité minimale du pool.')
param minCapacity int?

@description('Paramètres de performance par base dans le pool.')
param perDatabaseSettings object = {
  autoPauseDelay: -1
  maxCapacity: '2'
  minCapacity: '0'
}

@description('Type d\'enclave pour Always Encrypted.')
param preferredEnclaveType 'Default' | 'VBS' = 'Default'

@description('Active la redondance zone.')
param zoneRedundant bool = true

@description('Liste des affectations RBAC à appliquer sur l\'Elastic Pool.')
param roleAssignments roleAssignmentType[] = []

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

resource elasticPool 'Microsoft.Sql/servers/elasticPools@2023-08-01' = {
  name: name
  location: location
  parent: server
  tags: tags
  sku: sku
  properties: {
    autoPauseDelay: autoPauseDelay
    availabilityZone: availabilityZone != -1 ? string(availabilityZone) : 'NoPreference'
    highAvailabilityReplicaCount: highAvailabilityReplicaCount
    licenseType: licenseType
    maintenanceConfigurationId: maintenanceConfigurationId
    maxSizeBytes: maxSizeBytes
    minCapacity: minCapacity
    perDatabaseSettings: !empty(perDatabaseSettings)
      ? {
          autoPauseDelay: perDatabaseSettings.?autoPauseDelay
          maxCapacity: json(perDatabaseSettings.?maxCapacity)
          minCapacity: json(perDatabaseSettings.?minCapacity)
        }
      : null
    preferredEnclaveType: preferredEnclaveType
    zoneRedundant: zoneRedundant
  }
}

resource elasticPoolLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  scope: elasticPool
  properties: {
    level: lock.?kind!
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
}

resource elasticPoolRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssignment in roleAssignments: {
    name: roleAssignment.?name ?? guid(elasticPool.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    scope: elasticPool
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      principalType: roleAssignment.?principalType
      description: roleAssignment.?description
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
  }
]

@description('Nom de l\'Elastic Pool déployé.')
output name string = elasticPool.name

@description('ID complet de la ressource Elastic Pool.')
output resourceId string = elasticPool.id
