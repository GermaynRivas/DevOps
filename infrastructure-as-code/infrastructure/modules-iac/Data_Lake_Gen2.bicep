param accountDataLakeName string
param location string

resource storageAccountDataLake 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: accountDataLakeName
  location: location
  sku: {
    name: 'Standard_RAGRS'
  }
  kind: 'StorageV2'
  tags:{
    Unidad: 'Análisis'
  }
  properties: {
    isHnsEnabled: true
    accessTier: 'Hot'
  }
}

var keysObj = listKeys(resourceId('Microsoft.Storage/storageAccounts', accountDataLakeName), '2021-04-01')
output key1 string = keysObj.keys[0].value
output key2 string = keysObj.keys[1].value