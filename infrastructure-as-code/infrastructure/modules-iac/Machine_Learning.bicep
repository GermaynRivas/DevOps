//Create Machine Learning (Workspaces)
param location string = resourceGroup().location
param machineLearningName string
param containerRegistryid string
param keyVaultid string
param applicationInsightsid string
param storageAccountid string

resource machineLearning 'Microsoft.MachineLearningServices/workspaces@2021-07-01' = {
  name: machineLearningName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  tags:{
    Unidad: 'Análisis'
  }
  identity:{
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: machineLearningName
    storageAccount: storageAccountid
    keyVault: keyVaultid
    containerRegistry: containerRegistryid
    applicationInsights: applicationInsightsid
    hbiWorkspace: false
  }
}