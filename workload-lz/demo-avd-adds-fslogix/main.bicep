param connections_VPN_NDC_LAN_name string = 'VPN_NDC_LAN'
param virtualMachines_VM_AVD_CNN_1_name string = 'VM-AVD-CNN-1'
param virtualMachines_VM_AVD_CNN_2_name string = 'VM-AVD-CNN-2'
param workspaces_CNN_name string = 'CNN'
param workspaces_NDC_name string = 'NDC'
param disks_VM_AVD_CNN_0_DataDisk_0_name string = 'VM-AVD-CNN-0_DataDisk_0'
param galleries_GAL_CNN_AVD_Sage300_name string = 'GAL_CNN_AVD_Sage300'
param virtualMachines_AVD_AZU_CNN_0_name string = 'AVD-AZU-CNN-0'
param virtualMachines_AVD_AZU_NDC_0_name string = 'AVD-AZU-NDC-0'
param connections_S2S_AdminBuilding_name string = 'S2S_AdminBuilding'
param virtualMachines_SRV_AZU_CNN_DC1_name string = 'SRV-AZU-CNN-DC1'
param virtualMachines_SRV_AZU_CNN_DC2_name string = 'SRV-AZU-CNN-DC2'
param virtualMachines_SRV_AZU_CNN_EC1_name string = 'SRV-AZU-CNN-EC1'
param virtualMachines_SRV_AZU_NDC_IIS_name string = 'SRV-AZU-NDC-IIS'
param virtualMachines_SRV_AZU_NDC_SQL_name string = 'SRV-AZU-NDC-SQL'
param vaults_rsv_avd_sage300_name string = 'rsv-avd-sage300'
param localNetworkGateways_AdminBuilding_name string = 'AdminBuilding'
param networkInterfaces_VM_AVD_CNN_0_nic_name string = 'VM-AVD-CNN-0-nic'
param networkInterfaces_VM_AVD_CNN_1_nic_name string = 'VM-AVD-CNN-1-nic'
param networkInterfaces_VM_AVD_CNN_2_nic_name string = 'VM-AVD-CNN-2-nic'
param networkInterfaces_AVD_AZU_CNN_0_nic_name string = 'AVD-AZU-CNN-0-nic'
param networkInterfaces_AVD_AZU_NDC_0_nic_name string = 'AVD-AZU-NDC-0-nic'
param storageAccounts_stavdsage300fslogix_name string = 'stavdsage300fslogix'
param automationAccounts_aa_avd_sage300_name string = 'aa-avd-sage300'
param networkInterfaces_srv_azu_cnn_dc1796_name string = 'srv-azu-cnn-dc1796'
param networkInterfaces_srv_azu_cnn_dc2575_name string = 'srv-azu-cnn-dc2575'
param networkInterfaces_srv_azu_cnn_ec1943_name string = 'srv-azu-cnn-ec1943'
param networkInterfaces_srv_azu_ndc_iis918_name string = 'srv-azu-ndc-iis918'
param networkInterfaces_srv_azu_ndc_sql788_name string = 'srv-azu-ndc-sql788'
param publicIPAddresses_SRV_AZU_NDC_IIS_ip_name string = 'SRV-AZU-NDC-IIS-ip'
param publicIPAddresses_Vnet_VPN_IP_Public_name string = 'Vnet_VPN_IP_Public'
param networkSecurityGroups_NSG_CNN_Identity_name string = 'NSG-CNN-Identity'
param virtualNetworkGateways_Vnet_VPN_Gateway_name string = 'Vnet_VPN_Gateway'
param proximityPlacementGroups_Proximity_Group_name string = 'Proximity_Group'
param workspaces_WS_Prod_Sage300_name string = 'WS-Prod-Sage300'
param networkSecurityGroups_NSG_Subnet_SQL_AVD_name string = 'NSG_Subnet_SQL-AVD'
param localNetworkGateways_Vnet_Gateway_VPN_NDC_name string = 'Vnet_Gateway_VPN_NDC'
param networkSecurityGroups_SRV_AZU_NDC_IIS_nsg_name string = 'SRV-AZU-NDC-IIS-nsg'
param networkSecurityGroups_SRV_AZU_NDC_SQL_nsg_name string = 'SRV-AZU-NDC-SQL-nsg'
param publicIPAddresses_AVD_AZU_NDC_0_IP_Public_name string = 'AVD-AZU-NDC-0-IP-Public'
param hostpools_HP_CNN_Prod_Sage300_name string = 'HP-CNN-Prod-Sage300'
param sqlVirtualMachines_srv_azu_ndc_sql_name string = 'srv-azu-ndc-sql'
param virtualNetworks_Vnet_Environnement_Infonuagique_name string = 'Vnet_Environnement_Infonuagique'
param dataCollectionRules_MSVMI_canadaeast_avd_azu_ndc_0_name string = 'MSVMI-canadaeast-avd-azu-ndc-0'
param bastionHosts_Vnet_Environnement_Infonuagique_bastion_name string = 'Vnet_Environnement_Infonuagique-bastion'
param applicationgroups_HP_CNN_Prod_Sage300_DAG_name string = 'HP-CNN-Prod-Sage300-DAG'
param disks_VM_AVD_CNN_0_OsDisk_1_b939ea7b720b4f678975d865ba6529f1_name string = 'VM-AVD-CNN-0_OsDisk_1_b939ea7b720b4f678975d865ba6529f1'
param virtualMachines_VM_AVD_CNN_0_externalid string = '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourceGroups/ENVIRONNEMENT_INFONUAGIQUE/providers/Microsoft.Compute/virtualMachines/VM-AVD-CNN-0'
param workspaces_defaultworkspace_b1b9a7fc_7467_4c21_a572_d453270cebfc_yq_externalid string = '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourceGroups/defaultresourcegroup-yq/providers/microsoft.operationalinsights/workspaces/defaultworkspace-b1b9a7fc-7467-4c21-a572-d453270cebfc-yq'
param natGateways_Vnet_Environnement_Infonuagique_NAT_VM_externalid string = '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourceGroups/defaultresourcegroup-yq/providers/Microsoft.Network/natGateways/Vnet_Environnement_Infonuagique-NAT-VM'

resource automationAccounts_aa_avd_sage300_name_resource 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: automationAccounts_aa_avd_sage300_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-24'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: true
    disableLocalAuth: false
    sku: {
      name: 'Basic'
    }
    encryption: {
      keySource: 'Microsoft.Automation'
      identity: {}
    }
  }
}

resource disks_VM_AVD_CNN_0_DataDisk_0_name_resource 'Microsoft.Compute/disks@2025-01-02' = {
  name: disks_VM_AVD_CNN_0_DataDisk_0_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-24'
  }
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 256
    diskIOPSReadWrite: 1100
    diskMBpsReadWrite: 125
    encryption: {
      type: 'EncryptionAtRestWithPlatformKey'
    }
    networkAccessPolicy: 'AllowAll'
    publicNetworkAccess: 'Enabled'
    dataAccessAuthMode: 'None'
    tier: 'P15'
  }
}

resource disks_VM_AVD_CNN_0_OsDisk_1_b939ea7b720b4f678975d865ba6529f1_name_resource 'Microsoft.Compute/disks@2025-01-02' = {
  name: disks_VM_AVD_CNN_0_OsDisk_1_b939ea7b720b4f678975d865ba6529f1_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-24'
    'cm-resource-parent': '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourceGroups/Environnement_Infonuagique/providers/Microsoft.DesktopVirtualization/hostpools/HP-CNN-Prod-Sage300'
  }
  sku: {
    name: 'StandardSSD_LRS'
    tier: 'Standard'
  }
  properties: {
    osType: 'Windows'
    hyperVGeneration: 'V2'
    supportsHibernation: true
    supportedCapabilities: {
      diskControllerTypes: 'SCSI, NVMe'
      acceleratedNetwork: true
      architecture: 'x64'
    }
    creationData: {
      createOption: 'FromImage'
      imageReference: {
        id: '/Subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/Providers/Microsoft.Compute/Locations/CanadaEast/Publishers/microsoftwindowsdesktop/ArtifactTypes/VMImage/Offers/office-365/Skus/win11-25h2-avd-m365/Versions/26200.8246.260414'
      }
    }
    diskSizeGB: 128
    diskIOPSReadWrite: 500
    diskMBpsReadWrite: 100
    encryption: {
      type: 'EncryptionAtRestWithPlatformKey'
    }
    networkAccessPolicy: 'AllowAll'
    securityProfile: {
      securityType: 'TrustedLaunch'
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource galleries_GAL_CNN_AVD_Sage300_name_resource 'Microsoft.Compute/galleries@2025-03-03' = {
  name: galleries_GAL_CNN_AVD_Sage300_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-05-04'
  }
  properties: {
    identifier: {}
    softDeletePolicy: {
      isSoftDeleteEnabled: true
    }
  }
}

resource proximityPlacementGroups_Proximity_Group_name_resource 'Microsoft.Compute/proximityPlacementGroups@2025-04-01' = {
  name: proximityPlacementGroups_Proximity_Group_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  properties: {
    proximityPlacementGroupType: 'Standard'
    intent: {
      vmSizes: [
        'Standard_E2bs_v5'
        'Standard_D4ds_v4'
        'Standard_D2ds_v4'
      ]
    }
  }
}

resource hostpools_HP_CNN_Prod_Sage300_name_resource 'Microsoft.DesktopVirtualization/hostpools@2026-01-01-preview' = {
  name: hostpools_HP_CNN_Prod_Sage300_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-24'
  }
  identity: {
    type: 'None'
  }
  properties: {
    allowRDPShortPathWithPrivateLink: 'Disabled'
    deploymentScope: 'Geographical'
    managedPrivateUDP: 'Default'
    directUDP: 'Default'
    publicUDP: 'Default'
    relayUDP: 'Default'
    managementType: 'Standard'
    publicNetworkAccess: 'Enabled'
    description: 'Créé via l\'extension Azure Virtual Desktop'
    hostPoolType: 'Pooled'
    customRdpProperty: 'drivestoredirect:s:;usbdevicestoredirect:s:;redirectclipboard:i:1;redirectprinters:i:1;audiomode:i:0;videoplaybackmode:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:0;enablerdsaadauth:i:1;autoreconnection enabled:i:1;bandwidthautodetect:i:1;networkautodetect:i:1;'
    maxSessionLimit: 20
    loadBalancerType: 'BreadthFirst'
    validationEnvironment: false
    ring: 1
    vmTemplate: '{"namePrefix":"VM-AVD-CNN","hibernate":false,"osDiskType":"StandardSSD_LRS","diskSizeGB":0,"securityType":"TrustedLaunch","secureBoot":true,"vTPM":true,"vmInfrastructureType":"Cloud","virtualProcessorCount":null,"memoryGB":null,"maximumMemoryGB":null,"minimumMemoryGB":null,"dynamicMemoryConfig":false}'
    preferredAppGroupType: 'Desktop'
    startVMOnConnect: true
  }
}

