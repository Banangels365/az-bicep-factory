# Modules pour Azure Compute Gallery
Ce dossier contient des modules Bicep pour déployer et configurer Azure Compute Gallery, un service de gestion d'images personnalisées pour les machines virtuelles Azure. Ces modules permettent de créer des galeries avec des définitions d'images associées, ainsi que de configurer des profils de partage, des politiques de soft delete, et des tags. Ils sont conçus pour être réutilisables et adaptables à différents scénarios de gestion d'images dans Azure.

## Modules disponibles
- `compute_gallery.bicep`: Module principal pour déployer une galerie Azure Compute Gallery avec des configurations flexibles.
- `compute_gallery_image_definition.bicep`: Module pour déployer des définitions d'images dans une galerie Azure Compute Gallery existante.   


## Description du module Compute Gallery
Le module `compute_gallery.bicep` permet de déployer une galerie Azure Compute Gallery, qui est un service de gestion d'images personnalisées pour les machines virtuelles Azure. Ce module prend en charge la création d'une galerie avec des définitions d'images associées, ainsi que la configuration de profils de partage, de politiques de soft delete, et de tags. Il permet également de spécifier des paramètres avancés pour les images, tels que le type d'OS, l'état de l'OS, et les options de mise à jour. Le module retourne des informations clés sur la galerie et les images déployées, telles que les Resource IDs et les noms.

#### Paramètres du module Compute Gallery

#### Inputs 

#### Outputs    

#### Ressources créées

### Exemple d'utilisation du module Compute Gallery
```bicep
module computeGallery './modules/compute/gallery/compute_gallery.bicep' = {
  name: 'compute-gallery-prod-001'
  params: {
    name: 'compute-gallery-prod-001'
    location: 'canadaeast'
    resourceGroupName: 'rg-prod-001'
    imageDefinitions: [
      {
        name: 'image-def-prod-001'
        osType: 'Windows'
        osState: 'Generalized'
        description: 'Image de base pour les machines virtuelles Windows.'
        allowUpdateImage: true
        architecture: 'x64'
        hyperVGeneration: 'V2'
      }
    ]
    sharingProfile: {
      permissions: 'Groups'
      groups: [
        '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentId}'
      ]
    }
    softDeletePolicy: {
      retentionDays: 30
    }
    tags: {
      environnement: 'prod'
      department: 'IT'
    }
  }
}
```

## Description du module Compute Gallery Image Definition
Le module `compute_gallery_image_definition.bicep` permet de déployer une définition d'image dans une galerie Azure Compute Gallery existante. Il prend en charge la configuration de paramètres avancés pour l'image, tels que le type d'OS, l'état de l'OS, les options de mise à jour, et les tags. Le module retourne des informations clés sur la définition d'image déployée, telles que son Resource ID et son nom.  

### Paramètres du module Compute Gallery Image Definition

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Compute Gallery Image Definition
```bicep
module computeGalleryImageDef './modules/compute/gallery/compute_gallery_image_definition.bicep' = {
  name: 'compute-gallery-image-def-prod-001'
  params: {
    name: 'compute-gallery-image-def-prod-001'
    location: 'canadaeast'
    resourceGroupName: 'rg-prod-001'
    galleryName: 'compute-gallery-prod-001'
    osType: 'Windows'
    osState: 'Generalized'
    description: 'Image de base pour les machines virtuelles Windows.'
    allowUpdateImage: true
    architecture: 'x64'
    hyperVGeneration: 'V2'
    tags: {
      environnement: 'prod'
      department: 'IT'
    }
  }
}
```

