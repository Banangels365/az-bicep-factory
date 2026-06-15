param natGateways_ng_sage50_prod_name string = 'ng-sage50-prod'
param virtualMachines_vm_sage50_0_name string = 'vm-sage50-0'
param storageAccounts_stsage50prod_name string = 'stsage50prod'
param vaults_rsv_avd_sage50_name string = 'rsv-avd-sage50'
param privateEndpoints_stsage50prod_pe_name string = 'stsage50prod-pe'
param virtualNetworks_vnet_sage50_prod_name string = 'vnet-sage50-prod'
param networkInterfaces_vm_sage50_0_nic_name string = 'vm-sage50-0-nic'
param workspaces_ws_sage50_name string = 'ws-sage50'
param automationAccounts_aa_avd_sage50_name string = 'aa-avd-sage50'
param bastionHosts_vnet_sage50_prod_bastion_name string = 'vnet-sage50-prod-bastion'
param networkSecurityGroups_nsg_sage50_prod_name string = 'nsg-sage50-prod'
param hostpools_hp_sage50_prod_name string = 'hp-sage50-prod'
param publicIPAddresses_avd_sage50_public_ip_name string = 'avd-sage50-public-ip'
param privateDnsZones_privatelink_file_core_windows_net_name string = 'privatelink.file.core.windows.net'
param applicationgroups_hp_sage50_prod_DAG_name string = 'hp-sage50-prod-DAG'

resource automationAccounts_aa_avd_sage50_name_resource 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: automationAccounts_aa_avd_sage50_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par ': 'Solulan'
    'Créé le': '2026-04-20'
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

resource hostpools_hp_sage50_prod_name_resource 'Microsoft.DesktopVirtualization/hostpools@2026-01-01-preview' = {
  name: hostpools_hp_sage50_prod_name
  location: 'canadaeast'
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
    description: 'Créé via l’extension Azure Virtual Desktop'
    hostPoolType: 'Pooled'
    customRdpProperty: 'drivestoredirect:s:;usbdevicestoredirect:s:;redirectclipboard:i:1;redirectprinters:i:1;audiomode:i:0;videoplaybackmode:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:0;enablerdsaadauth:i:1;'
    maxSessionLimit: 20
    loadBalancerType: 'DepthFirst'
    validationEnvironment: false
    ring: 1
    vmTemplate: '{"namePrefix":"vm-sage50","hibernate":false,"osDiskType":"StandardSSD_LRS","diskSizeGB":128,"securityType":"TrustedLaunch","secureBoot":true,"vTPM":true,"vmInfrastructureType":"Cloud","virtualProcessorCount":null,"memoryGB":null,"maximumMemoryGB":null,"minimumMemoryGB":null,"dynamicMemoryConfig":false}'
    preferredAppGroupType: 'Desktop'
    startVMOnConnect: true
  }
}

resource networkSecurityGroups_nsg_sage50_prod_name_resource 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: networkSecurityGroups_nsg_sage50_prod_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par ': 'Solulan'
    'Créé le': '2026-04-17'
  }
  properties: {
    securityRules: [
      {
        name: 'Allow_Inbound_Admin_Management_RDP'
        id: networkSecurityGroups_nsg_sage50_prod_name_Allow_Inbound_Admin_Management_RDP.id
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

resource privateDnsZones_privatelink_file_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_file_core_windows_net_name
  location: 'global'
  tags: {
    Projet: 'AVD Sage 50'
  }
  properties: {}
}

resource vaults_rsv_avd_sage50_name_resource 'Microsoft.RecoveryServices/vaults@2025-08-01' = {
  name: vaults_rsv_avd_sage50_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par': 'Solulan'
    'Créé le': '2026-04-20'
  }
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    securitySettings: {
      immutabilitySettings: {
        state: 'Unlocked'
      }
      softDeleteSettings: {
        softDeleteRetentionPeriodInDays: 14
        softDeleteState: 'Enabled'
        enhancedSecurityState: 'Enabled'
      }
      sourceScanConfiguration: {
        state: 'Disabled'
      }
    }
    redundancySettings: {
      standardTierStorageRedundancy: 'GeoRedundant'
      crossRegionRestore: 'Disabled'
    }
    publicNetworkAccess: 'Enabled'
    restoreSettings: {
      crossSubscriptionRestoreSettings: {
        crossSubscriptionRestoreState: 'Enabled'
      }
    }
  }
}