resource localNetworkGateways_AdminBuilding_name_resource 'Microsoft.Network/localNetworkGateways@2025-05-01' = {
  name: localNetworkGateways_AdminBuilding_name
  location: 'canadaeast'
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: [
        '192.168.1.0/24'
      ]
    }
    gatewayIpAddress: '104.232.53.226'
  }
}

resource localNetworkGateways_Vnet_Gateway_VPN_NDC_name_resource 'Microsoft.Network/localNetworkGateways@2025-05-01' = {
  name: localNetworkGateways_Vnet_Gateway_VPN_NDC_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: [
        '192.168.140.0/24'
      ]
    }
    gatewayIpAddress: '104.232.53.212'
  }
}

resource networkSecurityGroups_NSG_Subnet_SQL_AVD_name_resource 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: networkSecurityGroups_NSG_Subnet_SQL_AVD_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  properties: {
    securityRules: [
      {
        name: 'Block_Subnet_IIS'
        id: networkSecurityGroups_NSG_Subnet_SQL_AVD_name_Block_Subnet_IIS.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.50.2.0/29'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 500
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_NSG_CNN_Identity_name_resource 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: networkSecurityGroups_NSG_CNN_Identity_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-22'
  }
  properties: {
    securityRules: [
      {
        name: 'Allow_Inbound_Admin_RDP'
        id: networkSecurityGroups_NSG_CNN_Identity_name_Allow_Inbound_Admin_RDP.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '142.120.181.35'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_SRV_AZU_NDC_IIS_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: networkSecurityGroups_SRV_AZU_NDC_IIS_nsg_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  properties: {
    securityRules: [
      {
        name: 'Allow_Admin_Inbound_RDP_Access'
        id: networkSecurityGroups_SRV_AZU_NDC_IIS_nsg_name_Allow_Admin_Inbound_RDP_Access.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '76.65.96.75'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_SRV_AZU_NDC_SQL_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: networkSecurityGroups_SRV_AZU_NDC_SQL_nsg_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  properties: {
    securityRules: []
  }
}

resource publicIPAddresses_AVD_AZU_NDC_0_IP_Public_name_resource 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: publicIPAddresses_AVD_AZU_NDC_0_IP_Public_name
  location: 'canadaeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '52.235.30.157'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource publicIPAddresses_SRV_AZU_NDC_IIS_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: publicIPAddresses_SRV_AZU_NDC_IIS_ip_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '4.248.21.135'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_Vnet_VPN_IP_Public_name_resource 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: publicIPAddresses_Vnet_VPN_IP_Public_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '4.248.60.154'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource vaults_rsv_avd_sage300_name_resource 'Microsoft.RecoveryServices/vaults@2025-08-01' = {
  name: vaults_rsv_avd_sage300_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-29'
  }
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    restoreSettings: {
      crossSubscriptionRestoreSettings: {
        crossSubscriptionRestoreState: 'Enabled'
      }
    }
  }
}

resource storageAccounts_stavdsage300fslogix_name_resource 'Microsoft.Storage/storageAccounts@2025-08-01' = {
  name: storageAccounts_stavdsage300fslogix_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-22'
  }
  sku: {
    name: 'StandardV2_LRS'
    tier: 'Standard'
  }
  kind: 'FileStorage'
  properties: {
    dualStackEndpointPreference: {
      publishIpv6Endpoint: false
    }
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    azureFilesIdentityBasedAuthentication: {
      directoryServiceOptions: 'AD'
      activeDirectoryProperties: {
        samAccountName: 'stavdsage3d3p59'
        accountType: 'Computer'
        domainName: 'nemaska.ca'
        netBiosDomainName: 'nemaska.ca'
        forestName: 'nemaska.ca'
        domainGuid: '8caa4cc3-2294-4c20-b707-8c7a248ea2c5'
        domainSid: 'S-1-5-21-3933694272-2072138671-1737936037'
        azureStorageSid: 'S-1-5-21-3933694272-2072138671-1737936037-32607'
      }
      defaultSharePermission: 'StorageFileDataSmbShareContributor'
    }
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    networkAcls: {
      ipv6Rules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
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
  }
}

resource automationAccounts_aa_avd_sage300_name_Azure 'Microsoft.Automation/automationAccounts/connectionTypes@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Azure'
  properties: {
    isGlobal: true
    fieldDefinitions: {
      AutomationCertificateName: {
        isEncrypted: false
        isOptional: false
        type: 'System.String'
      }
      SubscriptionID: {
        isEncrypted: false
        isOptional: false
        type: 'System.String'
      }
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_AzureClassicCertificate 'Microsoft.Automation/automationAccounts/connectionTypes@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AzureClassicCertificate'
  properties: {
    isGlobal: true
    fieldDefinitions: {
      SubscriptionName: {
        isEncrypted: false
        isOptional: false
        type: 'System.String'
      }
      SubscriptionId: {
        isEncrypted: false
        isOptional: false
        type: 'System.String'
      }
      CertificateAssetName: {
        isEncrypted: false
        isOptional: false
        type: 'System.String'
      }
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_AzureServicePrincipal 'Microsoft.Automation/automationAccounts/connectionTypes@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AzureServicePrincipal'
  properties: {
    isGlobal: true
    fieldDefinitions: {
      ApplicationId: {
        isEncrypted: false
        isOptional: false
        type: 'System.String'
      }
      TenantId: {
        isEncrypted: false
        isOptional: false
        type: 'System.String'
      }
      CertificateThumbprint: {
        isEncrypted: false
        isOptional: false
        type: 'System.String'
      }
      SubscriptionId: {
        isEncrypted: false
        isOptional: false
        type: 'System.String'
      }
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_a322aad2_0c40_4033_a8d8_445e7642697c 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'a322aad2-0c40-4033-a8d8-445e7642697c'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_5d821d81_b2cc_49cb_9a59_dc627c2d0f8a_e64d48a2_0a46_4ea1_8119_1ecdd330befa_639139608000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_5d821d81-b2cc-49cb-9a59-dc627c2d0f8a_e64d48a2-0a46-4ea1-8119-1ecdd330befa_639139608000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_5d821d81_b2cc_49cb_9a59_dc627c2d0f8a_e64d48a2_0a46_4ea1_8119_1ecdd330befa_639140472000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_5d821d81-b2cc-49cb-9a59-dc627c2d0f8a_e64d48a2-0a46-4ea1-8119-1ecdd330befa_639140472000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_5d821d81_b2cc_49cb_9a59_dc627c2d0f8a_e64d48a2_0a46_4ea1_8119_1ecdd330befa_639141336000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_5d821d81-b2cc-49cb-9a59-dc627c2d0f8a_e64d48a2-0a46-4ea1-8119-1ecdd330befa_639141336000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_5d821d81_b2cc_49cb_9a59_dc627c2d0f8a_e64d48a2_0a46_4ea1_8119_1ecdd330befa_639142200000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_5d821d81-b2cc-49cb-9a59-dc627c2d0f8a_e64d48a2-0a46-4ea1-8119-1ecdd330befa_639142200000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_5d821d81_b2cc_49cb_9a59_dc627c2d0f8a_e64d48a2_0a46_4ea1_8119_1ecdd330befa_639143064000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_5d821d81-b2cc-49cb-9a59-dc627c2d0f8a_e64d48a2-0a46-4ea1-8119-1ecdd330befa_639143064000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639143928000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639143928000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639143964000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639143964000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144000000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144000000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144036000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144036000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144072000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144072000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144108000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144108000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144144000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144144000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144180000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144180000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144216000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144216000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144252000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144252000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144288000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144288000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144324000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144324000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144360000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144360000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144396000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144396000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144432000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144432000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144468000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144468000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144504000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144504000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144540000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144540000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144576000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144576000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144612000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144612000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144648000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144648000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144684000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144684000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144720000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144720000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144756000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144756000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144792000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144792000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144828000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144828000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144864000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144864000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144900000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144900000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144936000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144936000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639144972000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639144972000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145008000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145008000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145044000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145044000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145080000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145080000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145116000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145116000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145152000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145152000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145188000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145188000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145224000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145224000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145260000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145260000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145296000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145296000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145332000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145332000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145368000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145368000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145404000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145404000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145440000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145440000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145476000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145476000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145512000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145512000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145548000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145548000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145584000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145584000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145620000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145620000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145656000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145656000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145692000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145692000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145728000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145728000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145764000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145764000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145800000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145800000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145836000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145836000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145872000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145872000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145908000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145908000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145944000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145944000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639145980000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639145980000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146016000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146016000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146052000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146052000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146088000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146088000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146124000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146124000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146160000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146160000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146196000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146196000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146232000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146232000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146268000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146268000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146304000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146304000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146340000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146340000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146376000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146376000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146412000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146412000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146448000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146448000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146484000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146484000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146520000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146520000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146556000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146556000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146592000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146592000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146628000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146628000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146664000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146664000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146700000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146700000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146736000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146736000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146772000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146772000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146808000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146808000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146844000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146844000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146880000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146880000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146916000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146916000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146952000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146952000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639146988000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639146988000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147024000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147024000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147060000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147060000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147096000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147096000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147132000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147132000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147168000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147168000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147204000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147204000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147240000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147240000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147276000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147276000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147312000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147312000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147348000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147348000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147384000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147384000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147420000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147420000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147456000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147456000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147492000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147492000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147528000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147528000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147564000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147564000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147600000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147600000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147636000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147636000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147672000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147672000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147708000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147708000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147744000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147744000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147780000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147780000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147816000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147816000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147852000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147852000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147888000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147888000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147924000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147924000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147960000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147960000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639147996000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639147996000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148032000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148032000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148068000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148068000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148104000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148104000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148140000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148140000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148176000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148176000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148212000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148212000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148248000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148248000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148284000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148284000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148320000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148320000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148356000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148356000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148392000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148392000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148428000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148428000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148464000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148464000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148500000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148500000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148536000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148536000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148572000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148572000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148608000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148608000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148644000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148644000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148680000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148680000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148716000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148716000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148752000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148752000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148788000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148788000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148824000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148824000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148860000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148860000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148896000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148896000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148932000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148932000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639148968000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639148968000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149004000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149004000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149040000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149040000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149076000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149076000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149112000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149112000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149148000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149148000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149184000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149184000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149220000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149220000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149256000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149256000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149292000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149292000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149328000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149328000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149364000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149364000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149400000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149400000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149436000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149436000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149472000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149472000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149508000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149508000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149544000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149544000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149580000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149580000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149616000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149616000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149652000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149652000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149688000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149688000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149724000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149724000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149760000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149760000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149796000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149796000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149832000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149832000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149868000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149868000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149904000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149904000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149940000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149940000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639149976000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639149976000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150012000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150012000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150048000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150048000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150084000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150084000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150120000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150120000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150156000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150156000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150192000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150192000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150228000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150228000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150264000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150264000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150300000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150300000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150336000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150336000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150372000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150372000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150408000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150408000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150444000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150444000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150480000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150480000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150516000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150516000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150552000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150552000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150588000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150588000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150624000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150624000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150660000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150660000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150696000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150696000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150732000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150732000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150768000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150768000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150804000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150804000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150840000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150840000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150876000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150876000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150912000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150912000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150948000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150948000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639150984000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639150984000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151020000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151020000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151056000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151056000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151092000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151092000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151128000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151128000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151164000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151164000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151200000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151200000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151236000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151236000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151272000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151272000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151308000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151308000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151344000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151344000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151380000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151380000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151416000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151416000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151452000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151452000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151488000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151488000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151524000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151524000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151560000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151560000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151596000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151596000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151632000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151632000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151668000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151668000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151704000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151704000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151740000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151740000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151776000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151776000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151812000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151812000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151848000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151848000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151884000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151884000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151920000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151920000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151956000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151956000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639151992000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639151992000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152028000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152028000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152064000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152064000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152100000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152100000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152136000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152136000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152172000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152172000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152208000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152208000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152244000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152244000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152280000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152280000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152316000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152316000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152352000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152352000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152388000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152388000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152424000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152424000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152460000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152460000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152496000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152496000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152532000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152532000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152568000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152568000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152604000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152604000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152640000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152640000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152676000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152676000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152712000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152712000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152748000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152748000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152784000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152784000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152820000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152820000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152856000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152856000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152892000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152892000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152928000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152928000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639152964000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639152964000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639153000000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639153000000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639153036000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639153036000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639153072000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639153072000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639153108000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639153108000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639153144000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639153144000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639153180000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639153180000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639153216000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639153216000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639153252000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639153252000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639153288000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639153288000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c_a1d5fd19_9b03_4352_9e7a_0d23245556d3_639153324000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_9b037a6f-56a1-47ac-9d8d-42b051dd8f0c_a1d5fd19-9b03-4352-9e7a-0d23245556d3_639153324000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_cc33d4d3_3c65_46e0_8d6b_a5e98cfdf987_10e17544_2e79_4fe6_8b1a_94d2d2bf9a19_639143701800000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_cc33d4d3-3c65-46e0-8d6b-a5e98cfdf987_10e17544-2e79-4fe6-8b1a-94d2d2bf9a19_639143701800000000'
  properties: {
    runbook: {
      name: 'Start-AVD-VM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_cc33d4d3_3c65_46e0_8d6b_a5e98cfdf987_10e17544_2e79_4fe6_8b1a_94d2d2bf9a19_639146988000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_cc33d4d3-3c65-46e0-8d6b-a5e98cfdf987_10e17544-2e79-4fe6-8b1a-94d2d2bf9a19_639146988000000000'
  properties: {
    runbook: {
      name: 'Start-AVD-VM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_cc33d4d3_3c65_46e0_8d6b_a5e98cfdf987_10e17544_2e79_4fe6_8b1a_94d2d2bf9a19_639147852000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_cc33d4d3-3c65-46e0-8d6b-a5e98cfdf987_10e17544-2e79-4fe6-8b1a-94d2d2bf9a19_639147852000000000'
  properties: {
    runbook: {
      name: 'Start-AVD-VM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_cc33d4d3_3c65_46e0_8d6b_a5e98cfdf987_10e17544_2e79_4fe6_8b1a_94d2d2bf9a19_639148716000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_cc33d4d3-3c65-46e0-8d6b-a5e98cfdf987_10e17544-2e79-4fe6-8b1a-94d2d2bf9a19_639148716000000000'
  properties: {
    runbook: {
      name: 'Start-AVD-VM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_cc33d4d3_3c65_46e0_8d6b_a5e98cfdf987_10e17544_2e79_4fe6_8b1a_94d2d2bf9a19_639149580000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_cc33d4d3-3c65-46e0-8d6b-a5e98cfdf987_10e17544-2e79-4fe6-8b1a-94d2d2bf9a19_639149580000000000'
  properties: {
    runbook: {
      name: 'Start-AVD-VM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_cc33d4d3_3c65_46e0_8d6b_a5e98cfdf987_10e17544_2e79_4fe6_8b1a_94d2d2bf9a19_639150444000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_cc33d4d3-3c65-46e0-8d6b-a5e98cfdf987_10e17544-2e79-4fe6-8b1a-94d2d2bf9a19_639150444000000000'
  properties: {
    runbook: {
      name: 'Start-AVD-VM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_SCH_cc33d4d3_3c65_46e0_8d6b_a5e98cfdf987_10e17544_2e79_4fe6_8b1a_94d2d2bf9a19_639153036000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SCH_cc33d4d3-3c65-46e0-8d6b-a5e98cfdf987_10e17544-2e79-4fe6-8b1a-94d2d2bf9a19_639153036000000000'
  properties: {
    runbook: {
      name: 'Start-AVD-VM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_9b037a6f_56a1_47ac_9d8d_42b051dd8f0c 'Microsoft.Automation/automationAccounts/jobSchedules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: '9b037a6f-56a1-47ac-9d8d-42b051dd8f0c'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
    schedule: {
      name: 'Schedule-Stop-AVD-VM-6PM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_cc33d4d3_3c65_46e0_8d6b_a5e98cfdf987 'Microsoft.Automation/automationAccounts/jobSchedules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'cc33d4d3-3c65-46e0-8d6b-a5e98cfdf987'
  properties: {
    runbook: {
      name: 'Start-AVD-VM'
    }
    schedule: {
      name: 'Schedule-Start-AVD-VM-7AM'
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_AuditPolicyDsc 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AuditPolicyDsc'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Accounts 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Accounts'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Advisor 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Advisor'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Aks 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Aks'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_AnalysisServices 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.AnalysisServices'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ApiManagement 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ApiManagement'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_App 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.App'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_AppConfiguration 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.AppConfiguration'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ApplicationInsights 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ApplicationInsights'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ArcResourceBridge 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ArcResourceBridge'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Attestation 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Attestation'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Automanage 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Automanage'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Automation 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Automation'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Batch 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Batch'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Billing 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Billing'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Cdn 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Cdn'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_CloudService 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.CloudService'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_CognitiveServices 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.CognitiveServices'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Compute 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Compute'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ConfidentialLedger 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ConfidentialLedger'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ContainerInstance 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ContainerInstance'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ContainerRegistry 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ContainerRegistry'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_CosmosDB 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.CosmosDB'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_DataBoxEdge 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataBoxEdge'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Databricks 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Databricks'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_DataFactory 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataFactory'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_DataLakeAnalytics 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataLakeAnalytics'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_DataLakeStore 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataLakeStore'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_DataProtection 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataProtection'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_DataShare 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataShare'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_DeploymentManager 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DeploymentManager'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_DesktopVirtualization 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DesktopVirtualization'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_DevCenter 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DevCenter'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_DevTestLabs 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DevTestLabs'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Dns 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Dns'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_EventGrid 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.EventGrid'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_EventHub 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.EventHub'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_FrontDoor 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.FrontDoor'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Functions 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Functions'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_HDInsight 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.HDInsight'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_HealthcareApis 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.HealthcareApis'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_IotHub 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.IotHub'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_KeyVault 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.KeyVault'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Kusto 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Kusto'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_LoadTesting 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.LoadTesting'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_LogicApp 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.LogicApp'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_MachineLearning 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.MachineLearning'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_MachineLearningServices 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.MachineLearningServices'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Maintenance 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Maintenance'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ManagedServiceIdentity 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ManagedServiceIdentity'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ManagedServices 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ManagedServices'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_MarketplaceOrdering 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.MarketplaceOrdering'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Media 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Media'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Migrate 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Migrate'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Monitor 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Monitor'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_MySql 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.MySql'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Network 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Network'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_NetworkCloud 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.NetworkCloud'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_NotificationHubs 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.NotificationHubs'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_OperationalInsights 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.OperationalInsights'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_PolicyInsights 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.PolicyInsights'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_PostgreSql 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.PostgreSql'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_PowerBIEmbedded 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.PowerBIEmbedded'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_PrivateDns 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.PrivateDns'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_RecoveryServices 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.RecoveryServices'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_RedisCache 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.RedisCache'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_RedisEnterpriseCache 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.RedisEnterpriseCache'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Relay 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Relay'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ResourceMover 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ResourceMover'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Resources 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Resources'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Security 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Security'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_SecurityInsights 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.SecurityInsights'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ServiceBus 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ServiceBus'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_ServiceFabric 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ServiceFabric'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_SignalR 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.SignalR'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Sql 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Sql'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_SqlVirtualMachine 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.SqlVirtualMachine'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_StackHCI 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.StackHCI'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Storage 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Storage'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_StorageMover 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.StorageMover'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_StorageSync 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.StorageSync'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_StreamAnalytics 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.StreamAnalytics'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Support 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Support'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Synapse 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Synapse'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_TrafficManager 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.TrafficManager'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Az_Websites 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Websites'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_modules_automationAccounts_aa_avd_sage300_name_Azure 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Azure'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Azure_Storage 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Azure.Storage'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_AzureRM_Automation 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AzureRM.Automation'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_AzureRM_Compute 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AzureRM.Compute'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_AzureRM_Profile 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AzureRM.Profile'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_AzureRM_Resources 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AzureRM.Resources'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_AzureRM_Sql 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AzureRM.Sql'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_AzureRM_Storage 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AzureRM.Storage'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_ComputerManagementDsc 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'ComputerManagementDsc'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_GPRegistryPolicyParser 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'GPRegistryPolicyParser'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Microsoft_PowerShell_Core 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Microsoft.PowerShell.Core'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Microsoft_PowerShell_Diagnostics 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Microsoft.PowerShell.Diagnostics'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Microsoft_PowerShell_Management 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Microsoft.PowerShell.Management'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Microsoft_PowerShell_Security 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Microsoft.PowerShell.Security'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Microsoft_PowerShell_Utility 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Microsoft.PowerShell.Utility'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Microsoft_WSMan_Management 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Microsoft.WSMan.Management'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_Orchestrator_AssetManagement_Cmdlets 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Orchestrator.AssetManagement.Cmdlets'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_PSDscResources 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'PSDscResources'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_SecurityPolicyDsc 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'SecurityPolicyDsc'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_StateConfigCompositeResources 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'StateConfigCompositeResources'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_xDSCDomainjoin 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'xDSCDomainjoin'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_xPowerShellExecutionPolicy 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'xPowerShellExecutionPolicy'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_xRemoteDesktopAdmin 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'xRemoteDesktopAdmin'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Accounts 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Accounts'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Advisor 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Advisor'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Aks 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Aks'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_AnalysisServices 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.AnalysisServices'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ApiManagement 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ApiManagement'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_App 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.App'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_AppConfiguration 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.AppConfiguration'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ApplicationInsights 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ApplicationInsights'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ArcResourceBridge 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ArcResourceBridge'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Attestation 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Attestation'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Automanage 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Automanage'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Automation 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Automation'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Batch 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Batch'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Billing 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Billing'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Cdn 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Cdn'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_CloudService 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.CloudService'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_CognitiveServices 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.CognitiveServices'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Compute 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Compute'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ConfidentialLedger 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ConfidentialLedger'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ContainerInstance 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ContainerInstance'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ContainerRegistry 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ContainerRegistry'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_CosmosDB 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.CosmosDB'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_DataBoxEdge 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataBoxEdge'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Databricks 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Databricks'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_DataFactory 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataFactory'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_DataLakeAnalytics 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataLakeAnalytics'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_DataLakeStore 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataLakeStore'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_DataProtection 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataProtection'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_DataShare 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DataShare'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_DeploymentManager 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DeploymentManager'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_DesktopVirtualization 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DesktopVirtualization'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_DevCenter 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DevCenter'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_DevTestLabs 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.DevTestLabs'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Dns 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Dns'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_EventGrid 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.EventGrid'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_EventHub 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.EventHub'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_FrontDoor 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.FrontDoor'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Functions 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Functions'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_HDInsight 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.HDInsight'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_HealthcareApis 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.HealthcareApis'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_IotHub 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.IotHub'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_KeyVault 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.KeyVault'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Kusto 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Kusto'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_LoadTesting 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.LoadTesting'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_LogicApp 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.LogicApp'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_MachineLearning 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.MachineLearning'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_MachineLearningServices 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.MachineLearningServices'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Maintenance 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Maintenance'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ManagedServiceIdentity 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ManagedServiceIdentity'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ManagedServices 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ManagedServices'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_MarketplaceOrdering 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.MarketplaceOrdering'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Media 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Media'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Migrate 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Migrate'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Monitor 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Monitor'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_MySql 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.MySql'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Network 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Network'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_NetworkCloud 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.NetworkCloud'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_NotificationHubs 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.NotificationHubs'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_OperationalInsights 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.OperationalInsights'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_PolicyInsights 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.PolicyInsights'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_PostgreSql 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.PostgreSql'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_PowerBIEmbedded 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.PowerBIEmbedded'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_PrivateDns 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.PrivateDns'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_RecoveryServices 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.RecoveryServices'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_RedisCache 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.RedisCache'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_RedisEnterpriseCache 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.RedisEnterpriseCache'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Relay 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Relay'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ResourceMover 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ResourceMover'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Resources 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Resources'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Security 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Security'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_SecurityInsights 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.SecurityInsights'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ServiceBus 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ServiceBus'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_ServiceFabric 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.ServiceFabric'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_SignalR 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.SignalR'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Sql 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Sql'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_SqlVirtualMachine 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.SqlVirtualMachine'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_StackHCI 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.StackHCI'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Storage 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Storage'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_StorageMover 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.StorageMover'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_StorageSync 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.StorageSync'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_StreamAnalytics 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.StreamAnalytics'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Support 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Support'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Synapse 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Synapse'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_TrafficManager 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.TrafficManager'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage300_name_Az_Websites 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Az.Websites'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage300_name_AzureAutomationTutorialWithIdentity 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AzureAutomationTutorialWithIdentity'
  location: 'canadaeast'
  properties: {
    runbookType: 'PowerShell'
    logVerbose: false
    logProgress: false
    logActivityTrace: 0
  }
}

resource automationAccounts_aa_avd_sage300_name_AzureAutomationTutorialWithIdentityGraphical 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'AzureAutomationTutorialWithIdentityGraphical'
  location: 'canadaeast'
  properties: {
    runbookType: 'GraphPowerShell'
    logVerbose: false
    logProgress: false
    logActivityTrace: 0
  }
}

resource automationAccounts_aa_avd_sage300_name_Shutdown_AVD_IdleVM 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Shutdown-AVD-IdleVM'
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-24'
  }
  properties: {
    runbookType: 'PowerShell72'
    logVerbose: false
    logProgress: false
    logActivityTrace: 0
  }
}

resource automationAccounts_aa_avd_sage300_name_Start_AVD_VM 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Start-AVD-VM'
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-05-14'
  }
  properties: {
    runbookType: 'PowerShell72'
    logVerbose: false
    logProgress: false
    logActivityTrace: 0
  }
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'PowerShell-5.1'
  location: 'canadaeast'
  properties: {
    runtime: {
      language: 'PowerShell'
      version: '5.1'
    }
    defaultPackages: {
      az: '11.2.0'
    }
    description: 'System-generated Runtime Environment for your Automation account with Runtime language: PowerShell & Runtime version: 5.1. It automatically populates Packages defined for PowerShell 5.1 runtime version in your Automation account. This Runtime environment is non-editable. '
  }
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_7_1 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'PowerShell-7.1'
  location: 'canadaeast'
  properties: {
    runtime: {
      language: 'PowerShell'
      version: '7.1'
    }
    defaultPackages: {
      az: '8.0.0'
    }
    description: 'System-generated Runtime Environment for your Automation account with Runtime language: PowerShell & Runtime version: 7.1. It automatically populates Packages defined for PowerShell 7.1 runtime version in your Automation account. This Runtime environment is non-editable. '
  }
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_7_2 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'PowerShell-7.2'
  location: 'canadaeast'
  properties: {
    runtime: {
      language: 'PowerShell'
      version: '7.2'
    }
    defaultPackages: {
      az: '11.2.0'
      'azure cli': '2.56.0'
    }
    description: 'System-generated Runtime Environment for your Automation account with Runtime language: PowerShell & Runtime version: 7.2. It automatically populates Packages defined for PowerShell 7.2 runtime version in your Automation account. This Runtime environment is non-editable. '
  }
}

resource automationAccounts_aa_avd_sage300_name_Python_2_7 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Python-2.7'
  location: 'canadaeast'
  properties: {
    runtime: {
      language: 'Python'
      version: '2.7'
    }
    description: 'System-generated Runtime Environment for your Automation account with Runtime language: Python & Runtime version: 2.7. It automatically populates Packages defined for Python 2.7 runtime version in your Automation account. This Runtime environment is non-editable. '
  }
}

resource automationAccounts_aa_avd_sage300_name_Python_3_10 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Python-3.10'
  location: 'canadaeast'
  properties: {
    runtime: {
      language: 'Python'
      version: '3.10'
    }
    description: 'System-generated Runtime Environment for your Automation account with Runtime language: Python & Runtime version: 3.10. It automatically populates Packages defined for Python 3.10 runtime version in your Automation account. This Runtime environment is non-editable. '
  }
}

resource automationAccounts_aa_avd_sage300_name_Python_3_8 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Python-3.8'
  location: 'canadaeast'
  properties: {
    runtime: {
      language: 'Python'
      version: '3.8'
    }
    description: 'System-generated Runtime Environment for your Automation account with Runtime language: Python & Runtime version: 3.8. It automatically populates Packages defined for Python 3.8 runtime version in your Automation account. This Runtime environment is non-editable. '
  }
}

resource automationAccounts_aa_avd_sage300_name_Schedule_Start_AVD_VM_7AM 'Microsoft.Automation/automationAccounts/schedules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Schedule-Start-AVD-VM-7AM'
  properties: {
    startTime: '2026-05-16T07:00:00-04:00'
    expiryTime: '9999-12-31T18:59:00-05:00'
    interval: 1
    frequency: 'Week'
    timeZone: 'America/Toronto'
    advancedSchedule: {
      weekDays: [
        'Monday'
        'Tuesday'
        'Wednesday'
        'Thursday'
        'Friday'
      ]
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_Schedule_Stop_AVD_VM_6PM 'Microsoft.Automation/automationAccounts/schedules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_resource
  name: 'Schedule-Stop-AVD-VM-6PM'
  properties: {
    startTime: '2026-05-14T18:00:00-04:00'
    expiryTime: '9999-12-31T18:59:00-05:00'
    interval: 1
    frequency: 'Hour'
    timeZone: 'America/Toronto'
  }
}

resource galleries_GAL_CNN_AVD_Sage300_name_CNN_Sage300_win11_multisession 'Microsoft.Compute/galleries/images@2025-03-03' = {
  parent: galleries_GAL_CNN_AVD_Sage300_name_resource
  name: 'CNN-Sage300-win11-multisession'
  location: 'canadaeast'
  properties: {
    hyperVGeneration: 'V2'
    architecture: 'x64'
    features: [
      {
        name: 'SecurityType'
        value: 'TrustedLaunch'
      }
      {
        name: 'DiskControllerTypes'
        value: 'SCSI'
      }
    ]
    osType: 'Windows'
    osState: 'Generalized'
    identifier: {
      publisher: 'microsoftwindowsdesktop'
      offer: 'office-365'
      sku: 'win11-25h2-avd-m365'
    }
    recommended: {
      vCPUs: {
        min: 1
        max: 16
      }
      memory: {
        min: 1
        max: 32
      }
    }
  }
}

resource virtualMachines_SRV_AZU_CNN_DC1_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_SRV_AZU_CNN_DC1_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-22'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ls_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_SRV_AZU_CNN_DC1_name}_OsDisk_1_87f5fede2ba2436f947597e33283f92b'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_SRV_AZU_CNN_DC1_name}_OsDisk_1_87f5fede2ba2436f947597e33283f92b'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: [
        {
          lun: 0
          name: '${virtualMachines_SRV_AZU_CNN_DC1_name}_DataDisk_0'
          createOption: 'Attach'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
            id: resourceId('Microsoft.Compute/disks', '${virtualMachines_SRV_AZU_CNN_DC1_name}_DataDisk_0')
          }
          deleteOption: 'Delete'
          diskSizeGB: 128
          toBeDetached: false
        }
      ]
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_SRV_AZU_CNN_DC1_name
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
      adminUsername: 'CNN_AdminLoc'
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
          id: networkInterfaces_srv_azu_cnn_dc1796_name_resource.id
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

resource virtualMachines_SRV_AZU_CNN_DC2_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_SRV_AZU_CNN_DC2_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-22'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ls_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_SRV_AZU_CNN_DC2_name}_OsDisk_1_ecba904bcae24a7fa7922967af408e72'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_SRV_AZU_CNN_DC2_name}_OsDisk_1_ecba904bcae24a7fa7922967af408e72'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: [
        {
          lun: 0
          name: '${virtualMachines_SRV_AZU_CNN_DC2_name}_DataDisk_0'
          createOption: 'Attach'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
            id: resourceId('Microsoft.Compute/disks', '${virtualMachines_SRV_AZU_CNN_DC2_name}_DataDisk_0')
          }
          deleteOption: 'Delete'
          diskSizeGB: 128
          toBeDetached: false
        }
      ]
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_SRV_AZU_CNN_DC2_name
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
      adminUsername: 'CNN_AdminLoc'
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
          id: networkInterfaces_srv_azu_cnn_dc2575_name_resource.id
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

resource virtualMachines_SRV_AZU_CNN_EC1_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_SRV_AZU_CNN_EC1_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-22'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_SRV_AZU_CNN_EC1_name}_OsDisk_1_2da4ccfa362c4552b1f48a97c17cda72'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_SRV_AZU_CNN_EC1_name}_OsDisk_1_2da4ccfa362c4552b1f48a97c17cda72'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: [
        {
          lun: 0
          name: '${virtualMachines_SRV_AZU_CNN_EC1_name}_DataDisk_0'
          createOption: 'Attach'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
            id: resourceId('Microsoft.Compute/disks', '${virtualMachines_SRV_AZU_CNN_EC1_name}_DataDisk_0')
          }
          deleteOption: 'Delete'
          diskSizeGB: 128
          toBeDetached: false
        }
      ]
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_SRV_AZU_CNN_EC1_name
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
      adminUsername: 'CNN_AdminLoc'
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
          id: networkInterfaces_srv_azu_cnn_ec1943_name_resource.id
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

resource virtualMachines_SRV_AZU_NDC_IIS_name_enablevmAccess 'Microsoft.Compute/virtualMachines/extensions@2025-04-01' = {
  parent: virtualMachines_SRV_AZU_NDC_IIS_name_resource
  name: 'enablevmAccess'
  location: 'canadaeast'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'VMAccessAgent'
    typeHandlerVersion: '2.0'
    settings: {
      userName: 'SolulanIT'
    }
    protectedSettings: {}
  }
}

resource virtualMachines_VM_AVD_CNN_1_name_Microsoft_PowerShell_DSC 'Microsoft.Compute/virtualMachines/extensions@2025-04-01' = {
  parent: virtualMachines_VM_AVD_CNN_1_name_resource
  name: 'Microsoft.PowerShell.DSC'
  location: 'canadaeast'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.73'
    settings: {
      modulesUrl: 'https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.03391.1266.zip'
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      properties: {
        hostPoolName: 'HP-CNN-Prod-Sage300'
        registrationInfoTokenCredential: {
          UserName: 'PLACEHOLDER_DO_NOT_USE'
          Password: 'PrivateSettingsRef:RegistrationInfoToken'
        }
        aadJoin: false
        UseAgentDownloadEndpoint: true
        aadJoinPreview: false
        mdmId: ''
        sessionHostConfigurationLastUpdateTime: ''
      }
    }
    protectedSettings: {}
  }
}

resource virtualMachines_VM_AVD_CNN_2_name_Microsoft_PowerShell_DSC 'Microsoft.Compute/virtualMachines/extensions@2025-04-01' = {
  parent: virtualMachines_VM_AVD_CNN_2_name_resource
  name: 'Microsoft.PowerShell.DSC'
  location: 'canadaeast'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.73'
    settings: {
      modulesUrl: 'https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.03391.1266.zip'
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      properties: {
        hostPoolName: 'HP-CNN-Prod-Sage300'
        registrationInfoTokenCredential: {
          UserName: 'PLACEHOLDER_DO_NOT_USE'
          Password: 'PrivateSettingsRef:RegistrationInfoToken'
        }
        aadJoin: false
        UseAgentDownloadEndpoint: true
        aadJoinPreview: false
        mdmId: ''
        sessionHostConfigurationLastUpdateTime: ''
      }
    }
    protectedSettings: {}
  }
}

// resource applicationgroups_AVD_POOL_REMOTEAPPS_name_resource 'Microsoft.DesktopVirtualization/applicationgroups@2026-01-01-preview' = {
//   name: applicationgroups_AVD_POOL_REMOTEAPPS_name
//   location: 'canadaeast'
//   kind: 'RemoteApp'
//   properties: {
//     hostPoolArmPath: hostpools_AVD_POOL_name_resource.id
//     friendlyName: applicationgroups_AVD_POOL_REMOTEAPPS_name
//     applicationGroupType: 'RemoteApp'
//   }
// }

resource applicationgroups_HP_CNN_Prod_Sage300_DAG_name_resource 'Microsoft.DesktopVirtualization/applicationgroups@2026-01-01-preview' = {
  name: applicationgroups_HP_CNN_Prod_Sage300_DAG_name
  location: 'canadaeast'
  tags: {
    'cm-resource-parent': '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourceGroups/Environnement_Infonuagique/providers/Microsoft.DesktopVirtualization/HP-CNN-Prod-Sage300'
  }
  kind: 'Desktop'
  properties: {
    hostPoolArmPath: hostpools_HP_CNN_Prod_Sage300_name_resource.id
    description: 'Desktop Application Group created through the Hostpool Wizard'
    friendlyName: 'Default Desktop'
    applicationGroupType: 'Desktop'
  }
}

resource hostpools_HP_CNN_Prod_Sage300_name_VM_AVD_CNN_1_nemaska_ca 'Microsoft.DesktopVirtualization/hostpools/sessionhosts@2026-01-01-preview' = {
  parent: hostpools_HP_CNN_Prod_Sage300_name_resource
  name: 'VM-AVD-CNN-1.nemaska.ca'
  properties: {
    allowNewSession: true
  }
}

resource hostpools_HP_CNN_Prod_Sage300_name_VM_AVD_CNN_2_nemaska_ca 'Microsoft.DesktopVirtualization/hostpools/sessionhosts@2026-01-01-preview' = {
  parent: hostpools_HP_CNN_Prod_Sage300_name_resource
  name: 'VM-AVD-CNN-2.nemaska.ca'
  properties: {
    allowNewSession: true
  }
}

resource workspaces_WS_Prod_Sage300_name_resource 'Microsoft.DesktopVirtualization/workspaces@2026-01-01-preview' = {
  name: workspaces_WS_Prod_Sage300_name
  location: 'canadaeast'
  properties: {
    deploymentScope: 'Geographical'
    publicNetworkAccess: 'Enabled'
    applicationGroupReferences: [
      applicationgroups_HP_CNN_Prod_Sage300_DAG_name_resource.id
    ]
  }
}

resource bastionHosts_Vnet_Environnement_Infonuagique_bastion_name_resource 'Microsoft.Network/bastionHosts@2025-05-01' = {
  name: bastionHosts_Vnet_Environnement_Infonuagique_bastion_name
  location: 'canadaeast'
  sku: {
    name: 'Developer'
  }
  properties: {
    dnsName: 'omnibrain.canadaeast.bastionglobal.azure.com'
    scaleUnits: 2
    virtualNetwork: {
      id: virtualNetworks_Vnet_Environnement_Infonuagique_name_resource.id
    }
    ipConfigurations: []
  }
}

resource networkInterfaces_srv_azu_cnn_dc1796_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_srv_azu_cnn_dc1796_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-22'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_srv_azu_cnn_dc1796_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.50.3.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_Vnet_Environnement_Infonuagique_name_SNET_CNN_Identity.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_srv_azu_cnn_dc2575_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_srv_azu_cnn_dc2575_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-22'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_srv_azu_cnn_dc2575_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.50.3.5'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_Vnet_Environnement_Infonuagique_name_SNET_CNN_Identity.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_srv_azu_cnn_ec1943_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_srv_azu_cnn_ec1943_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-22'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_srv_azu_cnn_ec1943_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.50.3.6'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_Vnet_Environnement_Infonuagique_name_SNET_CNN_Identity.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_VM_AVD_CNN_0_nic_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_VM_AVD_CNN_0_nic_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-04-24'
    'cm-resource-parent': '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourcegroups/Environnement_Infonuagique/providers/Microsoft.DesktopVirtualization/hostpools/HP-CNN-Prod-Sage300'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        id: '${networkInterfaces_VM_AVD_CNN_0_nic_name_resource.id}/ipConfigurations/ipconfig'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.50.0.6'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_Vnet_Environnement_Infonuagique_name_VM.id
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

resource networkInterfaces_VM_AVD_CNN_1_nic_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_VM_AVD_CNN_1_nic_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-05-07'
    'cm-resource-parent': '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourcegroups/Environnement_Infonuagique/providers/Microsoft.DesktopVirtualization/hostpools/HP-CNN-Prod-Sage300'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        id: '${networkInterfaces_VM_AVD_CNN_1_nic_name_resource.id}/ipConfigurations/ipconfig'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.50.0.8'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_Vnet_Environnement_Infonuagique_name_VM.id
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

resource networkInterfaces_VM_AVD_CNN_2_nic_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_VM_AVD_CNN_2_nic_name
  location: 'canadaeast'
  tags: {
    'cm-resource-parent': '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourcegroups/Environnement_Infonuagique/providers/Microsoft.DesktopVirtualization/hostpools/HP-CNN-Prod-Sage300'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        id: '${networkInterfaces_VM_AVD_CNN_2_nic_name_resource.id}/ipConfigurations/ipconfig'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.50.0.9'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_Vnet_Environnement_Infonuagique_name_VM.id
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

resource networkSecurityGroups_SRV_AZU_NDC_IIS_nsg_name_Allow_Admin_Inbound_RDP_Access 'Microsoft.Network/networkSecurityGroups/securityRules@2025-05-01' = {
  name: '${networkSecurityGroups_SRV_AZU_NDC_IIS_nsg_name}/Allow_Admin_Inbound_RDP_Access'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '76.65.96.75'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_SRV_AZU_NDC_IIS_nsg_name_resource
  ]
}

resource networkSecurityGroups_NSG_CNN_Identity_name_Allow_Inbound_Admin_RDP 'Microsoft.Network/networkSecurityGroups/securityRules@2025-05-01' = {
  name: '${networkSecurityGroups_NSG_CNN_Identity_name}/Allow_Inbound_Admin_RDP'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '142.120.181.35'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_CNN_Identity_name_resource
  ]
}

resource networkSecurityGroups_NSG_Subnet_SQL_AVD_name_Block_Subnet_IIS 'Microsoft.Network/networkSecurityGroups/securityRules@2025-05-01' = {
  name: '${networkSecurityGroups_NSG_Subnet_SQL_AVD_name}/Block_Subnet_IIS'
  properties: {
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '10.50.2.0/29'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 500
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_Subnet_SQL_AVD_name_resource
  ]
}

resource virtualNetworks_Vnet_Environnement_Infonuagique_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_Vnet_Environnement_Infonuagique_name}/GatewaySubnet'
  properties: {
    addressPrefixes: [
      '10.50.1.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Vnet_Environnement_Infonuagique_name_resource
  ]
}

resource virtualNetworks_Vnet_Environnement_Infonuagique_name_IIS_WEB 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_Vnet_Environnement_Infonuagique_name}/IIS_WEB'
  properties: {
    addressPrefix: '10.50.2.0/29'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Vnet_Environnement_Infonuagique_name_resource
  ]
}

resource vaults_rsv_avd_sage300_name_CNN_FileShare_Backup_Policy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-08-01' = {
  parent: vaults_rsv_avd_sage300_name_resource
  name: 'CNN-FileShare-Backup-Policy'
  properties: {
    backupManagementType: 'AzureStorage'
    workLoadType: 'AzureFileShare'
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2026-05-08T20:00:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2026-05-08T20:00:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    timeZone: 'Eastern Standard Time'
    protectedItemsCount: 0
  }
}

resource vaults_rsv_avd_sage300_name_DefaultPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-08-01' = {
  parent: vaults_rsv_avd_sage300_name_resource
  name: 'DefaultPolicy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V1'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2026-04-30T09:00:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2026-04-30T09:00:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'UTC'
    protectedItemsCount: 0
  }
}

