#!/usr/bin/env bash
# -*- coding: utf-8 -*-

####  DNS area
#-----------------------------------------------------------------------------

# name of the service principal
EXTERNALDNS_NEW_SP_NAME="ExternalDnsServicePrincipal"
# name of resource group where dns zone is hosted

# Create the service principal
DNS_SP=$(az ad sp create-for-rbac --name $EXTERNALDNS_NEW_SP_NAME)
EXTERNALDNS_SP_APP_ID=$(echo $DNS_SP | jq -r '.appId')
EXTERNALDNS_SP_PASSWORD=$(echo $DNS_SP | jq -r '.password')
DNS_ID=$(az network dns zone show --name $AZ_DNS_DOMAIN \
  --resource-group $AZ_RESOURCE_GROUP \
  --query "id" \
  --output tsv)

az role assignment create \
  --role "Contributor" \
  --assignee $EXTERNALDNS_SP_APP_ID \
  --scope $DNS_ID

cat <<-EOF >azure.json
{
  "tenantId": "$(az account show --query tenantId -o tsv)",
  "subscriptionId": "$(az account show --query id -o tsv)",
  "resourceGroup": "$AZURE_DNS_ZONE_RESOURCE_GROUP",
  "aadClientId": "$EXTERNALDNS_SP_APP_ID",
  "aadClientSecret": "$EXTERNALDNS_SP_PASSWORD"
}
EOF
kubectl create secret generic azure-config-file \
  --namespace "default" \
  --from-file azure.json

kubectl apply -f external-dns.yml