resource storageAccounts_stsage50prod_name_resource 'Microsoft.Storage/storageAccounts@2025-08-01' = {
  name: storageAccounts_stsage50prod_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par': 'Solulan'
    'Créé le': '2026-04-21'
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
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    networkAcls: {
      ipv6Rules: []
      resourceAccessRules: []
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

resource automationAccounts_aa_avd_sage50_name_Azure 'Microsoft.Automation/automationAccounts/connectionTypes@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
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

resource automationAccounts_aa_avd_sage50_name_AzureClassicCertificate 'Microsoft.Automation/automationAccounts/connectionTypes@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
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

resource automationAccounts_aa_avd_sage50_name_AzureServicePrincipal 'Microsoft.Automation/automationAccounts/connectionTypes@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
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

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639127512000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639127512000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639128376000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639128376000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639129240000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639129240000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639130140000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639130140000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639131004000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639131004000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639131868000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639131868000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639132732000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639132732000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639133596000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639133596000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639134460000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639134460000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639135324000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639135324000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639136188000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639136188000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639137052000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639137052000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639137916000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639137916000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639138780000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639138780000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639139644000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639139644000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639140508000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639140508000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639141372000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639141372000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639142236000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639142236000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639143100000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639143100000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639143964000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639143964000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639144828000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639144828000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639145692000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639145692000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639146556000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639146556000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639147420000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639147420000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639148284000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639148284000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639149148000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639149148000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639150012000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639150012000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639150876000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639150876000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639151740000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639151740000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_SCH_b9c843a5_0568_44e0_8f16_75d23a87154b_214f2ed0_052d_4ef2_9b4e_aa9361ca6b21_639152604000000000 'Microsoft.Automation/automationAccounts/jobs@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SCH_b9c843a5-0568-44e0-8f16-75d23a87154b_214f2ed0-052d-4ef2-9b4e-aa9361ca6b21_639152604000000000'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_b9c843a5_0568_44e0_8f16_75d23a87154b 'Microsoft.Automation/automationAccounts/jobSchedules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'b9c843a5-0568-44e0-8f16-75d23a87154b'
  properties: {
    runbook: {
      name: 'Shutdown-AVD-IdleVM'
    }
    schedule: {
      name: 'schedule-avd-check-idle'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_AuditPolicyDsc 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'AuditPolicyDsc'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Accounts 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Accounts'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Advisor 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Advisor'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Aks 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Aks'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_AnalysisServices 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.AnalysisServices'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ApiManagement 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ApiManagement'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_App 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.App'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_AppConfiguration 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.AppConfiguration'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ApplicationInsights 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ApplicationInsights'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ArcResourceBridge 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ArcResourceBridge'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Attestation 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Attestation'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Automanage 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Automanage'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Automation 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Automation'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Batch 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Batch'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Billing 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Billing'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Cdn 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Cdn'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_CloudService 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.CloudService'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_CognitiveServices 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.CognitiveServices'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Compute 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Compute'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ConfidentialLedger 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ConfidentialLedger'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ContainerInstance 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ContainerInstance'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ContainerRegistry 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ContainerRegistry'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_CosmosDB 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.CosmosDB'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_DataBoxEdge 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataBoxEdge'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Databricks 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Databricks'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_DataFactory 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataFactory'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_DataLakeAnalytics 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataLakeAnalytics'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_DataLakeStore 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataLakeStore'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_DataProtection 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataProtection'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_DataShare 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataShare'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_DeploymentManager 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DeploymentManager'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_DesktopVirtualization 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DesktopVirtualization'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_DevCenter 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DevCenter'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_DevTestLabs 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DevTestLabs'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Dns 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Dns'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_EventGrid 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.EventGrid'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_EventHub 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.EventHub'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_FrontDoor 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.FrontDoor'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Functions 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Functions'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_HDInsight 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.HDInsight'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_HealthcareApis 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.HealthcareApis'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_IotHub 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.IotHub'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_KeyVault 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.KeyVault'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Kusto 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Kusto'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_LoadTesting 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.LoadTesting'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_LogicApp 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.LogicApp'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_MachineLearning 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.MachineLearning'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_MachineLearningServices 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.MachineLearningServices'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Maintenance 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Maintenance'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ManagedServiceIdentity 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ManagedServiceIdentity'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ManagedServices 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ManagedServices'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_MarketplaceOrdering 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.MarketplaceOrdering'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Media 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Media'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Migrate 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Migrate'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Monitor 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Monitor'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_MySql 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.MySql'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Network 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Network'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_NetworkCloud 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.NetworkCloud'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_NotificationHubs 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.NotificationHubs'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_OperationalInsights 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.OperationalInsights'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_PolicyInsights 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.PolicyInsights'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_PostgreSql 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.PostgreSql'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_PowerBIEmbedded 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.PowerBIEmbedded'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_PrivateDns 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.PrivateDns'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_RecoveryServices 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.RecoveryServices'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_RedisCache 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.RedisCache'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_RedisEnterpriseCache 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.RedisEnterpriseCache'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Relay 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Relay'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ResourceMover 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ResourceMover'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Resources 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Resources'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Security 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Security'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_SecurityInsights 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.SecurityInsights'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ServiceBus 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ServiceBus'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_ServiceFabric 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ServiceFabric'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_SignalR 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.SignalR'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Sql 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Sql'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_SqlVirtualMachine 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.SqlVirtualMachine'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_StackHCI 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.StackHCI'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Storage 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Storage'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_StorageMover 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.StorageMover'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_StorageSync 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.StorageSync'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_StreamAnalytics 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.StreamAnalytics'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Support 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Support'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Synapse 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Synapse'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_TrafficManager 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.TrafficManager'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Az_Websites 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Websites'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_modules_automationAccounts_aa_avd_sage50_name_Azure 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Azure'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Azure_Storage 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Azure.Storage'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_AzureRM_Automation 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'AzureRM.Automation'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_AzureRM_Compute 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'AzureRM.Compute'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_AzureRM_Profile 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'AzureRM.Profile'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_AzureRM_Resources 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'AzureRM.Resources'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_AzureRM_Sql 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'AzureRM.Sql'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_AzureRM_Storage 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'AzureRM.Storage'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_ComputerManagementDsc 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'ComputerManagementDsc'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_GPRegistryPolicyParser 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'GPRegistryPolicyParser'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Microsoft_PowerShell_Core 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Microsoft.PowerShell.Core'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Microsoft_PowerShell_Diagnostics 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Microsoft.PowerShell.Diagnostics'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Microsoft_PowerShell_Management 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Microsoft.PowerShell.Management'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Microsoft_PowerShell_Security 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Microsoft.PowerShell.Security'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Microsoft_PowerShell_Utility 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Microsoft.PowerShell.Utility'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Microsoft_WSMan_Management 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Microsoft.WSMan.Management'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_Orchestrator_AssetManagement_Cmdlets 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Orchestrator.AssetManagement.Cmdlets'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_PSDscResources 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'PSDscResources'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_SecurityPolicyDsc 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'SecurityPolicyDsc'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_StateConfigCompositeResources 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'StateConfigCompositeResources'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_xDSCDomainjoin 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'xDSCDomainjoin'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_xPowerShellExecutionPolicy 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'xPowerShellExecutionPolicy'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_xRemoteDesktopAdmin 'Microsoft.Automation/automationAccounts/modules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'xRemoteDesktopAdmin'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Accounts 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Accounts'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Advisor 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Advisor'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Aks 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Aks'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_AnalysisServices 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.AnalysisServices'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ApiManagement 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ApiManagement'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_App 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.App'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_AppConfiguration 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.AppConfiguration'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ApplicationInsights 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ApplicationInsights'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ArcResourceBridge 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ArcResourceBridge'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Attestation 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Attestation'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Automanage 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Automanage'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Automation 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Automation'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Batch 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Batch'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Billing 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Billing'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Cdn 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Cdn'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_CloudService 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.CloudService'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_CognitiveServices 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.CognitiveServices'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Compute 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Compute'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ConfidentialLedger 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ConfidentialLedger'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ContainerInstance 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ContainerInstance'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ContainerRegistry 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ContainerRegistry'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_CosmosDB 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.CosmosDB'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_DataBoxEdge 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataBoxEdge'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Databricks 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Databricks'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_DataFactory 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataFactory'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_DataLakeAnalytics 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataLakeAnalytics'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_DataLakeStore 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataLakeStore'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_DataProtection 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataProtection'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_DataShare 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DataShare'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_DeploymentManager 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DeploymentManager'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_DesktopVirtualization 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DesktopVirtualization'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_DevCenter 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DevCenter'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_DevTestLabs 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.DevTestLabs'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Dns 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Dns'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_EventGrid 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.EventGrid'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_EventHub 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.EventHub'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_FrontDoor 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.FrontDoor'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Functions 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Functions'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_HDInsight 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.HDInsight'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_HealthcareApis 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.HealthcareApis'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_IotHub 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.IotHub'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_KeyVault 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.KeyVault'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Kusto 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Kusto'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_LoadTesting 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.LoadTesting'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_LogicApp 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.LogicApp'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_MachineLearning 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.MachineLearning'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_MachineLearningServices 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.MachineLearningServices'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Maintenance 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Maintenance'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ManagedServiceIdentity 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ManagedServiceIdentity'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ManagedServices 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ManagedServices'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_MarketplaceOrdering 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.MarketplaceOrdering'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Media 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Media'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Migrate 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Migrate'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Monitor 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Monitor'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_MySql 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.MySql'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Network 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Network'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_NetworkCloud 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.NetworkCloud'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_NotificationHubs 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.NotificationHubs'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_OperationalInsights 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.OperationalInsights'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_PolicyInsights 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.PolicyInsights'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_PostgreSql 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.PostgreSql'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_PowerBIEmbedded 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.PowerBIEmbedded'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_PrivateDns 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.PrivateDns'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_RecoveryServices 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.RecoveryServices'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_RedisCache 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.RedisCache'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_RedisEnterpriseCache 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.RedisEnterpriseCache'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Relay 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Relay'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ResourceMover 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ResourceMover'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Resources 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Resources'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Security 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Security'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_SecurityInsights 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.SecurityInsights'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ServiceBus 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ServiceBus'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_ServiceFabric 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.ServiceFabric'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_SignalR 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.SignalR'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Sql 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Sql'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_SqlVirtualMachine 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.SqlVirtualMachine'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_StackHCI 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.StackHCI'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Storage 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Storage'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_StorageMover 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.StorageMover'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_StorageSync 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.StorageSync'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_StreamAnalytics 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.StreamAnalytics'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Support 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Support'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Synapse 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Synapse'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_TrafficManager 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.TrafficManager'
  properties: {
    contentLink: {}
  }
}

resource Microsoft_Automation_automationAccounts_powerShell72Modules_automationAccounts_aa_avd_sage50_name_Az_Websites 'Microsoft.Automation/automationAccounts/powerShell72Modules@2023-11-01' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Az.Websites'
  properties: {
    contentLink: {}
  }
}

resource automationAccounts_aa_avd_sage50_name_AzureAutomationTutorialWithIdentity 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'AzureAutomationTutorialWithIdentity'
  location: 'canadaeast'
  properties: {
    runbookType: 'PowerShell'
    logVerbose: false
    logProgress: false
    logActivityTrace: 0
  }
}

resource automationAccounts_aa_avd_sage50_name_AzureAutomationTutorialWithIdentityGraphical 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'AzureAutomationTutorialWithIdentityGraphical'
  location: 'canadaeast'
  properties: {
    runbookType: 'GraphPowerShell'
    logVerbose: false
    logProgress: false
    logActivityTrace: 0
  }
}