resource vaults_rsv_avd_sage300_name_EnhancedPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-08-01' = {
  parent: vaults_rsv_avd_sage300_name_resource
  name: 'EnhancedPolicy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V2'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicyV2'
      scheduleRunFrequency: 'Hourly'
      hourlySchedule: {
        interval: 4
        scheduleWindowStartTime: '2026-05-08T22:00:00Z'
        scheduleWindowDuration: 12
      }
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2026-05-08T22:00:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
      weeklySchedule: {
        daysOfTheWeek: [
          'Sunday'
        ]
        retentionTimes: [
          '2026-05-08T22:00:00Z'
        ]
        retentionDuration: {
          count: 4
          durationType: 'Weeks'
        }
      }
      monthlySchedule: {
        retentionScheduleFormatType: 'Weekly'
        retentionScheduleWeekly: {
          daysOfTheWeek: [
            'Sunday'
          ]
          weeksOfTheMonth: [
            'First'
          ]
        }
        retentionTimes: [
          '2026-05-08T22:00:00Z'
        ]
        retentionDuration: {
          count: 6
          durationType: 'Months'
        }
      }
    }
    tieringPolicy: {
      ArchivedRP: {
        tieringMode: 'DoNotTier'
        duration: 0
        durationType: 'Invalid'
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'Eastern Standard Time'
    protectedItemsCount: 0
  }
}

