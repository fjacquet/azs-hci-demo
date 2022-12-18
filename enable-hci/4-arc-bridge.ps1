$subscriptionId = $env:AZURE_SUBSCRIPTION
$resourceGroup = $env:AZURE_RESOURCE_GROUP
$location = "westeurope"
$workingDir = "V:\AKS-HCI\WorkDir"
$arcAppName = "arc-resource-bridge"
$configFilePath = $workingDir + "\hci-appliance.yaml"
$arcExtnName = "aks-hybrid-ext"
$customLocationName = "azurevm-customlocation"

New-ArcHciAksConfigFiles  `
  -subscriptionID $subscriptionId  `
  -location $location `
  -resourceGroup $resourceGroup  `
  -resourceName $arcAppName  `
  -workDirectory $workingDir  `
  -vnetName "appliance-vnet"  `
  -vSwitchName "InternalNAT"  `
  -gateway "192.168.0.1"  `
  -dnsservers "192.168.0.1"  `
  -ipaddressprefix "192.168.0.0/16"  `
  -k8snodeippoolstart "192.168.0.11"  `
  -k8snodeippoolend "192.168.0.11"  `
  -controlPlaneIP "192.168.0.161"

az account set -s $subscriptionid
az arcappliance validate hci --config-file $configFilePath