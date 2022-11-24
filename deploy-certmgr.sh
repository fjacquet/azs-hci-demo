#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace $NAMESPACE_CERTMGR \
  --create-namespace \
  --version v1.10.1 \
  --set installCRDs=true \
  --set prometheus.enabled=true \
  --set prometheus.servicemonitor.enabled=true


cat <<EOF >test-resources.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager-test
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: test-selfsigned
  namespace: cert-manager-test
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: selfsigned-cert
  namespace: cert-manager-test
spec:
  dnsNames:
    - $AZ_DNS_DOMAIN
  secretName: selfsigned-cert-tls
  issuerRef:
    name: test-selfsigned
EOF
kubectl apply -f test-resources.yaml
kubectl describe certificate -n cert-manager-test
kubectl delete -f test-resources.yaml

# Choose a name for the service principal that contacts azure DNS to present
# the challenge.
AZURE_CERT_MANAGER_NEW_SP_NAME="cert-mgr-sp"
# This is the name of the resource group that you have your dns zone in.
AZURE_DNS_ZONE_RESOURCE_GROUP=$AZ_RESOURCE_GROUP
# The DNS zone name. It should be something like domain.com or sub.domain.com.
AZURE_DNS_ZONE=$AZ_DNS_DOMAIN
DNS_SP=$(az ad sp create-for-rbac --name $AZURE_CERT_MANAGER_NEW_SP_NAME --output json)
AZURE_CERT_MANAGER_SP_APP_ID=$(echo $DNS_SP | jq -r '.appId')
AZURE_CERT_MANAGER_SP_PASSWORD=$(echo $DNS_SP | jq -r '.password')
az role assignment delete --assignee $AZURE_CERT_MANAGER_SP_APP_ID --role Contributor
DNS_ID=$(az network dns zone show --name $AZURE_DNS_ZONE --resource-group $AZURE_DNS_ZONE_RESOURCE_GROUP --query "id" --output tsv)
az role assignment create --assignee $AZURE_CERT_MANAGER_SP_APP_ID --role "DNS Zone Contributor" --scope $DNS_ID
az role assignment list --all --assignee $AZURE_CERT_MANAGER_SP_APP_ID
kubectl create secret generic azuredns-config --from-literal=client-secret=$AZURE_CERT_MANAGER_SP_PASSWORD

cat <<EOF >test-acme.yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-staging
  namespace: $NAMESPACE_CERTMGR
spec:
  acme:
    ...
    solvers:
    - selector:
        dnsZones:
        - $AZ_DNS_DOMAIN
    - dns01:
        azureDNS:
          cnameStrategy: Follow
          clientID: $EXTERNALDNS_SP_APP_ID
          clientSecretSecretRef:
          # The following is the secret we created in Kubernetes. Issuer will use this to present challenge to Azure DNS.
            name: azuredns-config
            key: client-secret
          subscriptionID: $AZ_SUBSCRIPTION_ID
          tenantID: $AZ_TENANT_ID
          resourceGroupName: $AZ_RESOURCE_GROUP
          hostedZoneName: $AZ_DNS_DOMAIN
          # Azure Cloud Environment, default to AzurePublicCloud
          environment: AzurePublicCloud
EOF
kubectl apply -f test-acme.yaml

set +x
