#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

az customlocation create \
  --resource-group ${resourceGroup} \
  --name ${clName} \
  --namespace ${namespace} \
  --host-resource-id ${hostClusterId} \
  --cluster-extension-ids ${extensionId} \
  --location ${location}

az k8s-extension create \
  --cluster-name ${clusterName} \
  --resource-group ${resourceGroup} \
  --name ${adsExtensionName} \
  --cluster-type connectedClusters \
  --extension-type microsoft.arcdataservices \
  --auto-upgrade true \
  --scope cluster \
  --release-namespace ${namespace} \
  --config Microsoft.CustomLocation.ServiceAccount=sa-arc-bootstrapper

# az k8s-extension show \
#   --cluster-name ${clusterName} \
#   --resource-group ${resourceGroup} \
#   --name ${adsExtensionName} \
#   --cluster-type connectedclusters

export MSI_OBJECT_ID=$(az k8s-extension show \
  --resource-group ${resourceGroup} \
  --cluster-name ${clusterName} \
  --cluster-type connectedClusters \
  --name ${adsExtensionName} | jq -r '.identity.principalId')

az role assignment create \
  --assignee $MSI_OBJECT_ID \
  --role "Contributor" \
  --scope "/subscriptions/${subscription}/resourceGroups/${resourceGroup}"

az role assignment create --assignee $MSI_OBJECT_ID \
  --role "Monitoring Metrics Publisher" \
  --scope "/subscriptions/${subscription}/resourceGroups/${resourceGroup}"

export clName=lausanne
export hostClusterId=$(az connectedk8s show \
  --resource-group ${resourceGroup} \
  --name ${clusterName} \
  --query id \
  -o tsv)
export extensionId=$(az k8s-extension show \
  --resource-group ${resourceGroup} \
  --cluster-name ${clusterName} \
  --cluster-type connectedClusters \
  --name ${adsExtensionName} \
  --query id \
  -o tsv)

# Enable data services

kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.13"

az arcdata dc create \
  --name arc-dc1 \
  --resource-group ${resourceGroup} \
  --location ${location} \
  --connectivity-mode direct \
  --profile-name azure-arc-eks \
  --auto-upload-metrics true \
  --custom-location ${clName} \
  --storage-class gp2

# az arcdata dc create \
#   --profile-name azure-arc-eks \
#   --connectivity-mode indirect \
#   --name arcdata \
#   --resource-group ${resourceGroup} \
#   --location ${location} \
#   --use-k8s \
#   --k8s-namespace arc-dc

kubectl get datacontrollers --namespace data-services

set +x
