// modules/compute/vm/virtual_machine_nic_configuration.bicep
// Ce module déploie une interface réseau (NIC) pour une machine virtuelle Azure, avec une configuration flexible pour les adresses IP, les paramètres de sécurité, et les diagnostics. 
// Il prend en charge la création d'une adresse IP publique associée à la NIC, ainsi que l'association à un groupe de sécurité réseau (NSG)
// et la configuration de paramètres avancés tels que l'accélération réseau et le transfert IP.  

targetScope = 'resourceGroup'

@description('Nom de la carte réseau.')
param networkInterfaceName string

@description('Nom de la machine virtuelle associée.')
param virtualMachineName string

@description('Liste des configurations IP.')
param ipConfigurations array

@description('Localisation de toutes les ressources.')
param location string = resourceGroup().location

@description('Tags des ressources.')
param tags object = {}

@description('Active IP forwarding.')
param enableIPForwarding bool = false

@description('Active l\'accélération réseau.')
param enableAcceleratedNetworking bool = false

@description('Liste des serveurs DNS appliqués à la NIC.')
param dnsServers array = []

@description('ID du NSG à associer à la NIC.')
param networkSecurityGroupResourceId string = ''

@description('Diagnostic settings à appliquer à la NIC.')
param diagnosticSettings array = []

var primaryIpConfig = first(ipConfigurations)
var publicIpRequested = contains(primaryIpConfig, 'pipConfiguration') && primaryIpConfig.pipConfiguration != null
var publicIpName = publicIpRequested ? (primaryIpConfig.pipConfiguration.?name ?? '${virtualMachineName}-pip') : ''
var publicIpAllocationMethod = publicIpRequested && contains(
    primaryIpConfig.pipConfiguration,
    'publicIPAllocationMethod'
  )
  ? primaryIpConfig.pipConfiguration.publicIPAllocationMethod
  : 'Static'
var publicIpSku = publicIpRequested && contains(primaryIpConfig.pipConfiguration, 'skuName')
  ? primaryIpConfig.pipConfiguration.skuName
  : 'Standard'
var publicIpZones = publicIpRequested && contains(primaryIpConfig.pipConfiguration, 'availabilityZones')
  ? primaryIpConfig.pipConfiguration.availabilityZones
  : null

resource publicIp 'Microsoft.Network/publicIPAddresses@2024-07-01' = if (publicIpRequested && (!contains(
  primaryIpConfig.pipConfiguration,
  'publicIPAddressResourceId'
) || empty(primaryIpConfig.pipConfiguration.publicIPAddressResourceId))) {
  name: publicIpName
  location: location
  tags: tags
  sku: {
    name: publicIpSku
  }
  zones: publicIpZones
  properties: {
    publicIPAllocationMethod: publicIpAllocationMethod
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: networkInterfaceName
  location: location
  tags: tags
  properties: {
    enableIPForwarding: enableIPForwarding
    enableAcceleratedNetworking: enableAcceleratedNetworking
    dnsSettings: !empty(dnsServers)
      ? {
          dnsServers: dnsServers
        }
      : null
    networkSecurityGroup: !empty(networkSecurityGroupResourceId)
      ? {
          id: networkSecurityGroupResourceId
        }
      : null
    ipConfigurations: [
      for (ipConfiguration, index) in ipConfigurations: {
        name: ipConfiguration.?name ?? 'ipconfig${index + 1}'
        properties: {
          privateIPAllocationMethod: ipConfiguration.?privateIPAllocationMethod ?? 'Dynamic'
          privateIPAddress: ipConfiguration.?privateIPAddress ?? null
          subnet: {
            id: ipConfiguration.?subnetResourceId ?? null
          }
          publicIPAddress: contains(ipConfiguration, 'pipConfiguration') && ipConfiguration.pipConfiguration != null
            ? {
                id: contains(ipConfiguration.pipConfiguration, 'publicIPAddressResourceId') && !empty(ipConfiguration.pipConfiguration.publicIPAddressResourceId)
                  ? ipConfiguration.pipConfiguration.publicIPAddressResourceId
                  : publicIp.id
              }
            : null
        }
      }
    ]
  }
}

resource nicDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for diagnosticSetting in diagnosticSettings: {
    scope: networkInterface
    name: diagnosticSetting.name
    properties: {
      workspaceId: diagnosticSetting.?workspaceResourceId ?? null
      logs: diagnosticSetting.?logs ?? []
      metrics: diagnosticSetting.?metrics ?? []
    }
  }
]

@description('Nom de la NIC.')
output name string = networkInterface.name

@description('ID de la NIC.')
output resourceId string = networkInterface.id

@description('Liste des IP configurations.')
output ipConfigurations array = networkInterface.properties.ipConfigurations

@description('Adresse IP privée principale.')
output privateIpAddress string = networkInterface.properties.ipConfigurations[0].properties.privateIPAddress

@description('ID de l\'adresse IP publique.')
output publicIpId string = publicIpRequested
  ? (contains(primaryIpConfig.pipConfiguration, 'publicIPAddressResourceId') && !empty(primaryIpConfig.pipConfiguration.publicIPAddressResourceId)
      ? primaryIpConfig.pipConfiguration.publicIPAddressResourceId
      : publicIp.id)
  : ''
