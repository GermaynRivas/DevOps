param(
    [string] $ResourceGroupName,
    [string] $dataLakeName,
    [string] $keyVaultName,
    [string] $dataFactoryName,
    [string] $secretBDSQL,
    [string] $secretServerSQL,
    [string] $secretHTTP,
    [string] $keyVaultNameDev,
    [string] $resourceGroupDev,
    [string] $dataLakeNameDev
)

$ErrorActionPreference = "Stop"

$context = Get-AzContext
Write-Host "Getting Service Principal information..." -ForegroundColor Green
$servicePrincipal = Get-AzADServicePrincipal -ApplicationId $context.Account.Id

Write-Host "Reading the Key Vault..." -ForegroundColor Green
$kv = Get-AzKeyVault -VaultName $KeyVaultName

#Dar permisos al usuario sobre el Keyvault de Producción
Write-Host "Adding permissions to user on Key Vault..." -ForegroundColor Green
$userPermissions = $kv.AccessPolicies | Where-Object { $_.ObjectId -eq $servicePrincipal.Id }
$secretPermissions = $userPermissions.PermissionsToSecrets

#Dar permisos de directiva a la Aplicación
Write-Host "Add the Key Vault Secret..."
Set-AzKeyVaultAccessPolicy -VaultName $KeyVaultName -ObjectId $servicePrincipal.Id -PermissionsToKeys 'all' -PermissionsToSecrets 'all' -PermissionsToCertificates 'all'

Write-Host "Add the Key Vault Secret..."
(Get-AzKeyVault -VaultName $KeyVaultName).AccessPolicies

Write-Host "Add the Key Vault Secret..."

$ctx = New-AzStorageContext -StorageAccountName $dataLakeName -UseConnectedAccount

#New-AzStorageContainer -Name "bronce" -Context $ctx
#Set-AzStorageContainerAcl -Container "bronce" -Permission Container -Context $ctx
#New-AzStorageContainer -Name "plata" -Context $ctx
#Set-AzStorageContainerAcl -Container "plata" -Permission Container -Context $ctx
#New-AzStorageContainer -Name "oro" -Context $ctx
#Set-AzStorageContainerAcl -Container "oro" -Permission Container -Context $ctx

#Crear un secreto con la Key del DataLakeProd
Write-Host "Add the Key Vault Secret..."
$Name = "KeydataLakeName"
$ContosoStoreKey = (Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $dataLakeName).Value[0]
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $Name -SecretValue $(ConvertTo-SecureString $ContosoStoreKey -AsPlainText)
Write-Host "Get the Key1..." $ContosoStoreKey
$Secret = ConvertTo-SecureString -String $ContosoStoreKey -AsPlainText -Force 
Write-Host "Secret Key1..." $Secret

#Crear un secreto con el nombre del DataLakeProd
Write-Host "Add the Key Vault Secret..."
$dataLakeNameString = "dataLakeName"
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $dataLakeNameString -SecretValue $(ConvertTo-SecureString $dataLakeName -AsPlainText)

#Crear un secreto con el nombre del DataLakeProd
Write-Host "Add the Key Vault Secret..."
$String = "sqldb-lab-dev"
$secretText = Get-AzKeyVaultSecret -VaultName $keyVaultNameDev -Name $String
$secret = $secretText.SecretValue | ConvertFrom-SecureString -AsPlainText
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $String -SecretValue $(ConvertTo-SecureString $secret -AsPlainText)