resource automationAccounts_aa_avd_sage50_name_Shutdown_AVD_IdleVM 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'Shutdown-AVD-IdleVM'
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par ': 'Solulan'
    'Créé le': '2026-04-20'
  }
  properties: {
    runbookType: 'PowerShell72'
    logVerbose: false
    logProgress: false
    logActivityTrace: 0
  }
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
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

resource automationAccounts_aa_avd_sage50_name_PowerShell_7_1 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
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

resource automationAccounts_aa_avd_sage50_name_PowerShell_7_2 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
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

resource automationAccounts_aa_avd_sage50_name_Python_2_7 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
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

resource automationAccounts_aa_avd_sage50_name_Python_3_10 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
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

resource automationAccounts_aa_avd_sage50_name_Python_3_8 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
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

resource automationAccounts_aa_avd_sage50_name_schedule_avd_check_idle 'Microsoft.Automation/automationAccounts/schedules@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_resource
  name: 'schedule-avd-check-idle'
  properties: {
    description: 'Arrêt de la VM lorsqu\'elle n,est plus utilisée'
    startTime: '2026-04-28T19:00:00-04:00'
    expiryTime: '9999-12-31T18:59:00-05:00'
    interval: 1
    frequency: 'Day'
    timeZone: 'America/Toronto'
  }
}

