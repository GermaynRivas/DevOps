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

#Dar permisos de directiva al Datafactory
Write-Host "Add the Key Vault Secret..."
$datafactory = Get-AzDataFactoryV2 -ResourceGroupName $ResourceGroupName -Name $dataFactoryName
Set-AzKeyVaultAccessPolicy -VaultName $KeyVaultName -ObjectId $datafactory.Identity.PrincipalId -PermissionsToSecrets get,List,Recover,set -BypassObjectIdValidation

Write-Host "Add the Key Vault Secret..."
(Get-AzKeyVault -VaultName $KeyVaultName).AccessPolicies

Write-Host "Add the Key Vault Secret..."

#Crear un secreto con la cadena de conexión del DataLakeDev
Write-Host "Add the Key Vault Secret..."
$dataLakeNameString = "BlobEndpoint=https://$dataLakeNameDev.blob.core.windows.net/;QueueEndpoint=https://$dataLakeNameDev.queue.core.windows.net/;FileEndpoint=https://$dataLakeNameDev.file.core.windows.net/;TableEndpoint=https://$dataLakeNameDev.table.core.windows.net/;SharedAccessSignature=sv=2021-06-08&ss=bfqt&srt=sco&sp=rwdlacupyx&se=2022-10-22T08:59:13Z&st=2022-07-22T00:59:13Z&spr=https&sig=zQV6jgYs1NRd2DiVUMExNaxjJoqkYWfk5BOwXEGWmmc%3D"
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $dataLakeNameDev -SecretValue $(ConvertTo-SecureString $dataLakeNameString -AsPlainText)

#Crear un secreto con la cadena de conexión del DataLakeProd
Write-Host "Add the Key Vault Secret..."
$dataLakeNameString = "BlobEndpoint=https://$dataLakeName.blob.core.windows.net/;QueueEndpoint=https://$dataLakeName.queue.core.windows.net/;FileEndpoint=https://$dataLakeName.file.core.windows.net/;TableEndpoint=https://$dataLakeName.table.core.windows.net/;SharedAccessSignature=sv=2021-06-08&ss=bfqt&srt=sco&sp=rwdlacupyx&se=2022-10-22T08:56:30Z&st=2022-07-22T00:56:30Z&spr=https&sig=mqoq51cCPpZIM4%2Fsl%2BLFxhOAs097YX%2B9IF2v7S444CM%3D"
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $dataLakeName -SecretValue $(ConvertTo-SecureString $dataLakeNameString -AsPlainText)