resource vaults_rsv_avd_sage300_name_HourlyLogBackup 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-08-01' = {
  parent: vaults_rsv_avd_sage300_name_resource
  name: 'HourlyLogBackup'
  properties: {
    backupManagementType: 'AzureWorkload'
    workLoadType: 'SQLDataBase'
    settings: {
      timeZone: 'UTC'
      issqlcompression: false
      isCompression: false
    }
    subProtectionPolicy: [
      {
        policyType: 'Full'
        schedulePolicy: {
          schedulePolicyType: 'SimpleSchedulePolicy'
          scheduleRunFrequency: 'Daily'
          scheduleRunTimes: [
            '2026-04-30T09:00:00Z'
          ]
          scheduleWeeklyFrequency: 0
        }
        retentionPolicy: {
          retentionPolicyType: 'LongTermRetentionPolicy'
          dailySchedule: {
            retentionTimes: [
              '2026-04-30T09:00:00Z'
            ]
            retentionDuration: {
              count: 30
              durationType: 'Days'
            }
          }
        }
      }
      {
        policyType: 'Log'
        schedulePolicy: {
          schedulePolicyType: 'LogSchedulePolicy'
          scheduleFrequencyInMins: 60
        }
        retentionPolicy: {
          retentionPolicyType: 'SimpleRetentionPolicy'
          retentionDuration: {
            count: 30
            durationType: 'Days'
          }
        }
      }
    ]
    protectedItemsCount: 0
  }
}