resource virtualMachines_vm_sage50_0_name_resource 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: virtualMachines_vm_sage50_0_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par ': 'Solulan'
    'Créé le': '2026-04-20'
    'cm-resource-parent': '/subscriptions/46dba69d-6fe1-4f8f-a9f1-52341aa04dd7/resourceGroups/rg-avd-sage50/providers/Microsoft.DesktopVirtualization/hostpools/hp-sage50-prod'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B4s_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'microsoftwindowsdesktop'
        offer: 'office-365'
        sku: 'win11-25h2-avd-m365'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm_sage50_0_name}_OsDisk_1_4f8188b51e2e488ea73f60c6b10f4726'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_sage50_0_name}_OsDisk_1_4f8188b51e2e488ea73f60c6b10f4726'
          )
        }
        deleteOption: 'Detach'
        diskSizeGB: 128
      }
      dataDisks: [
        {
          lun: 0
          name: 'vm-sage50-Data'
          createOption: 'Attach'
          caching: 'None'
          writeAcceleratorEnabled: false
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
            id: resourceId('Microsoft.Compute/disks', 'vm-sage50-Data')
          }
          deleteOption: 'Detach'
          diskSizeGB: 512
          toBeDetached: false
        }
      ]
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_vm_sage50_0_name
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
      adminUsername: 'Adm_Solulan'
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
          id: networkInterfaces_vm_sage50_0_nic_name_resource.id
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

