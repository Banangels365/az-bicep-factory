// workload-lz/az-fileshare-01/main.bicep
// Demo project: Azure File Share avec Private Endpoint

targetScope = 'subscription'

@description('Nom du Workload')
param workloadName string = 'myapp'

@description('Environnement')
@allowed([
  'prod' // production
  'dev' // development
  'logs' // logging/monitoring
  'quar' // quarantine
  'sbox' // sandbox
])
param environment string

@description('Région de déploiement')
@allowed([
  'cace' // canadacentral
  'caea' // canadaeast
])
param location string = 'caea'

@description('ID de la subscription de déploiement')
param SubscriptionId string = subscription().subscriptionId

@description('Préfixe d\'adresse du VNet Spoke')
param spokeVnetAddressPrefix string = '10.1.0.0/16'

@description('Préfixe d\'adresse du subnet applicatif')
param appSubnetAddressPrefix string = '10.1.1.0/24'

@description('Préfixe d\'adresse du subnet data')
param dataSubnetAddressPrefix string = '10.1.2.0/24'

@description('ID de la subscription du VNet hub')
param hubVnetId string

@description('ID du Log Analytics Workspace pour les diagnostics')
param logAnalyticsWorkspaceId string

@description('ID de la zone DNS privée pour les endpoints blob (obligatoire si enablePrivateEndpoint est true)')
param privateDnsZoneIdBlob string

@description('Tags à appliquer à toutes les ressources du workload')
param tags object = {
  Application: workloadName
  Environnement: environment
  CreeLe: '2024-05-18'
  CreePar: 'CloudOps-Team'
  Criticite: 'Moyen'
  Responsable: 'CloudOps-Team'
  ResponsableEmail: 'cloudops@acmy.com'
  ManagedBy: 'Bicep'
}

param virtualMachines_DEMO_AZFS_DC01_name string = 'DEMO-AZFS-DC01'
param virtualMachines_DEMO_AZFS_EC01_name string = 'DEMO-AZFS-EC01'
param bastionHosts_DEMO_AZFS_Bastion_name string = 'DEMO-AZFS-Bastion'
param storageAccounts_sademoazfsproject_name string = 'sademoazfsproject'
param publicIPAddresses_DEMO_AZFS_DC01_ip_name string = 'DEMO-AZFS-DC01-ip'
param publicIPAddresses_DEMO_AZFS_EC01_ip_name string = 'DEMO-AZFS-EC01-ip'
param networkInterfaces_demo_azfs_dc01217_z1_name string = 'demo-azfs-dc01217_z1'
param networkInterfaces_demo_azfs_ec01110_z1_name string = 'demo-azfs-ec01110_z1'
param privateEndpoints_Demo_AZFS_StorageAccount_PE_name string = 'Demo-AZFS-StorageAccount_PE'
param schedules_shutdown_computevm_demo_azfs_dc01_name string = 'shutdown-computevm-demo-azfs-dc01'
param schedules_shutdown_computevm_demo_azfs_ec01_name string = 'shutdown-computevm-demo-azfs-ec01'
param virtualNetworks_VNET_DEMO_AZFS_Project_externalid string = '/subscriptions/0061dc3e-7704-4778-bcda-b566d000d486/resourceGroups/RG-DEMO-AZFS-Networking/providers/Microsoft.Network/virtualNetworks/VNET-DEMO-AZFS-Project'
param privateDnsZones_privatelink_file_core_windows_net_externalid string = '/subscriptions/0061dc3e-7704-4778-bcda-b566d000d486/resourceGroups/RG-DEMO-AZFS-Networking/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net'
param adminUsername string = 'PTech_Admin'

resource bastionHosts_DEMO_AZFS_Bastion_name_resource 'Microsoft.Network/bastionHosts@2024-07-01' = {
  name: bastionHosts_DEMO_AZFS_Bastion_name
  location: 'canadacentral'
  sku: {
    name: 'Developer'
  }
  properties: {
    dnsName: 'omnibrain.canadacentral.bastionglobal.azure.com'
    scaleUnits: 2
    virtualNetwork: {
      id: virtualNetworks_VNET_DEMO_AZFS_Project_externalid
    }
    ipConfigurations: []
  }
}

