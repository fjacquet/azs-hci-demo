#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
####  DNS area
#-----------------------------------------------------------------------------
az network dns zone create \
  --resource-group ${AZ_RESOURCE_GROUP} \
  --name ${AZ_DNS_DOMAIN}

az network dns zone list \
  --query "[?name=='$AZ_DNS_DOMAIN']" --output table

#-----------------------------------------------------------------------------
####  service acces for dns
#-----------------------------------------------------------------------------
# name of the service principal
AZURE_DNS_ZONE_RESOURCE_GROUP=$AZ_RESOURCE_GROUP
AZURE_DNS_ZONE=$AZ_DNS_DOMAIN

EDNS_SP_NAME="external-dns-sp"
DNS_SP=$(az ad sp create-for-rbac \
  --name $EDNS_SP_NAME \
  -o json)
EDNS_SP_APP_ID=$(echo $DNS_SP | jq -r '.appId')
EDNS_SP_PASSWORD=$(echo $DNS_SP | jq -r '.password')

DNS_ID=$(az network dns zone show --name $AZ_DNS_DOMAIN \
  --resource-group $AZ_RESOURCE_GROUP \
  --query "id" --output tsv)

export EDNS_SP_NAME EDNS_SP_APP_ID EDNS_SP_PASSWORD
export DNS_ID DNS_SP

kubectl create secret generic EDNS-config \
  --from-literal=client-secret=$EDNS_SP_PASSWORD

# 1. as a reader to the resource group
az role assignment create --role "Reader" \
  --assignee $EDNS_SP_APP_ID \
  --scope $DNS_ID

# 2. as a contributor to DNS Zone itself
az role assignment create --role "Contributor" \
  --assignee $EDNS_SP_APP_ID \
  --scope $DNS_ID

set +x
