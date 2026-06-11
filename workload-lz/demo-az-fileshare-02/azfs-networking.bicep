param publicIPAddresses_PIP_VPN_Gateway_name string = 'PIP-VPN-Gateway'
param virtualNetworks_VNET_DEMO_AZFS_Project_name string = 'VNET-DEMO-AZFS-Project'
param networkSecurityGroups_NSG_DEMO_AZFS_Project_name string = 'NSG-DEMO-AZFS-Project'
param virtualNetworkGateways_VPN_Gateway_Demo_AZFS_name string = 'VPN-Gateway-Demo-AZFS'
param privateDnsZones_privatelink_file_core_windows_net_name string = 'privatelink.file.core.windows.net'

resource networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroups_NSG_DEMO_AZFS_Project_name
  location: 'canadacentral'
  properties: {
    securityRules: [
      {
        name: 'Allow-Inbound-RDP-from-MyIPAddress-to-VM'
        id: networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inbound_RDP_from_MyIPAddress_to_VM.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '76.65.96.184'
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
      {
        name: 'Allow-Inbound-ICMPv4-From-VPNClients'
        id: networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inbound_ICMPv4_From_VPNClients.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'ICMP'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '172.16.0.0/24'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-Inbound-SMB-From-VPNClients'
        id: networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inbound_SMB_From_VPNClients.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '445'
          sourceAddressPrefix: '10.0.0.0/24'
          destinationAddressPrefix: 'Storage'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-Inbound-TCP-DNS-From-VPNClients'
        id: networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inbound_TCP_DNS_From_VPNClients.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: '172.16.0.0/24'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-Inbound-UDP-DNS-From-VPNClients'
        id: networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inbound_UDP_DNS_From_VPNClients.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'UDP'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: '172.16.0.0/24'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 140
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-Inboud-Kerberos-From-VPNClients'
        id: networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inboud_Kerberos_From_VPNClients.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '88'
          sourceAddressPrefix: '172.16.0.0/24'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 150
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
  properties: {}
}

resource publicIPAddresses_PIP_VPN_Gateway_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_PIP_VPN_Gateway_name
  location: 'canadacentral'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    ipAddress: '4.229.154.4'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inboud_Kerberos_From_VPNClients 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_DEMO_AZFS_Project_name}/Allow-Inboud-Kerberos-From-VPNClients'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '88'
    sourceAddressPrefix: '172.16.0.0/24'
    destinationAddressPrefix: 'VirtualNetwork'
    access: 'Allow'
    priority: 150
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource
  ]
}

resource networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inbound_ICMPv4_From_VPNClients 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_DEMO_AZFS_Project_name}/Allow-Inbound-ICMPv4-From-VPNClients'
  properties: {
    protocol: 'ICMP'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '172.16.0.0/24'
    destinationAddressPrefix: 'VirtualNetwork'
    access: 'Allow'
    priority: 120
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource
  ]
}

resource networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inbound_RDP_from_MyIPAddress_to_VM 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_DEMO_AZFS_Project_name}/Allow-Inbound-RDP-from-MyIPAddress-to-VM'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '76.65.96.184'
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
    networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource
  ]
}

resource networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inbound_SMB_From_VPNClients 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_DEMO_AZFS_Project_name}/Allow-Inbound-SMB-From-VPNClients'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '445'
    sourceAddressPrefix: '10.0.0.0/24'
    destinationAddressPrefix: 'Storage'
    access: 'Allow'
    priority: 110
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource
  ]
}

resource networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inbound_TCP_DNS_From_VPNClients 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_DEMO_AZFS_Project_name}/Allow-Inbound-TCP-DNS-From-VPNClients'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '53'
    sourceAddressPrefix: '172.16.0.0/24'
    destinationAddressPrefix: 'VirtualNetwork'
    access: 'Allow'
    priority: 130
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource
  ]
}

resource networkSecurityGroups_NSG_DEMO_AZFS_Project_name_Allow_Inbound_UDP_DNS_From_VPNClients 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_DEMO_AZFS_Project_name}/Allow-Inbound-UDP-DNS-From-VPNClients'
  properties: {
    protocol: 'UDP'
    sourcePortRange: '*'
    destinationPortRange: '53'
    sourceAddressPrefix: '172.16.0.0/24'
    destinationAddressPrefix: 'VirtualNetwork'
    access: 'Allow'
    priority: 140
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource
  ]
}

