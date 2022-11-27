#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# -----------------------------
# create issuer prod
# -----------------------------
cat <<EOF >prod-acme.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: $NAMESPACE_CERTMGR
spec:
  acme:
    email: $ACME_ISSUER_EMAIL
    # ACME server URL for Let’s Encrypt’s staging environment.
    # The staging environment will not issue trusted certificates but is
    # used to ensure that the verification process is working properly
    # before moving to production
    server: https://acme-v02.api.letsencrypt.org/directory

    privateKeySecretRef:
      # Secret resource used to store the account's private key.
      name: letsencrypt-prod-secret
    solvers:
      - dns01:
          azureDNS:
            clientID: $AZURE_CERT_MANAGER_SP_APP_ID
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
