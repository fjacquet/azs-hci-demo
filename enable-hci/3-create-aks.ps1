New-AksHciCluster  `
  -name $env:AKS_CLUSTER  `
  -nodePoolName linuxnodepool  `
  -nodeCount 1  `
  -osType Linux

Enable-AksHciArcConnection -name $env:AKS_CLUSTER

Set-AksHciCluster `
  -name $env:AKS_CLUSTER `
  -controlPlaneNodeCount 3

Get-AksHciCredential -name $env:AKS_CLUSTER