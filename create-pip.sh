#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
####  Public IP
#-----------------------------------------------------------------------------
az network public-ip create \
  --resource-group $AZ_RESOURCE_GROUP \
  --name $AZ_RESOURCE_GROUP-public-ip \
  --sku Standard \
  --allocation-method static

AZ_CLIENT_ID=$(az aks show \
  --resource-group $AZ_RESOURCE_GROUP \
  --name $AKS_CLUSTER_NAME \
  --query "servicePrincipalProfile.clientId" \
  --output tsv)
echo $AZ_CLIENT_ID

SUBS=$(az account subscription list -o tsv | cut -f3)
SCOPE="$SUBS/resourceGroups/$AZ_RESOURCE_GROUP"

az role assignment create \
  --assignee $AZ_CLIENT_ID \
  --role "Network Contributor" \
  --scope $SCOPE

az ad sp create-for-rbac \
  --role="Monitoring Reader" \
  --scopes=$SCOPE
set +x
