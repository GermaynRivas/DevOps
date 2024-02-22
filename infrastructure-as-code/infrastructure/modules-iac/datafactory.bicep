param dataFactoryName string
param location string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  tags:{
    Unidad: 'Análisis'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}