resource vaults_rsv_avd_sage300_name_defaultAlertSetting 'Microsoft.RecoveryServices/vaults/replicationAlertSettings@2025-08-01' = {
  parent: vaults_rsv_avd_sage300_name_resource
  name: 'defaultAlertSetting'
  properties: {
    sendToOwners: 'DoNotSend'
    customEmailAddresses: []
  }
}

resource vaults_rsv_avd_sage300_name_default 'Microsoft.RecoveryServices/vaults/replicationVaultSettings@2025-08-01' = {
  parent: vaults_rsv_avd_sage300_name_resource
  name: 'default'
  properties: {}
}

resource sqlVirtualMachines_srv_azu_ndc_sql_name_resource 'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01' = {
  name: sqlVirtualMachines_srv_azu_ndc_sql_name
  location: 'canadaeast'
  properties: {
    virtualMachineResourceId: virtualMachines_SRV_AZU_NDC_SQL_name_resource.id
    sqlImageOffer: 'SQL2022-WS2022'
    sqlServerLicenseType: 'AHUB'
    sqlManagement: 'LightWeight'
    leastPrivilegeMode: 'NotSet'
    sqlImageSku: 'Standard'
    enableAutomaticUpgrade: true
  }
}

resource storageAccounts_stavdsage300fslogix_name_default 'Microsoft.Storage/storageAccounts/fileServices@2025-08-01' = {
  parent: storageAccounts_stavdsage300fslogix_name_resource
  name: 'default'
  sku: {
    name: 'StandardV2_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
        encryptionInTransit: {
          required: true
        }
        multichannel: {
          enabled: false
        }
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 14
    }
  }
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_AuditPolicyDsc 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'AuditPolicyDsc'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_Azure 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'Azure'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_Azure_Storage 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'Azure.Storage'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_AzureRM_Automation 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'AzureRM.Automation'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_AzureRM_Compute 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'AzureRM.Compute'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_AzureRM_Profile 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'AzureRM.Profile'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_AzureRM_Resources 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'AzureRM.Resources'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_AzureRM_Sql 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'AzureRM.Sql'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_AzureRM_Storage 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'AzureRM.Storage'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_ComputerManagementDsc 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'ComputerManagementDsc'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_GPRegistryPolicyParser 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'GPRegistryPolicyParser'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_Microsoft_PowerShell_Core 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'Microsoft.PowerShell.Core'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_Microsoft_PowerShell_Diagnostics 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'Microsoft.PowerShell.Diagnostics'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_Microsoft_PowerShell_Management 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'Microsoft.PowerShell.Management'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_Microsoft_PowerShell_Security 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'Microsoft.PowerShell.Security'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_Microsoft_PowerShell_Utility 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'Microsoft.PowerShell.Utility'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_Microsoft_WSMan_Management 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'Microsoft.WSMan.Management'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_Orchestrator_AssetManagement_Cmdlets 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'Orchestrator.AssetManagement.Cmdlets'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_7_1_Orchestrator_AssetManagement_Cmdlets 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_7_1
  name: 'Orchestrator.AssetManagement.Cmdlets'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_PSDscResources 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'PSDscResources'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_SecurityPolicyDsc 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'SecurityPolicyDsc'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_StateConfigCompositeResources 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'StateConfigCompositeResources'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_xDSCDomainjoin 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'xDSCDomainjoin'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_xPowerShellExecutionPolicy 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'xPowerShellExecutionPolicy'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource automationAccounts_aa_avd_sage300_name_PowerShell_5_1_xRemoteDesktopAdmin 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage300_name_PowerShell_5_1
  name: 'xRemoteDesktopAdmin'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage300_name_resource
  ]
}

