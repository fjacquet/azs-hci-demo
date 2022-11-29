#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
# -----------------------------
# activate feture
# -----------------------------
helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace $NAMESPACE_CERTMGR \
  --create-namespace \
  -f config/values.cert-manager.yaml \
  --wait

# -----------------------------
# validate deployment
# -----------------------------
. ./generate-test-ressource.sh
kubectl apply -f test-resources.yaml
kubectl describe certificate -n cert-manager-test
kubectl delete -f test-resources.yaml

# -----------------------------
# allow DNS for let's encrypt
# -----------------------------
# Choose a name for the service principal that contacts azure DNS to present
# the challenge.
AZURE_CERT_MANAGER_NEW_SP_NAME="cert-mgr-sp"
AZURE_DNS_ZONE_RESOURCE_GROUP=$AZ_RESOURCE_GROUP
AZURE_DNS_ZONE=$AZ_DNS_DOMAIN

AZURE_CERT_MANAGER_DNS_SP=$(az ad sp create-for-rbac --name $AZURE_CERT_MANAGER_NEW_SP_NAME --output json)
AZURE_CERT_MANAGER_SP_APP_ID=$(echo $DNS_SP | jq -r '.appId')
AZURE_CERT_MANAGER_SP_PASSWORD=$(echo $DNS_SP | jq -r '.password')

az role assignment delete \
  --assignee $AZURE_CERT_MANAGER_SP_APP_ID \
  --role Contributor

AZURE_CERT_MANAGER_DNS_ID=$(az network dns zone show \
  --name $AZURE_DNS_ZONE \
  --resource-group $AZURE_DNS_ZONE_RESOURCE_GROUP \
  --query "id" \
  --output tsv)

export AZURE_CERT_MANAGER_DNS_SP AZURE_CERT_MANAGER_SP_APP_ID AZURE_CERT_MANAGER_SP_PASSWORD AZURE_CERT_MANAGER_DNS_ID

az role assignment create \
  --assignee $AZURE_CERT_MANAGER_SP_APP_ID \
  --role "DNS Zone Contributor" \
  --scope $AZURE_CERT_MANAGER_DNS_ID

az role assignment list --all \
  --assignee $AZURE_CERT_MANAGER_SP_APP_ID

kubectl create secret generic azuredns-config \
  --from-literal=client-secret=$AZURE_CERT_MANAGER_SP_PASSWORD

. ./generate-test-acme-http.sh
kubectl apply -f test-acme.yaml

. ./generate-prod-acme-http.sh
kubectl apply -f prod-acme.yaml

set +x
