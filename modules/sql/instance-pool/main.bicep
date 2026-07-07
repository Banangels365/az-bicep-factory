// modules/sql/instance-pool/main.bicep

targetScope = 'resourceGroup'

@description('Nom du pool d\'instances SQL.')
param name string

@description('Région de déploiement.')
param location string = resourceGroup().location

@description('Tags à appliquer.')
param tags object = {}

@description('ID du subnet pour le pool.')
param subnetResourceId string

@allowed([
  'BasePrice'
  'LicenseIncluded'
])
@description('Type de licence.')
param licenseType string = 'BasePrice'

@description('Famille de SKU.')
param skuFamily string = 'Gen5'

@description('Nombre de vCores.')
@allowed([
  8
  16
  24
  32
  40
  64
  80
  96
  128
  160
  192
  224
  256
])
param vCores int = 8

@description('Tier du pool.')
@allowed([
  'GeneralPurpose'
  'BusinessCritical'
])
param tier string = 'GeneralPurpose'

@description('Nom du SKU.')
@allowed([
  'GPGen5'
  'BCGen5'
])
param skuName string = 'GPGen5'

@description('Capacité du SKU.')
param capacity int?

@description('Taille du SKU.')
param size string?

resource instancePool 'Microsoft.Sql/instancePools@2024-05-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: tier
    family: skuFamily
    capacity: capacity
    size: size
  }
  properties: {
    subnetId: subnetResourceId
    licenseType: licenseType
    vCores: vCores
  }
}

output name string = instancePool.name
output resourceId string = instancePool.id
output location string = instancePool.location
