//Create Storage Account for Machine Learning
param location string = resourceGroup().location
param accountName string
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: accountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags:{
    Unidad: 'Análisis'
  }
  properties: {
    accessTier: 'Hot'
  }
}

output storageAccountid string = storageAccount.id