resource virtualMachines_vm_sage50_0_name_enablevmAccess 'Microsoft.Compute/virtualMachines/extensions@2025-04-01' = {
  parent: virtualMachines_vm_sage50_0_name_resource
  name: 'enablevmAccess'
  location: 'canadaeast'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'VMAccessAgent'
    typeHandlerVersion: '2.0'
    settings: {
      userName: 'Adm_Solulan'
    }
    protectedSettings: {}
  }
}

resource virtualMachines_vm_sage50_0_name_Microsoft_PowerShell_DSC 'Microsoft.Compute/virtualMachines/extensions@2025-04-01' = {
  parent: virtualMachines_vm_sage50_0_name_resource
  name: 'Microsoft.PowerShell.DSC'
  location: 'canadaeast'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.73'
    settings: {
      modulesUrl: 'https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.03362.1223.zip'
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      properties: {
        hostPoolName: 'hp-sage50-prod'
        registrationInfoTokenCredential: {
          UserName: 'PLACEHOLDER_DO_NOT_USE'
          Password: 'PrivateSettingsRef:RegistrationInfoToken'
        }
        aadJoin: true
        UseAgentDownloadEndpoint: true
        aadJoinPreview: false
        mdmId: '0000000a-0000-0000-c000-000000000000'
        sessionHostConfigurationLastUpdateTime: ''
      }
    }
    protectedSettings: {}
  }
}