resource galleries_GAL_CNN_AVD_Sage300_name_CNN_Sage300_win11_multisession_1_0_0 'Microsoft.Compute/galleries/images/versions@2025-03-03' = {
  parent: galleries_GAL_CNN_AVD_Sage300_name_CNN_Sage300_win11_multisession
  name: '1.0.0'
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-05-07'
  }
  properties: {
    publishingProfile: {
      targetRegions: [
        {
          name: 'Canada East'
          regionalReplicaCount: 1
          storageAccountType: 'Standard_LRS'
          excludeFromLatest: false
        }
      ]
      replicaCount: 1
      excludeFromLatest: false
      storageAccountType: 'Standard_LRS'
      replicationMode: 'Full'
    }
    storageProfile: {
      source: {
        virtualMachineId: virtualMachines_VM_AVD_CNN_0_externalid
      }
      osDiskImage: {
        hostCaching: 'ReadWrite'
        source: {}
      }
      dataDiskImages: [
        {
          lun: 0
          hostCaching: 'None'
        }
      ]
    }
    safetyProfile: {
      blockDeletionBeforeEndOfLife: false
      allowDeletionOfReplicatedLocations: false
    }
  }
  dependsOn: [
    galleries_GAL_CNN_AVD_Sage300_name_resource
  ]
}

