#!/usr/bin/env bash
# -*- coding: utf-8 -*-

####  ressource group
#-----------------------------------------------------------------------------
az group create \
  --name $RESOURCE_GROUP_AKS \
  --location switzerlandwest
# oups ...

####  ressource group for aks
#-----------------------------------------------------------------------------
az group create \
  --name $RESOURCE_GROUP_AKS \
  --location $REGION
# add provider

####  ressource group for dns
#-----------------------------------------------------------------------------
az group create --name $AZ_RESOURCE_GROUP \
  --location $REGION
az network dns zone create \
  --resource-group $AZ_RESOURCE_GROUP \
  --name $DOMAIN
