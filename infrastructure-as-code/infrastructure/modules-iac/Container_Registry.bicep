param containerRegistryName string
param location string = resourceGroup().location

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
name: containerRegistryName
location: location
sku: {
  name: 'Basic'
 }
tags:{
    Unidad: 'Análisis'
  }
  properties: {
    adminUserEnabled: true
  }
}

output containerRegistryid string = containerRegistry.id