resource virtualMachines_SRV_AZU_NDC_IIS_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_SRV_AZU_NDC_IIS_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2ds_v4'
    }
    proximityPlacementGroup: {
      id: proximityPlacementGroups_Proximity_Group_name_resource.id
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_SRV_AZU_NDC_IIS_name}_OsDisk_1_7bed95dc7517465f98a966b247ab9cec'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_SRV_AZU_NDC_IIS_name}_OsDisk_1_7bed95dc7517465f98a966b247ab9cec'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_SRV_AZU_NDC_IIS_name
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
      adminUsername: 'microage'
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
          id: networkInterfaces_srv_azu_ndc_iis918_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    licenseType: 'Windows_Server'
  }
}

resource virtualMachines_SRV_AZU_NDC_SQL_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_SRV_AZU_NDC_SQL_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_E4s_v4'
    }
    proximityPlacementGroup: {
      id: proximityPlacementGroups_Proximity_Group_name_resource.id
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_SRV_AZU_NDC_SQL_name}_OsDisk_1_ed1ffd7c084d401180a34429b9c964ed'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_SRV_AZU_NDC_SQL_name}_OsDisk_1_ed1ffd7c084d401180a34429b9c964ed'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: [
        {
          lun: 0
          name: '${virtualMachines_SRV_AZU_NDC_SQL_name}_DataDisk_0'
          createOption: 'Attach'
          caching: 'ReadWrite'
          writeAcceleratorEnabled: false
          managedDisk: {
            storageAccountType: 'Premium_LRS'
            id: resourceId('Microsoft.Compute/disks', '${virtualMachines_SRV_AZU_NDC_SQL_name}_DataDisk_0')
          }
          deleteOption: 'Detach'
          diskSizeGB: 256
          toBeDetached: false
        }
      ]
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_SRV_AZU_NDC_SQL_name
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
      adminUsername: 'microage'
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
          id: networkInterfaces_srv_azu_ndc_sql788_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    licenseType: 'Windows_Server'
  }
}

resource virtualMachines_VM_AVD_CNN_1_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_VM_AVD_CNN_1_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 300'
    'Créé par': 'Solulan Inc'
    'Créé le': '2026-05-07'
    'cm-resource-parent': '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourceGroups/Environnement_Infonuagique/providers/Microsoft.DesktopVirtualization/hostpools/HP-CNN-Prod-Sage300'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B8s_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        id: galleries_GAL_CNN_AVD_Sage300_name_CNN_Sage300_win11_multisession_1_0_0.id
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_VM_AVD_CNN_1_name}_OsDisk_1_0d89c1111803411291d63db20ce73310'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_VM_AVD_CNN_1_name}_OsDisk_1_0d89c1111803411291d63db20ce73310'
          )
        }
        deleteOption: 'Detach'
        diskSizeGB: 128
      }
      dataDisks: [
        {
          lun: 0
          name: '${virtualMachines_VM_AVD_CNN_1_name}_lun_0_2_bc224ff587bf42128055f077e8098afc'
          createOption: 'FromImage'
          caching: 'None'
          managedDisk: {
            storageAccountType: 'Premium_LRS'
            id: resourceId(
              'Microsoft.Compute/disks',
              '${virtualMachines_VM_AVD_CNN_1_name}_lun_0_2_bc224ff587bf42128055f077e8098afc'
            )
          }
          deleteOption: 'Detach'
          diskSizeGB: 256
          toBeDetached: false
        }
      ]
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_VM_AVD_CNN_1_name
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'CNN_AVD_AdminLoc'
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
          id: networkInterfaces_VM_AVD_CNN_1_nic_name_resource.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    licenseType: 'Windows_Client'
  }
}

