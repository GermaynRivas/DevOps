param location string = resourceGroup().location
param tenantId string = subscription().tenantId
param accountDataLakeName string
param wsDatabricksName string
param dataFactoryName string
param keyVaultName string
param accountName string
param applicationInsightsName string
param containerRegistryName string
param machineLearningName string
param objectId string

//Create Key Vault
module keyVault './modules-iac/Key_Vault.bicep' = {
  name: keyVaultName
  params: {
    keyVaultName: keyVaultName
    location: location
    tenantId: tenantId
    objectId: objectId
  }
}

//Create Data Lake (Storage Accounts)
module storageAccountDataLake './modules-iac/Data_Lake_Gen2.bicep' = {
  name: accountDataLakeName
  params: {
    accountDataLakeName: accountDataLakeName
    location: location
  }
}

//Create Data Factory
module DataFactory './modules-iac/datafactory.bicep' = {
  name: dataFactoryName
  params: {
    dataFactoryName: dataFactoryName
    location: location
  }
}

//Create Databricks Workspace
module wsDatabricks './modules-iac/Databricks.bicep' = {
  name: wsDatabricksName
  params: {
    wsDatabricksName: wsDatabricksName
    location: location
  }
}

output databricksWorkspaceUrl string = wsDatabricks.outputs.adbWorkspaceUrl

//Create Container Registry
/*module ContainerRegistry './modules-iac/Container_Registry.bicep' = {
  name: containerRegistryName
  params: {
    containerRegistryName: containerRegistryName
    location: location
  }
}

//Create Storage Account
module storageAccount './modules-iac/Storage_Accounts.bicep' = {
  name: accountName
  params: {
    accountName: accountName
    location: location
  }
}

//Create Application Insights
module applicationInsights './modules-iac/Aplication_Insights.bicep' = {
  name: applicationInsightsName
  params: {
    applicationInsightsName: applicationInsightsName
    location: location
  }
}

//Create Machine Learning (Workspaces)
module machineLearning './modules-iac/Machine_Learning.bicep' = {
  name: machineLearningName
  params: {
    machineLearningName: machineLearningName
    location: location
    storageAccountid: storageAccount.outputs.storageAccountid
    keyVaultid: keyVault.outputs.keyVaultid
    containerRegistryid: ContainerRegistry.outputs.containerRegistryid
    applicationInsightsid: applicationInsights.outputs.applicationInsightsid
  }
}*/