resource applicationgroups_hp_sage50_prod_DAG_name_resource 'Microsoft.DesktopVirtualization/applicationgroups@2026-01-01-preview' = {
  name: applicationgroups_hp_sage50_prod_DAG_name
  location: 'canadaeast'
  tags: {
    'cm-resource-parent': '/subscriptions/46dba69d-6fe1-4f8f-a9f1-52341aa04dd7/resourceGroups/rg-avd-sage50/providers/Microsoft.DesktopVirtualization/hp-sage50-prod'
  }
  kind: 'Desktop'
  properties: {
    hostPoolArmPath: hostpools_hp_sage50_prod_name_resource.id
    description: 'Desktop Application Group created through the Hostpool Wizard'
    friendlyName: 'Default Desktop'
    applicationGroupType: 'Desktop'
  }
}

resource hostpools_hp_sage50_prod_name_vm_sage50_0 'Microsoft.DesktopVirtualization/hostpools/sessionhosts@2026-01-01-preview' = {
  parent: hostpools_hp_sage50_prod_name_resource
  name: 'vm-sage50-0'
  properties: {
    allowNewSession: true
  }
}

resource workspaces_ws_sage50_name_resource 'Microsoft.DesktopVirtualization/workspaces@2026-01-01-preview' = {
  name: workspaces_ws_sage50_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par ': 'Solulan'
    'Créé le': '2026-04-17'
  }
  properties: {
    deploymentScope: 'Geographical'
    publicNetworkAccess: 'Enabled'
    description: 'Espace de travail (workspace) pour le projet Sage 50.'
    applicationGroupReferences: [
      applicationgroups_hp_sage50_prod_DAG_name_resource.id
    ]
  }
}

resource bastionHosts_vnet_sage50_prod_bastion_name_resource 'Microsoft.Network/bastionHosts@2025-05-01' = {
  name: bastionHosts_vnet_sage50_prod_bastion_name
  location: 'canadaeast'
  sku: {
    name: 'Developer'
  }
  properties: {
    dnsName: 'omnibrain.canadaeast.bastionglobal.azure.com'
    scaleUnits: 2
    virtualNetwork: {
      id: virtualNetworks_vnet_sage50_prod_name_resource.id
    }
    ipConfigurations: []
  }
}

resource natGateways_ng_sage50_prod_name_resource 'Microsoft.Network/natGateways@2025-05-01' = {
  name: natGateways_ng_sage50_prod_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par ': 'Solulan'
    'Créé le': '2026-04-20'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: publicIPAddresses_avd_sage50_public_ip_name_resource.id
      }
    ]
  }
}

resource networkSecurityGroups_nsg_sage50_prod_name_Allow_Inbound_Admin_Management_RDP 'Microsoft.Network/networkSecurityGroups/securityRules@2025-05-01' = {
  name: '${networkSecurityGroups_nsg_sage50_prod_name}/Allow_Inbound_Admin_Management_RDP'
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
    networkSecurityGroups_nsg_sage50_prod_name_resource
  ]
}

resource privateDnsZones_privatelink_file_core_windows_net_name_stsage50prod 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'stsage50prod'
  properties: {
    metadata: {
      creator: 'created by private endpoint stsage50prod-pe with resource guid 027d9915-e5df-40ad-868c-792e6673c303'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.1.0.5'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_file_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource publicIPAddresses_avd_sage50_public_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: publicIPAddresses_avd_sage50_public_ip_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par ': 'Solulan'
    'Créé le': '2026-04-20'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    natGateway: {
      id: natGateways_ng_sage50_prod_name_resource.id
    }
    ipAddress: '20.175.75.109'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'Disabled'
    }
  }
}

resource virtualNetworks_vnet_sage50_prod_name_AzureBastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_sage50_prod_name}/AzureBastionSubnet'
  properties: {
    addressPrefixes: [
      '10.1.1.0/26'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_sage50_prod_name_resource
  ]
}