resource privateDnsZones_privatelink_file_core_windows_net_name_sademoazfsproject 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'sademoazfsproject'
  properties: {
    metadata: {
      creator: 'created by private endpoint Demo-AZFS-StorageAccount_PE with resource guid 42b0a9c4-c85c-4e86-81c5-a62b8890a2a9'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.2.4'
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

resource virtualNetworks_VNET_DEMO_AZFS_Project_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworks_VNET_DEMO_AZFS_Project_name
  location: 'canadacentral'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    encryption: {
      enabled: true
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    dhcpOptions: {
      dnsServers: [
        '10.0.0.4'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_VNET_DEMO_AZFS_Project_name_GatewaySubnet.id
        properties: {
          addressPrefixes: [
            '10.0.1.0/27'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'AzureFiles'
        id: virtualNetworks_VNET_DEMO_AZFS_Project_name_AzureFiles.id
        properties: {
          addressPrefixes: [
            '10.0.2.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                'canadacentral'
                'canadaeast'
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
        name: 'SubnetServers'
        id: virtualNetworks_VNET_DEMO_AZFS_Project_name_SubnetServers.id
        properties: {
          addressPrefixes: [
            '10.0.0.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                'canadacentral'
                'canadaeast'
              ]
            }
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

resource virtualNetworks_VNET_DEMO_AZFS_Project_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_VNET_DEMO_AZFS_Project_name}/GatewaySubnet'
  properties: {
    addressPrefixes: [
      '10.0.1.0/27'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_VNET_DEMO_AZFS_Project_name_resource
  ]
}

resource privateDnsZones_privatelink_file_core_windows_net_name_cri4eik7rivo4 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'cri4eik7rivo4'
  location: 'global'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_VNET_DEMO_AZFS_Project_name_resource.id
    }
  }
}

resource virtualNetworkGateways_VPN_Gateway_Demo_AZFS_name_resource 'Microsoft.Network/virtualNetworkGateways@2024-07-01' = {
  name: virtualNetworkGateways_VPN_Gateway_Demo_AZFS_name
  location: 'canadacentral'
  properties: {
    enablePrivateIpAddress: false
    virtualNetworkGatewayMigrationStatus: {
      state: 'None'
      phase: 'None'
    }
    ipConfigurations: [
      {
        name: 'default'
        id: '${virtualNetworkGateways_VPN_Gateway_Demo_AZFS_name_resource.id}/ipConfigurations/default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_PIP_VPN_Gateway_name_resource.id
          }
          subnet: {
            id: virtualNetworks_VNET_DEMO_AZFS_Project_name_GatewaySubnet.id
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'VpnGw1AZ'
      tier: 'VpnGw1AZ'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    enableHighBandwidthVpnGateway: false
    activeActive: false
    vpnClientConfiguration: {
      vpnClientAddressPool: {
        addressPrefixes: [
          '172.16.0.0/24'
        ]
      }
      vpnClientProtocols: [
        'OpenVPN'
      ]
      vpnAuthenticationTypes: [
        'AAD'
      ]
      vpnClientRootCertificates: []
      vpnClientRevokedCertificates: []
      vngClientConnectionConfigurations: []
      radiusServers: []
      vpnClientIpsecPolicies: []
      aadTenant: 'https://login.microsoftonline.com/ec11ba4c-e4cc-4358-95f4-be3f5b30cf99/'
      aadAudience: '41b23e61-6c1e-4545-b367-cd054e0ed4b4'
      aadIssuer: 'https://sts.windows.net/ec11ba4c-e4cc-4358-95f4-be3f5b30cf99/'
    }
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '10.0.1.30'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '${virtualNetworkGateways_VPN_Gateway_Demo_AZFS_name_resource.id}/ipConfigurations/default'
          customBgpIpAddresses: []
        }
      ]
    }
    customRoutes: {
      addressPrefixes: []
    }
    vpnGatewayGeneration: 'Generation1'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}

resource virtualNetworks_VNET_DEMO_AZFS_Project_name_AzureFiles 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_VNET_DEMO_AZFS_Project_name}/AzureFiles'
  properties: {
    addressPrefixes: [
      '10.0.2.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource.id
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
        locations: [
          'canadacentral'
          'canadaeast'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_VNET_DEMO_AZFS_Project_name_resource
  ]
}

resource virtualNetworks_VNET_DEMO_AZFS_Project_name_SubnetServers 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_VNET_DEMO_AZFS_Project_name}/SubnetServers'
  properties: {
    addressPrefixes: [
      '10.0.0.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_DEMO_AZFS_Project_name_resource.id
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
        locations: [
          'canadacentral'
          'canadaeast'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_VNET_DEMO_AZFS_Project_name_resource
  ]
}
