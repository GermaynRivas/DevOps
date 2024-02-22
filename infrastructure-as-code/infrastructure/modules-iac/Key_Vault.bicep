//Create Key Vault
param keyVaultName string
param location string = resourceGroup().location
param tenantId string
param objectId string

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  tags: {
    Unidad: 'Análisis'
  }
  properties:{
    tenantId: tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: [
      {
        objectId: objectId
        tenantId: tenantId
        permissions: {
          secrets: [
            'list'
            'get'
            'set'
          ]
        }
      }
    ]
  }
}

output keyVaultid string = keyVault.id
output keyvaultUri string = keyVault.properties.vaultUri
