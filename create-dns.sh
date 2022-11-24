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

# name of the service principal
EXTERNALDNS_NEW_SP_NAME="ExternalDnsServicePrincipal"
# name of resource group where dns zone is hosted
AZURE_DNS_ZONE_RESOURCE_GROUP=$AZ_RESOURCE_GROUP
# DNS zone name
AZURE_DNS_ZONE=$AZ_AZ_DNS_DOMAIN

# Create the service principal
DNS_SP=$(az ad sp create-for-rbac --name $EXTERNALDNS_NEW_SP_NAME -o json)
EXTERNALDNS_SP_APP_ID=$(echo $DNS_SP | jq -r '.appId')
EXTERNALDNS_SP_PASSWORD=$(echo $DNS_SP | jq -r '.password')
kubectl create secret generic externadns-config --from-literal=client-secret=$EXTERNALDNS_SP_PASSWORD
DNS_ID=$(az network dns zone show --name $AZ_DNS_DOMAIN \
  --resource-group $AZ_RESOURCE_GROUP \
  --query "id" --output tsv)

# 1. as a reader to the resource group
az role assignment create --role "Reader" \
  --assignee $EXTERNALDNS_SP_APP_ID \
  --scope $DNS_ID

# 2. as a contributor to DNS Zone itself
az role assignment create --role "Contributor" \
  --assignee $EXTERNALDNS_SP_APP_ID \
  --scope $DNS_ID

# Create tailored External-DNS deployment

helm install external-dns bitnami/external-dns \
  --wait \
  --create-namespace \
  --namespace $NAMESPACE_EXTERNALDNS \
  --set txtOwnerId=$AKS_CLUSTER_NAME \
  --set provider=azure \
  --set azure.resourceGroup=$AZ_RESOURCE_GROUP \
  --set txtOwnerId=$AKS_CLUSTER_NAME \
  --set azure.tenantId=$AZ_TENANT_ID \
  --set azure.subscriptionId=$AZ_SUBSCRIPTION_ID \
  --set azure.aadClientId=$EXTERNALDNS_SP_APP_ID \
  --set azure.aadClientSecret="$EXTERNALDNS_SP_PASSWORD" \
  --set azure.cloud=AzurePublicCloud \
  --set policy=sync \
  --set domainFilters={$AZ_DNS_DOMAIN}

az network dns record-set a list \
  --resource-group $AZ_RESOURCE_GROUP \
  --zone-name $AZ_DNS_DOMAIN

set +x
