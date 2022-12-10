

Install-PackageProvider -Name NuGet -Force
Install-Module -Name PowershellGet -Force -Confirm:$false -SkipPublisherCheck
Install-Module -Name AksHci -Repository PSGallery

$env:AZURE_RESOURCE_GROUP = 'dtrd-aks-rg'
$env:AZURE_SUBSCRIPTION = 'Azure subscription 1'
$env:AZURE_VNET = 'dtrd-vnet'
$env:AKS_CLUSTER = 'dtrd-aks'

Exit