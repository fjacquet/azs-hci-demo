#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#-----------------------------------------------------------------------------
####  AKS
#-----------------------------------------------------------------------------
az aks create \
  --resource-group $AKS_RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME \
  --node-count 3 \
  --node-vm-size $SIZE \
  --enable-addons monitoring \
  --generate-ssh-keys

az aks get-credentials --resource-group $AKS_RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME
kubectl get nodes
kubectl create clusterrolebinding yb-kubernetes-dashboard \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:kubernetes-dashboard \
  --user=clusterUser
az aks browse --resource-group $AKS_RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME
