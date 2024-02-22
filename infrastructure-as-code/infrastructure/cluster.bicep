param location string = resourceGroup().location
param wsDatabricksName string

//Create Databricks Workspace
module wsDatabricks './modules-iac/Databricks.bicep' = {
  name: wsDatabricksName
  params: {
    wsDatabricksName: wsDatabricksName
    location: location
  }
}

output databricksWorkspaceUrl string = wsDatabricks.outputs.adbWorkspaceUrl