resource virtualMachines_VM_AVD_CNN_2_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_VM_AVD_CNN_2_name
  location: 'canadaeast'
  tags: {
    'cm-resource-parent': '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourceGroups/Environnement_Infonuagique/providers/Microsoft.DesktopVirtualization/hostpools/HP-CNN-Prod-Sage300'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B8s_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        id: galleries_GAL_CNN_AVD_Sage300_name_CNN_Sage300_win11_multisession_1_0_0.id
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_VM_AVD_CNN_2_name}_OsDisk_1_e575b08a74b24ef28b903576d4209ecb'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_VM_AVD_CNN_2_name}_OsDisk_1_e575b08a74b24ef28b903576d4209ecb'
          )
        }
        deleteOption: 'Detach'
        diskSizeGB: 128
      }
      dataDisks: [
        {
          lun: 0
          name: '${virtualMachines_VM_AVD_CNN_2_name}_lun_0_2_476ea817fe644fe1921daf1ec0e4127a'
          createOption: 'FromImage'
          caching: 'None'
          managedDisk: {
            storageAccountType: 'Premium_LRS'
            id: resourceId(
              'Microsoft.Compute/disks',
              '${virtualMachines_VM_AVD_CNN_2_name}_lun_0_2_476ea817fe644fe1921daf1ec0e4127a'
            )
          }
          deleteOption: 'Detach'
          diskSizeGB: 256
          toBeDetached: false
        }
      ]
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_VM_AVD_CNN_2_name
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'CNN_AVD_AdminLoc'
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
          id: networkInterfaces_VM_AVD_CNN_2_nic_name_resource.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    licenseType: 'Windows_Client'
  }
}

resource connections_S2S_AdminBuilding_name_resource 'Microsoft.Network/connections@2025-05-01' = {
  name: connections_S2S_AdminBuilding_name
  location: 'canadaeast'
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateways_Vnet_VPN_Gateway_name_resource.id
      properties: {}
    }
    localNetworkGateway2: {
      id: localNetworkGateways_AdminBuilding_name_resource.id
      properties: {}
    }
    connectionType: 'IPsec'
    connectionProtocol: 'IKEv2'
    routingWeight: 0
    authenticationType: 'PSK'
    enableBgp: false
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    ipsecPolicies: []
    trafficSelectorPolicies: []
    tunnelProperties: []
    expressRouteGatewayBypass: false
    enablePrivateLinkFastPath: false
    dpdTimeoutSeconds: 45
    connectionMode: 'Default'
    gatewayCustomBgpIpAddresses: []
  }
}

resource connections_VPN_NDC_LAN_name_resource 'Microsoft.Network/connections@2025-05-01' = {
  name: connections_VPN_NDC_LAN_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateways_Vnet_VPN_Gateway_name_resource.id
      properties: {}
    }
    localNetworkGateway2: {
      id: localNetworkGateways_Vnet_Gateway_VPN_NDC_name_resource.id
      properties: {}
    }
    connectionType: 'IPsec'
    connectionProtocol: 'IKEv2'
    routingWeight: 0
    authenticationType: 'PSK'
    enableBgp: false
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    ipsecPolicies: [
      {
        saLifeTimeSeconds: 27000
        saDataSizeKilobytes: 28800
        ipsecEncryption: 'AES256'
        ipsecIntegrity: 'SHA1'
        ikeEncryption: 'AES256'
        ikeIntegrity: 'SHA1'
        dhGroup: 'DHGroup2'
        pfsGroup: 'None'
      }
    ]
    trafficSelectorPolicies: []
    tunnelProperties: []
    expressRouteGatewayBypass: false
    enablePrivateLinkFastPath: false
    dpdTimeoutSeconds: 20
    connectionMode: 'Default'
    gatewayCustomBgpIpAddresses: []
  }
}

resource networkInterfaces_AVD_AZU_NDC_0_nic_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_AVD_AZU_NDC_0_nic_name
  location: 'canadaeast'
  tags: {
    NDC: ''
    'cm-resource-parent': '/subscriptions/b1b9a7fc-7467-4c21-a572-d453270cebfc/resourcegroups/Environnement_Infonuagique/providers/Microsoft.DesktopVirtualization/hostpools/AVD-POOL'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        id: '${networkInterfaces_AVD_AZU_NDC_0_nic_name_resource.id}/ipConfigurations/ipconfig'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.50.0.4'
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: publicIPAddresses_AVD_AZU_NDC_0_IP_Public_name_resource.id
          }
          subnet: {
            id: virtualNetworks_Vnet_Environnement_Infonuagique_name_VM.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_srv_azu_ndc_sql788_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_srv_azu_ndc_sql788_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_srv_azu_ndc_sql788_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.50.0.5'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: virtualNetworks_Vnet_Environnement_Infonuagique_name_VM.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_SRV_AZU_NDC_SQL_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource virtualNetworkGateways_Vnet_VPN_Gateway_name_resource 'Microsoft.Network/virtualNetworkGateways@2025-05-01' = {
  name: virtualNetworkGateways_Vnet_VPN_Gateway_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  properties: {
    enablePrivateIpAddress: false
    virtualNetworkGatewayMigrationStatus: {
      state: 'None'
      phase: 'None'
    }
    ipConfigurations: [
      {
        name: 'default'
        id: '${virtualNetworkGateways_Vnet_VPN_Gateway_name_resource.id}/ipConfigurations/default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_Vnet_VPN_IP_Public_name_resource.id
          }
          subnet: {
            id: virtualNetworks_Vnet_Environnement_Infonuagique_name_GatewaySubnet.id
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    enableHighBandwidthVpnGateway: false
    activeActive: false
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '10.50.1.254'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '${virtualNetworkGateways_Vnet_VPN_Gateway_name_resource.id}/ipConfigurations/default'
          customBgpIpAddresses: []
        }
      ]
    }
    vpnGatewayGeneration: 'Generation1'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}

resource virtualNetworks_Vnet_Environnement_Infonuagique_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_Vnet_Environnement_Infonuagique_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.50.0.0/22'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    dhcpOptions: {
      dnsServers: [
        '192.168.1.20'
        '10.50.3.4'
        '10.50.3.5'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_Vnet_Environnement_Infonuagique_name_GatewaySubnet.id
        properties: {
          addressPrefixes: [
            '10.50.1.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'IIS_WEB'
        id: virtualNetworks_Vnet_Environnement_Infonuagique_name_IIS_WEB.id
        properties: {
          addressPrefix: '10.50.2.0/29'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'VM'
        id: virtualNetworks_Vnet_Environnement_Infonuagique_name_VM.id
        properties: {
          addressPrefix: '10.50.0.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_Subnet_SQL_AVD_name_resource.id
          }
          natGateway: {
            id: natGateways_Vnet_Environnement_Infonuagique_NAT_VM_externalid
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                'canadaeast'
                'canadacentral'
              ]
            }
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'SNET-CNN-Identity'
        id: virtualNetworks_Vnet_Environnement_Infonuagique_name_SNET_CNN_Identity.id
        properties: {
          addressPrefixes: [
            '10.50.3.0/28'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_CNN_Identity_name_resource.id
          }
          natGateway: {
            id: natGateways_Vnet_Environnement_Infonuagique_NAT_VM_externalid
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_Vnet_Environnement_Infonuagique_name_SNET_CNN_Identity 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_Vnet_Environnement_Infonuagique_name}/SNET-CNN-Identity'
  properties: {
    addressPrefixes: [
      '10.50.3.0/28'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_CNN_Identity_name_resource.id
    }
    natGateway: {
      id: natGateways_Vnet_Environnement_Infonuagique_NAT_VM_externalid
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_Vnet_Environnement_Infonuagique_name_resource
  ]
}

resource virtualNetworks_Vnet_Environnement_Infonuagique_name_VM 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_Vnet_Environnement_Infonuagique_name}/VM'
  properties: {
    addressPrefix: '10.50.0.0/24'
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_Subnet_SQL_AVD_name_resource.id
    }
    natGateway: {
      id: natGateways_Vnet_Environnement_Infonuagique_NAT_VM_externalid
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
        locations: [
          'canadaeast'
          'canadacentral'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Vnet_Environnement_Infonuagique_name_resource
  ]
}

resource storageAccounts_stavdsage300fslogix_name_default_fslogix_profiles 'Microsoft.Storage/storageAccounts/fileServices/shares@2025-08-01' = {
  parent: storageAccounts_stavdsage300fslogix_name_default
  name: 'fslogix-profiles'
  properties: {
    provisionedIops: 1205
    provisionedBandwidthMibps: 81
    shareQuota: 1024
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_stavdsage300fslogix_name_resource
  ]
}

resource storageAccounts_avdstorageformapdrive_name_default_shared 'Microsoft.Storage/storageAccounts/fileServices/shares@2025-08-01' = {
  parent: storageAccounts_avdstorageformapdrive_name_default
  name: 'shared'
  properties: {
    provisionedIops: 3128
    provisionedBandwidthMibps: 138
    shareQuota: 128
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_avdstorageformapdrive_name_resource
  ]
}

resource networkInterfaces_srv_azu_ndc_iis918_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_srv_azu_ndc_iis918_name
  location: 'canadaeast'
  tags: {
    NDC: ''
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_srv_azu_ndc_iis918_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.50.2.4'
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: publicIPAddresses_SRV_AZU_NDC_IIS_ip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_Vnet_Environnement_Infonuagique_name_IIS_WEB.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_SRV_AZU_NDC_IIS_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
