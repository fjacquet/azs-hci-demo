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

set +x