resource vaults_rsv_avd_sage50_name_DefaultPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-08-01' = {
  parent: vaults_rsv_avd_sage50_name_resource
  name: 'DefaultPolicy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V1'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2026-04-21T04:00:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2026-04-21T04:00:00Z'
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

resource vaults_rsv_avd_sage50_name_EnhancedPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-08-01' = {
  parent: vaults_rsv_avd_sage50_name_resource
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
        scheduleWindowStartTime: '2026-05-02T02:00:00Z'
        scheduleWindowDuration: 24
      }
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2026-05-02T02:00:00Z'
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
          '2026-05-02T02:00:00Z'
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
          '2026-05-02T02:00:00Z'
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

resource vaults_rsv_avd_sage50_name_HourlyLogBackup 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-08-01' = {
  parent: vaults_rsv_avd_sage50_name_resource
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
            '2026-04-21T04:00:00Z'
          ]
          scheduleWeeklyFrequency: 0
        }
        retentionPolicy: {
          retentionPolicyType: 'LongTermRetentionPolicy'
          dailySchedule: {
            retentionTimes: [
              '2026-04-21T04:00:00Z'
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

resource vaults_rsv_avd_sage50_name_defaultAlertSetting 'Microsoft.RecoveryServices/vaults/replicationAlertSettings@2025-08-01' = {
  parent: vaults_rsv_avd_sage50_name_resource
  name: 'defaultAlertSetting'
  properties: {
    sendToOwners: 'DoNotSend'
    customEmailAddresses: []
  }
}

resource vaults_rsv_avd_sage50_name_default 'Microsoft.RecoveryServices/vaults/replicationVaultSettings@2025-08-01' = {
  parent: vaults_rsv_avd_sage50_name_resource
  name: 'default'
  properties: {}
}

resource storageAccounts_stsage50prod_name_default 'Microsoft.Storage/storageAccounts/fileServices@2025-08-01' = {
  parent: storageAccounts_stsage50prod_name_resource
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
      days: 7
    }
  }
}

resource storageAccounts_stsage50prod_name_storageAccounts_stsage50prod_name_e0c9e983_a1fd_408c_a299_a079e259adbc 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2025-08-01' = {
  parent: storageAccounts_stsage50prod_name_resource
  name: '${storageAccounts_stsage50prod_name}.e0c9e983-a1fd-408c-a299-a079e259adbc'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_AuditPolicyDsc 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'AuditPolicyDsc'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_Azure 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'Azure'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_Azure_Storage 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'Azure.Storage'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_AzureRM_Automation 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'AzureRM.Automation'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_AzureRM_Compute 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'AzureRM.Compute'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_AzureRM_Profile 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'AzureRM.Profile'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_AzureRM_Resources 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'AzureRM.Resources'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_AzureRM_Sql 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'AzureRM.Sql'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_AzureRM_Storage 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'AzureRM.Storage'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_ComputerManagementDsc 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'ComputerManagementDsc'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_GPRegistryPolicyParser 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'GPRegistryPolicyParser'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_Microsoft_PowerShell_Core 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'Microsoft.PowerShell.Core'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_Microsoft_PowerShell_Diagnostics 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'Microsoft.PowerShell.Diagnostics'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_Microsoft_PowerShell_Management 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'Microsoft.PowerShell.Management'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_Microsoft_PowerShell_Security 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'Microsoft.PowerShell.Security'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_Microsoft_PowerShell_Utility 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'Microsoft.PowerShell.Utility'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_Microsoft_WSMan_Management 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'Microsoft.WSMan.Management'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_Orchestrator_AssetManagement_Cmdlets 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'Orchestrator.AssetManagement.Cmdlets'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_7_1_Orchestrator_AssetManagement_Cmdlets 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_7_1
  name: 'Orchestrator.AssetManagement.Cmdlets'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_PSDscResources 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'PSDscResources'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_SecurityPolicyDsc 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'SecurityPolicyDsc'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_StateConfigCompositeResources 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'StateConfigCompositeResources'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_xDSCDomainjoin 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'xDSCDomainjoin'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_xPowerShellExecutionPolicy 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'xPowerShellExecutionPolicy'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource automationAccounts_aa_avd_sage50_name_PowerShell_5_1_xRemoteDesktopAdmin 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = {
  parent: automationAccounts_aa_avd_sage50_name_PowerShell_5_1
  name: 'xRemoteDesktopAdmin'
  location: 'canadaeast'
  properties: {
    contentLink: {}
  }
  dependsOn: [
    automationAccounts_aa_avd_sage50_name_resource
  ]
}

resource networkInterfaces_vm_sage50_0_nic_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_vm_sage50_0_nic_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par ': 'Solulan'
    'Créé le': '2026-04-20'
    'cm-resource-parent': '/subscriptions/46dba69d-6fe1-4f8f-a9f1-52341aa04dd7/resourcegroups/rg-avd-sage50/providers/Microsoft.DesktopVirtualization/hostpools/hp-sage50-prod'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        id: '${networkInterfaces_vm_sage50_0_nic_name_resource.id}/ipConfigurations/ipconfig'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.1.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet_sage50_prod_name_snet_sage50_subnet.id
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
    networkSecurityGroup: {
      id: networkSecurityGroups_nsg_sage50_prod_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource privateDnsZones_privatelink_file_core_windows_net_name_mx3vzt6ydzys4 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'mx3vzt6ydzys4'
  location: 'global'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_vnet_sage50_prod_name_resource.id
    }
  }
}

