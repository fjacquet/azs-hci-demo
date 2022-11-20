#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
####  ressource group
#-----------------------------------------------------------------------------
az group create \
  --name $AZ_RESOURCE_GROUP \
  --location switzerlandwest
# oups ...

####  ressource group for aks
#-----------------------------------------------------------------------------
az group create \
  --name $AZ_RESOURCE_GROUP \
  --location $REGION
# add provider

####  ressource group for dns
#-----------------------------------------------------------------------------
az group create --name $AZ_RESOURCE_GROUP \
  --location $REGION
az network dns zone create \
  --resource-group $AZ_RESOURCE_GROUP \
  --name $AZ_DNS_DOMAIN
set +x
