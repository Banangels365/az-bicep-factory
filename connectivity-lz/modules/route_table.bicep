// connectivity-lz/modules/route_table.bicep
// Route Table module with custom routes

@description('Route Table name')
param routeTableName string

@description('Location for the route table')
param location string

@description('Disable BGP route propagation')
param disableBgpRoutePropagation bool = false

@description('Routes to create in the route table')
param routes array = []

@description('Tags to apply to the route table')
param tags object = {}

// Route Table Resource
resource routeTable 'Microsoft.Network/routeTables@2023-09-01' = {
  name: routeTableName
  location: location == 'caea' ? 'canadaeast' : 'canadacentral'
  tags: tags
  properties: {
    disableBgpRoutePropagation: disableBgpRoutePropagation
    routes: [
      for route in routes: {
        name: route.name
        properties: {
          addressPrefix: route.addressPrefix
          nextHopType: route.nextHopType
          nextHopIpAddress: route.?nextHopIpAddress
        }
      }
    ]
  }
}

// Outputs
@description('Route Table resource ID')
output routeTableId string = routeTable.id

@description('Route Table name')
output routeTableName string = routeTable.name

@description('Routes in the table')
output routes array = routeTable.properties.routes
