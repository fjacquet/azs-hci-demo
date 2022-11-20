#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#-----------------------------------------------------------------------------
####  Public IP
#-----------------------------------------------------------------------------
az network public-ip create \
  --resource-group RESOURCE_GROUP_AKS \
  --name myAKSPublicIP \
  --sku Standard \
  --allocation-method static

sub=$(az account subscription list -o tsv | cut -f3)
scope="$sub/resourceGroups/$NAMESPACE_YUGA"

AZ_CLIENT_ID=$(az aks show \
  --resource-group $RESOURCE_GROUP_AKS \
  --name $AKS_CLUSTER_NAME \
  --query "servicePrincipalProfile.clientId" \
  --output tsv)
echo $AZ_CLIENT_ID

az role assignment create \
  --assignee $AZ_CLIENT_ID \
  --role "Network Contributor" \
  --scope scope

az ad sp create-for-rbac \
  --role="Monitoring Reader" \
  --scopes=$scope
