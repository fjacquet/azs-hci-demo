#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#-----------------------------------------------------------------------------
####  AKS
#-----------------------------------------------------------------------------
az aks create \
  --resource-group $AKS_RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME \
  --node-count $AKS_COUNT \
  --node-vm-size $AKS_SIZE \
  --enable-addons monitoring \
  --load-balancer-sku standard \
  --enable-managed-identity \
  --vm-set-type VirtualMachineScaleSets \
  --generate-ssh-keys

# Create .kubeconfig
az aks get-credentials --resource-group $AKS_RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME

kubectl get nodes
kubectl create clusterrolebinding yb-kubernetes-dashboard \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:kubernetes-dashboard \
  --user=clusterUser
az aks browse --resource-group $AKS_RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME
