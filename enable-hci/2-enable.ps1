Initialize-AksHciNode
Get-VMSwitch

#static IP
$vnet = New-AksHciNetworkSetting -name $env:AZURE_VNET `
  -vSwitchName "extSwitch" `
  -k8sNodeIpPoolStart "172.86.10.1" `
  -k8sNodeIpPoolEnd "172.86.10.255" `
  -vipPoolStart "172.86.255.0" `
  -vipPoolEnd "172.86.255.254" `
  -ipAddressPrefix "172.86.0.0/16" `
  -gateway "172.86.0.1" `
  -dnsServers "172.86.0.1" `
  -vlanId 42

Set-AksHciConfig `
  -imageDir c:\clusterstorage\volume1\Images `
  -workingDir c:\ClusterStorage\Volume1\ImageStore `
  -cloudConfigLocation c:\clusterstorage\volume1\Config `
  -vnet $vnet `
  -cloudservicecidr "172.86.10.10/16"

Set-AksHciRegistration `
  -subscriptionId $env:AZURE_SUBSCRIPTION  `
  -resourceGroupName $env:AZURE_RESOURCE_GROUP

Install-AksHci