resource privateEndpoints_stsage50prod_pe_name_resource 'Microsoft.Network/privateEndpoints@2025-05-01' = {
  name: privateEndpoints_stsage50prod_pe_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par': 'Solulan'
    'Créé le': '2026-04-22'
  }
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_stsage50prod_pe_name
        id: '${privateEndpoints_stsage50prod_pe_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_stsage50prod_pe_name}'
        properties: {
          privateLinkServiceId: storageAccounts_stsage50prod_name_resource.id
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
    customNetworkInterfaceName: '${privateEndpoints_stsage50prod_pe_name}-nic'
    subnet: {
      id: virtualNetworks_vnet_sage50_prod_name_snet_sage50_subnet.id
    }
    ipConfigurations: []
    customDnsConfigs: []
    ipVersionType: 'IPv4'
  }
}

resource privateEndpoints_stsage50prod_pe_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2025-05-01' = {
  name: '${privateEndpoints_stsage50prod_pe_name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-file-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_file_core_windows_net_name_resource.id
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints_stsage50prod_pe_name_resource
  ]
}

resource virtualNetworks_vnet_sage50_prod_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_vnet_sage50_prod_name
  location: 'canadaeast'
  tags: {
    Projet: 'AVD Sage 50'
    'Créé par ': 'Solulan'
    'Créé le': '2026-04-17'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    encryption: {
      enabled: true
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'snet-sage50-subnet'
        id: virtualNetworks_vnet_sage50_prod_name_snet_sage50_subnet.id
        properties: {
          addressPrefixes: [
            '10.1.0.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_nsg_sage50_prod_name_resource.id
          }
          natGateway: {
            id: natGateways_ng_sage50_prod_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'AzureBastionSubnet'
        id: virtualNetworks_vnet_sage50_prod_name_AzureBastionSubnet.id
        properties: {
          addressPrefixes: [
            '10.1.1.0/26'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource storageAccounts_stsage50prod_name_default_sage50_migration 'Microsoft.Storage/storageAccounts/fileServices/shares@2025-08-01' = {
  parent: storageAccounts_stsage50prod_name_default
  name: 'sage50-migration'
  properties: {
    provisionedIops: 1205
    provisionedBandwidthMibps: 81
    shareQuota: 1024
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_stsage50prod_name_resource
  ]
}

resource virtualNetworks_vnet_sage50_prod_name_snet_sage50_subnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_sage50_prod_name}/snet-sage50-subnet'
  properties: {
    addressPrefixes: [
      '10.1.0.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_nsg_sage50_prod_name_resource.id
    }
    natGateway: {
      id: natGateways_ng_sage50_prod_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_sage50_prod_name_resource
  ]
}