resource publicIPAddresses_DEMO_AZFS_DC01_ip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_DEMO_AZFS_DC01_ip_name
  location: 'canadacentral'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    ipAddress: '20.63.24.178'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource publicIPAddresses_DEMO_AZFS_EC01_ip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_DEMO_AZFS_EC01_ip_name
  location: 'canadacentral'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    ipAddress: '20.151.56.75'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource storageAccounts_sademoazfsproject_name_resource 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccounts_sademoazfsproject_name
  location: 'canadacentral'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Disabled'
    allowCrossTenantReplication: false
    isSftpEnabled: false
    azureFilesIdentityBasedAuthentication: {
      directoryServiceOptions: 'AD'
      activeDirectoryProperties: {
        samAccountName: storageAccounts_sademoazfsproject_name
        accountType: 'Computer'
        domainName: 'pragmatech.local'
        netBiosDomainName: 'pragmatech.local'
        forestName: 'pragmatech.local'
        domainGuid: 'dd47ffdc-a36c-44a2-a3e6-308197c36e36'
        domainSid: 'S-1-5-21-1342867759-159080019-785328617'
        azureStorageSid: 'S-1-5-21-1342867759-159080019-785328617-3101'
      }
      defaultSharePermission: 'StorageFileDataSmbShareContributor'
    }
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    isHnsEnabled: true
    networkAcls: {
      resourceAccessRules: []
      bypass: 'Logging, Metrics, AzureServices'
      virtualNetworkRules: [
        {
          id: '${virtualNetworks_VNET_DEMO_AZFS_Project_externalid}/subnets/AzureFiles'
          action: 'Allow'
          state: 'Succeeded'
        }
      ]
      ipRules: [
        {
          value: '76.65.96.184'
          action: 'Allow'
        }
        {
          value: '142.169.77.134'
          action: 'Allow'
        }
      ]
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: true
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource virtualMachines_DEMO_AZFS_DC01_name_resource 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: virtualMachines_DEMO_AZFS_DC01_name
  location: 'canadacentral'
  zones: [
    '1'
  ]
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-smalldisk-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_DEMO_AZFS_DC01_name}_OsDisk_1_6aa69b0c5fd44ffcb76f6ec5034b2a6e'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_DEMO_AZFS_DC01_name}_OsDisk_1_6aa69b0c5fd44ffcb76f6ec5034b2a6e'
          )
        }
        deleteOption: 'Delete'
      }
      dataDisks: [
        {
          lun: 0
          name: '${virtualMachines_DEMO_AZFS_DC01_name}_DataDisk_0'
          createOption: 'Attach'
          caching: 'None'
          writeAcceleratorEnabled: false
          managedDisk: {
            id: resourceId('Microsoft.Compute/disks', '${virtualMachines_DEMO_AZFS_DC01_name}_DataDisk_0')
          }
          deleteOption: 'Detach'
          toBeDetached: false
        }
      ]
      diskControllerType: 'SCSI'
      osProfile: {
        computerName: virtualMachines_DEMO_AZFS_DC01_name
        adminUsername: adminUsername
        windowsConfiguration: {
          provisionVMAgent: true
          enableAutomaticUpdates: true
          patchSettings: {
            patchMode: 'AutomaticByOS'
            assessmentMode: 'ImageDefault'
            enableHotpatching: false
          }
        }
        secrets: []
        allowExtensionOperations: true
        requireGuestProvisionSignal: true
      }
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_demo_azfs_dc01217_z1_name_resource.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource virtualMachines_DEMO_AZFS_EC01_name_resource 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: virtualMachines_DEMO_AZFS_EC01_name
  location: 'canadacentral'
  zones: [
    '1'
  ]
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-smalldisk-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_DEMO_AZFS_EC01_name}_OsDisk_1_6d438d14d2ce4350b116e54100acc90e'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_DEMO_AZFS_EC01_name}_OsDisk_1_6d438d14d2ce4350b116e54100acc90e'
          )
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
      osProfile: {
        computerName: virtualMachines_DEMO_AZFS_EC01_name
        adminUsername: adminUsername
        windowsConfiguration: {
          provisionVMAgent: true
          enableAutomaticUpdates: true
          patchSettings: {
            patchMode: 'AutomaticByOS'
            assessmentMode: 'ImageDefault'
            enableHotpatching: false
          }
        }
        secrets: []
        allowExtensionOperations: true
        requireGuestProvisionSignal: true
      }
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_demo_azfs_ec01110_z1_name_resource.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource schedules_shutdown_computevm_demo_azfs_dc01_name_resource 'microsoft.devtestlab/schedules@2018-09-15' = {
  name: schedules_shutdown_computevm_demo_azfs_dc01_name
  location: 'canadacentral'
  properties: {
    status: 'Disabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1900'
    }
    timeZoneId: 'Eastern Standard Time'
    notificationSettings: {
      status: 'Enabled'
      timeInMinutes: 30
      emailRecipient: 'mc_angeles@hotmail.fr'
      notificationLocale: 'fr'
    }
    targetResourceId: virtualMachines_DEMO_AZFS_DC01_name_resource.id
  }
}

