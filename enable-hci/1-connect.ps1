Get-Command -Module AksHci
# Connect-AzAccount
Set-AzContext -Subscription $env:AZURE_SUBSCRIPTION
Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
Get-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Get-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration