param wsDatabricksName string
param location string
var managedResourceGroupName = 'databricks-rg-${wsDatabricksName}-${uniqueString(wsDatabricksName, resourceGroup().id)}'

resource wsDatabricks 'Microsoft.Databricks/workspaces@2018-04-01' = {
  name: wsDatabricksName
  location: location
  tags:{
    Unidad: 'Análisis'
  }
  sku: {
    name: 'standard'
  }
  properties: {
    managedResourceGroupId: managedResourceGroup.id
    parameters: {
      enableNoPublicIp: {
        value: false
      }
    }
  }
}

//Create Managed Resource Group for Databricks
resource managedResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: managedResourceGroupName
}

output adbWorkspaceId string = wsDatabricks.id
output adbWorkspaceUrl string = wsDatabricks.properties.workspaceUrl