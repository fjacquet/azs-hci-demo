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

DNS_ID=$(az network dns zone show --name $AZURE_DNS_ZONE \
  --resource-group $AZURE_DNS_ZONE_RESOURCE_GROUP \
  --query "id" --output tsv)

EXTERNALDNS_SP_NAME="external-dns-sp"
DNS_SP=$(az ad sp create-for-rbac --name $EXTERNALDNS_SP_NAME -o json)
EXTERNALDNS_SP_APP_ID=$(echo $DNS_SP | jq -r '.appId')
EXTERNALDNS_SP_PASSWORD=$(echo $DNS_SP | jq -r '.password')

kubectl create secret generic externaldns-config \
  --from-literal=client-secret=$EXTERNALDNS_SP_PASSWORD

# 1. as a reader to the resource group
az role assignment create --role "Reader" \
  --assignee $EXTERNALDNS_SP_APP_ID \
  --scope $DNS_ID

# 2. as a contributor to DNS Zone itself
az role assignment create --role "Contributor" \
  --assignee $EXTERNALDNS_SP_APP_ID \
  --scope $DNS_ID

#-----------------------------------------------------------------------------
####  enable auto register
#-----------------------------------------------------------------------------
# Create tailored External-DNS deployment
helm install external-dns bitnami/external-dns \
  --wait \
  --create-namespace \
  --namespace $NAMESPACE_EXTERNALDNS \
  --set azure.aadClientId=$EXTERNALDNS_SP_APP_ID \
  --set azure.aadClientSecret="$EXTERNALDNS_SP_PASSWORD" \
  --set azure.cloud=AzurePublicCloud \
  --set azure.resourceGroup=$AZ_RESOURCE_GROUP \
  --set azure.subscriptionId=$AZ_SUBSCRIPTION_ID \
  --set azure.tenantId=$AZ_TENANT_ID \
  --set domainFilters={$AZ_DNS_DOMAIN} \
  --set policy=sync \
  --set provider=azure \
  --set txtOwnerId=$AKS_CLUSTER_NAME
#-----------------------------------------------------------------------------
### check connection
#-----------------------------------------------------------------------------
az network dns record-set a list \
  --resource-group $AZ_RESOURCE_GROUP \
  --zone-name $AZ_DNS_DOMAIN

set +x
