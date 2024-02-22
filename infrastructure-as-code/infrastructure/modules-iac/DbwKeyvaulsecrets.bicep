param keyVaultName string
param SecretName string

@secure()
param Keyprod string

resource keyVaultAddSecretsStg1 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
  name: '${keyVaultName}/${SecretName}'
  properties: {
    value: Keyprod
  }
}