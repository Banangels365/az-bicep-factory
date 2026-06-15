// modules/compute/gallery/compute_gallery.bicep
// Ce module crée une galerie Azure Compute avec des définitions d'images associées.

targetScope = 'resourceGroup'

@description('Nom de la galerie Azure Compute Gallery.')
@minLength(1)
param galleryName string

@description('Localisation de déploiement pour la galerie et, par défaut, pour les définitions d\'images.')
param location string = resourceGroup().location

@description('Description de la galerie.')
param galleryDescription string = ''

@description('Définitions d\'images à créer dans la galerie.')
param imageDefinitions array = []

@description('Profil de partage de la galerie.')
param sharingProfile object

@description('Politique de soft delete de la galerie.')
param softDeletePolicy object

@description('Tags à appliquer à la galerie et, par défaut, aux images.')
param tags object = {}

resource gallery 'Microsoft.Compute/galleries@2024-03-03' = {
  name: galleryName
  location: location
  tags: tags
  properties: {
    description: !empty(galleryDescription) ? galleryDescription : null
    sharingProfile: sharingProfile
    softDeletePolicy: softDeletePolicy
  }
}

module galleryImages './compute_gallery_image_definition.bicep' = [
  for (imageDef, index) in imageDefinitions: {
    name: 'gallery-image-${uniqueString(deployment().name, galleryName, string(index))}'
    params: {
      galleryName: gallery.name
      name: imageDef.name
      location: imageDef.?location ?? location
      identifier: imageDef.identifier ?? {
        publisher: imageDef.publisher
        offer: imageDef.offer
        sku: imageDef.sku
      }
      osType: imageDef.osType
      osState: imageDef.osState
      imageDescription: imageDef.?description
      allowUpdateImage: imageDef.?allowUpdateImage
      architecture: imageDef.?architecture
      hyperVGeneration: imageDef.?hyperVGeneration
      securityType: imageDef.?securityType
      isAcceleratedNetworkSupported: imageDef.?isAcceleratedNetworkSupported
      isHibernateSupported: imageDef.?isHibernateSupported
      diskControllerType: imageDef.?diskControllerType

      vCPUs: imageDef.?vCPUs ?? contains(imageDef, 'minRecommendedVCPUs') || contains(imageDef, 'maxRecommendedVCPUs')
        ? {
            min: imageDef.?minRecommendedVCPUs
            max: imageDef.?maxRecommendedVCPUs
          }
        : null

      memory: imageDef.?memory ?? contains(imageDef, 'minRecommendedMemoryInGB') || contains(
          imageDef,
          'maxRecommendedMemoryInGB'
        )
        ? {
            min: imageDef.?minRecommendedMemoryInGB
            max: imageDef.?maxRecommendedMemoryInGB
          }
        : null

      purchasePlan: imageDef.?purchasePlan
      eula: imageDef.?eula
      privacyStatementUri: imageDef.?privacyStatementUri
      releaseNoteUri: imageDef.?releaseNoteUri
      endOfLifeDate: imageDef.?endOfLifeDate ?? imageDef.?endOfLife

      disallowed: !empty(imageDef.?excludedDiskTypes ?? [])
        ? {
            diskTypes: imageDef.excludedDiskTypes
          }
        : null

      tags: imageDef.?tags ?? tags
    }
  }
]

@description('ID de la galerie.')
output galleryId string = gallery.id

@description('Nom de la galerie.')
output name string = gallery.name

@description('Région réelle de la galerie.')
output deployedLocation string = gallery.location

@description('IDs des définitions d\'images créées.')
output imageDefinitionIds array = [for i in range(0, length(imageDefinitions)): galleryImages[i].outputs.resourceId]

@description('Noms des définitions d\'images créées.')
output imageDefinitionNames array = [for i in range(0, length(imageDefinitions)): galleryImages[i].outputs.name]