resource schedules_shutdown_computevm_demo_azfs_ec01_name_resource 'microsoft.devtestlab/schedules@2018-09-15' = {
  name: schedules_shutdown_computevm_demo_azfs_ec01_name
  location: 'canadacentral'
  properties: {
    status: 'Disabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1900'
    }
    timeZoneId: 'UTC'
    notificationSettings: {
      status: 'Enabled'
      timeInMinutes: 30
      emailRecipient: 'mc_angeles@hotmail.fr'
      notificationLocale: 'fr'
    }
    targetResourceId: virtualMachines_DEMO_AZFS_EC01_name_resource.id
  }
}

resource networkInterfaces_demo_azfs_dc01217_z1_name_resource 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: networkInterfaces_demo_azfs_dc01217_z1_name
  location: 'canadacentral'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_demo_azfs_dc01217_z1_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: publicIPAddresses_DEMO_AZFS_DC01_ip_name_resource.id
          }
          subnet: {
            id: '${virtualNetworks_VNET_DEMO_AZFS_Project_externalid}/subnets/SubnetServers'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_demo_azfs_ec01110_z1_name_resource 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: networkInterfaces_demo_azfs_ec01110_z1_name
  location: 'canadacentral'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_demo_azfs_ec01110_z1_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.0.0.5'
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: publicIPAddresses_DEMO_AZFS_EC01_ip_name_resource.id
          }
          subnet: {
            id: '${virtualNetworks_VNET_DEMO_AZFS_Project_externalid}/subnets/SubnetServers'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource privateEndpoints_Demo_AZFS_StorageAccount_PE_name_resource 'Microsoft.Network/privateEndpoints@2024-07-01' = {
  name: privateEndpoints_Demo_AZFS_StorageAccount_PE_name
  location: 'canadacentral'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_Demo_AZFS_StorageAccount_PE_name
        id: '${privateEndpoints_Demo_AZFS_StorageAccount_PE_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_Demo_AZFS_StorageAccount_PE_name}'
        properties: {
          privateLinkServiceId: storageAccounts_sademoazfsproject_name_resource.id
          groupIds: [
            'file'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    customNetworkInterfaceName: '${privateEndpoints_Demo_AZFS_StorageAccount_PE_name}-nic'
    subnet: {
      id: '${virtualNetworks_VNET_DEMO_AZFS_Project_externalid}/subnets/AzureFiles'
    }
    ipConfigurations: []
    customDnsConfigs: []
  }
}

resource privateEndpoints_Demo_AZFS_StorageAccount_PE_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-07-01' = {
  name: '${privateEndpoints_Demo_AZFS_StorageAccount_PE_name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-file-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_file_core_windows_net_externalid
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints_Demo_AZFS_StorageAccount_PE_name_resource
  ]
}

resource storageAccounts_sademoazfsproject_name_default 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  parent: storageAccounts_sademoazfsproject_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_sademoazfsproject_name_default 'Microsoft.Storage/storageAccounts/fileServices@2025-01-01' = {
  parent: storageAccounts_sademoazfsproject_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_sademoazfsproject_name_storageAccounts_sademoazfsproject_name_34381609_938f_4f2f_8590_319963aed580 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2025-01-01' = {
  parent: storageAccounts_sademoazfsproject_name_resource
  name: '${storageAccounts_sademoazfsproject_name}.34381609-938f-4f2f-8590-319963aed580'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_sademoazfsproject_name_default 'Microsoft.Storage/storageAccounts/queueServices@2025-01-01' = {
  parent: storageAccounts_sademoazfsproject_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_sademoazfsproject_name_default 'Microsoft.Storage/storageAccounts/tableServices@2025-01-01' = {
  parent: storageAccounts_sademoazfsproject_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource storageAccounts_sademoazfsproject_name_default_demo_engineering 'Microsoft.Storage/storageAccounts/fileServices/shares@2025-01-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_sademoazfsproject_name_default
  name: 'demo-engineering'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 102400
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_sademoazfsproject_name_resource
  ]
}

resource storageAccounts_sademoazfsproject_name_default_demo_media 'Microsoft.Storage/storageAccounts/fileServices/shares@2025-01-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_sademoazfsproject_name_default
  name: 'demo-media'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 102400
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_sademoazfsproject_name_resource
  ]
}
