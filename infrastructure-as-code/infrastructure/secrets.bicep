param accountDataLakeName string
param wsDatabricksName string
param keyVaultName string
param location string
param DBW_TOKEN string

//Create Data Lake (Storage Accounts)
module storageAccountDataLake './modules-iac/Data_Lake_Gen2.bicep' = {
  name: accountDataLakeName
  params: {
    accountDataLakeName: accountDataLakeName
    location: location
  }
}

//Create Key Vault Secrets
module secretVault './modules-iac/keyvaultsecrets.bicep' = {
  name: 'KeyVaultSecrets'
  params: {
    keyVaultName: keyVaultName
    SecretName: accountDataLakeName
    Keyprod: storageAccountDataLake.outputs.key1
  }
}

//Create Key Vault Secrets
module DbwSecretVault './modules-iac/DbwKeyvaulsecrets.bicep' = {
  name: 'DbwKeyVaultSecrets'
  params: {
    keyVaultName: keyVaultName
    SecretName: wsDatabricksName
    Keyprod: DBW_TOKEN
  }
}