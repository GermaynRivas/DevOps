//Create Application Insights
param location string = resourceGroup().location
param applicationInsightsName string
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
  tags: {
    Unidad: 'Análisis'
  }
}

output applicationInsightsid string = applicationInsights.id
