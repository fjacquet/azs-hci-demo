#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
####  AKS
#-----------------------------------------------------------------------------
az aks create \
  --resource-group $AZ_RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME \
  --node-count 1 \
  --node-vm-size $AKS_SIZE \
  --load-balancer-sku standard \
  --vm-set-type VirtualMachineScaleSets \
  --generate-ssh-keys

# Create .kubeconfig
az aks get-credentials \
  --resource-group $AZ_RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME

# kubectl get nodes
kubectl create clusterrolebinding yb-kubernetes-dashboard \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:kubernetes-dashboard \
  --user=clusterUser
# az aks browse --resource-group $AZ_RESOURCE_GROUP \
#   --name $AKS_CLUSTER_NAME

set +x
