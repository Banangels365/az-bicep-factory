// modules/compute/gallery/compute_gallery_image_definition.bicep
// Ce module crée une définition d'image dans une galerie Azure Compute.

targetScope = 'resourceGroup'

@description('Nom de la définition d\'image.')
@minLength(1)
@maxLength(80)
param name string

@description('Localisation de déploiement de la définition d\'image.')
param location string = resourceGroup().location

@description('Nom de la galerie parente.')
@minLength(1)
param galleryName string

@description('Identifiant de la définition d\'image.')
param identifier object

@description('État du système d\'exploitation.')
@allowed([
  'Generalized'
  'Specialized'
])
param osState string

@description('Type du système d\'exploitation.')
@allowed([
  'Linux'
  'Windows'
])
param osType string

@description('Description de la définition d\'image.')
param imageDescription string = ''

@description('Autorise la mise à jour des features de l\'image.')
param allowUpdateImage bool?

@description('Architecture de l\'image.')
@allowed([
  'x64'
  'Arm64'
])
param architecture string?

@description('Plage recommandée de vCPUs.')
param vCPUs object?

@description('Plage recommandée de mémoire en Go.')
param memory object?

@description('Hyper-V generation.')
@allowed([
  'V1'
  'V2'
])
param hyperVGeneration string?

@description('Type de sécurité de l\'image.')
@allowed([
  'Standard'
  'ConfidentialVM'
  'TrustedLaunchSupported'
  'TrustedLaunch'
  'TrustedLaunchAndConfidentialVmSupported'
  'ConfidentialVMSupported'
])
param securityType string?

@description('Support de l\'accelerated networking.')
param isAcceleratedNetworkSupported bool?

@description('Support de l\'hibernation.')
param isHibernateSupported bool?

@description('Types de contrôleurs disque supportés.')
@allowed([
  'SCSI'
  'SCSI, NVMe'
  'NVMe, SCSI'
])
param diskControllerType string?

@description('Contrat EULA.')
param eula string?

@description('URI de politique de confidentialité.')
param privacyStatementUri string?

@description('URI des release notes.')
param releaseNoteUri string?

@description('Purchase plan marketplace.')
param purchasePlan object?

@description('Date de fin de vie.')
param endOfLifeDate string?

@description('Types de disques interdits.')
param disallowed object?

@description('Tags à appliquer.')
param tags object = {}

resource gallery 'Microsoft.Compute/galleries@2024-03-03' existing = {
  name: galleryName
}

resource image 'Microsoft.Compute/galleries/images@2024-03-03' = {
  name: name
  parent: gallery
  location: location
  tags: tags
  properties: {
    allowUpdateImage: allowUpdateImage != null ? allowUpdateImage : null
    architecture: architecture
    description: !empty(imageDescription) ? imageDescription : null
    disallowed: {
      diskTypes: disallowed.?diskTypes ?? []
    }
    endOfLifeDate: endOfLifeDate
    eula: eula
    features: union(
      isAcceleratedNetworkSupported != null
        ? [
            {
              name: 'IsAcceleratedNetworkSupported'
              value: '${isAcceleratedNetworkSupported}'
            }
          ]
        : [],
      securityType != null && securityType != 'Standard'
        ? [
            {
              name: 'SecurityType'
              value: securityType
            }
          ]
        : [],
      isHibernateSupported != null
        ? [
            {
              name: 'IsHibernateSupported'
              value: '${isHibernateSupported}'
            }
          ]
        : [],
      diskControllerType != null
        ? [
            {
              name: 'DiskControllerTypes'
              value: diskControllerType
            }
          ]
        : []
    )
    hyperVGeneration: hyperVGeneration ?? (!empty(securityType ?? '') ? 'V2' : 'V1')
    identifier: {
      publisher: identifier.publisher
      offer: identifier.offer
      sku: identifier.sku
    }
    osState: osState
    osType: osType
    privacyStatementUri: privacyStatementUri
    ...(purchasePlan != null ? { purchasePlan: purchasePlan } : {})
    recommended: {
      vCPUs: vCPUs
      memory: memory
    }
    releaseNoteUri: releaseNoteUri
  }
}

@description('Resource ID de la définition d\'image.')
output resourceId string = image.id

@description('Nom de la définition d\'image.')
output name string = image.name

@description('Région réelle de la définition d\'image.')
output deployedLocation string = image.location
