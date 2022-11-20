#!/usr/bin/env bash
# -*- coding: utf-8 -*-

####  ressource group
#-----------------------------------------------------------------------------
az group create --name $AKS_RESOURCE_GROUP --location switzerlandwest
# oups ...

####  ressource group for aks
#-----------------------------------------------------------------------------
az group create --name $AKS_RESOURCE_GROUP --location $REGION
# add provider

####  ressource group for dns
#-----------------------------------------------------------------------------
az group create --name $DNS_RESOURCE_GROUP \
  --location $REGION
az network dns zone create \
  --resource-group $DNS_RESOURCE_GROUP \
  --name $DOMAIN
