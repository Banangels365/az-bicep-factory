// modules/compute/vm/virtual_machine_disk.bicep
// Module pour la création d'un disque managé Azure attachable à une machine virtuelle. 

targetScope = 'resourceGroup'

@description('Nom du disque à créer.')
param name string

@description('Localisation de la ressource.')
param location string = resourceGroup().location

@allowed([
  'Standard_LRS'
  'Premium_LRS'
  'StandardSSD_LRS'
  'UltraSSD_LRS'
  'Premium_ZRS'
  'PremiumV2_LRS'
])
@description('SKU du disque.')
param sku string

@allowed([
  'Attach'
  'Copy'
  'CopyStart'
  'Empty'
  'FromImage'
  'Import'
  'ImportSecure'
  'Restore'
  'Upload'
  'UploadPreparedSecure'
])
@description('Mode de création du disque.')
param createOption string = 'Empty'

@description('Taille du disque en Go, requise pour Empty.')
param diskSizeGB int = 0

@description('Type d\'OS si le disque est un disque OS.')
@allowed([
  'Windows'
  'Linux'
])
param osType string?

@description('Resource ID du Disk Encryption Set.')
param diskEncryptionSetResourceId string = ''

@description('ID de la source image pour FromImage.')
param imageReferenceId string = ''

@description('ID de la ressource source pour Copy/Restore/Attach.')
param sourceResourceId string = ''

@description('URI source pour Import.')
param sourceUri string = ''

@description('ID du storage account pour Import.')
param storageAccountId string = ''

@description('URI des données de sécurité pour ImportSecure.')
param securityDataUri string = ''

@description('Taille upload en bytes pour Upload.')
param uploadSizeBytes int = 20972032

@description('IOPS provisionnés pour UltraSSD ou PremiumV2 si applicable.')
param diskIOPSReadWrite int = 0

@description('Débit provisionné pour UltraSSD ou PremiumV2 si applicable.')
param diskMBpsReadWrite int = 0

@description('Activer bursting si supporté.')
param burstingEnabled bool = false

@description('Taille logique de secteur pour UltraSSD.')
param logicalSectorSize int = 4096

@description('Activer accès réseau accéléré sur capacités supportées.')
param acceleratedNetwork bool = false

@description('Architecture supportée par un disque OS.')
@allowed([
  'x64'
  'Arm64'
])
param architecture string?

@description('Hyper-V generation pour un disque OS.')
@allowed([
  'V1'
  'V2'
])
param hyperVGeneration string = 'V2'

@description('Nombre max de partages du disque.')
param maxShares int = 1

@description('Optimise le disque pour les détachements/attachements fréquents.')
param optimizedForFrequentAttach bool = false

@allowed([
  'AllowAll'
  'AllowPrivate'
  'DenyAll'
])
@description('Politique d\'accès réseau du disque.')
param networkAccessPolicy string = 'DenyAll'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Politique d\'export réseau public du disque.')
param publicNetworkAccess string = 'Disabled'

@description('Zone de disponibilité, -1 si non utilisée.')
@allowed([
  -1
  1
  2
  3
])
param availabilityZone int = -1

@description('Tags à appliquer au disque.')
param tags object = {}

// Variables
var isUltraOrPremiumV2 = contains(sku, 'Ultra') || contains(sku, 'PremiumV2')
var creationData = {
  createOption: createOption
  imageReference: createOption == 'FromImage' && !empty(imageReferenceId)
    ? {
        id: imageReferenceId
      }
    : null
  logicalSectorSize: contains(sku, 'Ultra') ? logicalSectorSize : null
  securityDataUri: createOption == 'ImportSecure' && !empty(securityDataUri) ? securityDataUri : null
  sourceResourceId: contains(
      [
        'Copy'
        'Restore'
        'Attach'
        'CopyStart'
      ],
      createOption
    ) && !empty(sourceResourceId)
    ? sourceResourceId
    : null
  sourceUri: createOption == 'Import' && !empty(sourceUri) ? sourceUri : null
  storageAccountId: createOption == 'Import' && !empty(storageAccountId) ? storageAccountId : null
  uploadSizeBytes: createOption == 'Upload' ? uploadSizeBytes : null
}

// Création du disque managé
resource disk 'Microsoft.Compute/disks@2025-01-02' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  zones: availabilityZone != -1 ? [string(availabilityZone)] : null
  properties: {
    burstingEnabled: burstingEnabled
    creationData: creationData
    diskSizeGB: createOption == 'Empty' ? diskSizeGB : null
    diskIOPSReadWrite: isUltraOrPremiumV2 && diskIOPSReadWrite > 0 ? diskIOPSReadWrite : null
    diskMBpsReadWrite: isUltraOrPremiumV2 && diskMBpsReadWrite > 0 ? diskMBpsReadWrite : null
    encryption: !empty(diskEncryptionSetResourceId)
      ? {
          diskEncryptionSetId: diskEncryptionSetResourceId
        }
      : null
    hyperVGeneration: !empty(osType) ? hyperVGeneration : null
    maxShares: maxShares
    networkAccessPolicy: networkAccessPolicy
    optimizedForFrequentAttach: optimizedForFrequentAttach
    osType: osType
    publicNetworkAccess: publicNetworkAccess
    supportedCapabilities: !empty(osType)
      ? {
          acceleratedNetwork: acceleratedNetwork
          architecture: architecture
        }
      : null
  }
}

// Outputs
@description('Nom du disque.')
output name string = disk.name

@description('ID du disque.')
output resourceId string = disk.id

@description('Région de déploiement.')
output location string = disk.location

@description('Resource group du disque.')
output resourceGroupName string = resourceGroup().name
