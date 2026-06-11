// connectivity-lz/modules/route_table.bicep
// Route Table module with custom routes

@description('Nom de la table de routage')
param routeTableName string

@description('Région pour la table de routage')
param location string

@description('Désactiver la propagation des routes BGP')
param disableBgpRoutePropagation bool

@description('Routes à créer dans la table de routage')
param routes array = []

@description('Tags à appliquer à la table de routage')
param tags object = {}

// Variable pour résoudre la location en fonction de l'abréviation
var resolvedLocation = location == 'caea' ? 'canadaeast' : 'canadacentral'

// Route Table Resource
resource routeTable 'Microsoft.Network/routeTables@2023-09-01' = {
  name: routeTableName
  location: resolvedLocation
  tags: tags
  properties: {
    disableBgpRoutePropagation: disableBgpRoutePropagation
    routes: [
      for route in routes: {
        name: route.name
        properties: union(
          {
            addressPrefix: route.addressPrefix
            nextHopType: route.nextHopType
          },
          !empty(route.?nextHopIpAddress ?? '') ? { nextHopIpAddress: route.nextHopIpAddress } : {}
        )
      }
    ]
  }
}

// Outputs
@description('ID de la table de routage')
output routeTableId string = routeTable.id

@description('Nom de la table de routage')
output routeTableName string = routeTable.name

@description('Routes définies dans la table de routage')
output routes array = routeTable.properties.routes
