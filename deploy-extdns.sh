#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
####  enable auto register
#-----------------------------------------------------------------------------
# Create tailored External-DNS deployment
helm upgrade --install external-dns bitnami/external-dns \
  --wait \
  --create-namespace \
  --namespace $NAMESPACE_EXTERNALDNS \
  --set azure.aadClientId="$EDNS_SP_APP_ID" \
  --set azure.aadClientSecret="$EDNS_SP_PASSWORD" \
  --set azure.cloud=AzurePublicCloud \
  --set azure.resourceGroup="$AZ_RESOURCE_GROUP" \
  --set azure.subscriptionId="$AZ_SUBSCRIPTION_ID" \
  --set azure.tenantId="$AZ_TENANT_ID" \
  \
  --set policy=sync \
  --set provider=azure \
  --set txtOwnerId="$AKS_CLUSTER_NAME" # --set domainFilters="$AZ_DNS_DOMAIN" \

cat <<-EOF >azure.json
{
  "tenantId": "$(az account show --query tenantId -o tsv)",
  "subscriptionId": "$(az account show --query id -o tsv)",
  "resourceGroup": "$AZ_RESOURCE_GROUP",
  "aadClientId": "$EDNS_SP_APP_ID",
  "aadClientSecret": "$EDNS_SP_PASSWORD"
}
EOF

kubectl create secret generic azure-config-file \
  --namespace "default" \
  --from-file azure.json
#-----------------------------------------------------------------------------
### check connection
#-----------------------------------------------------------------------------
az network dns record-set a list \
  --resource-group $AZ_RESOURCE_GROUP \
  --zone-name $AZ_DNS_DOMAIN
set +x
