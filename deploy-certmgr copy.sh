#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
# Generate file
#-----------------------------------------------------------------------------
cat <<-EOF >helmfile.yaml
repositories:
  - name: bitnami
    url: https://charts.bitnami.com/bitnami
  - name: ingress-nginx
    url: https://kubernetes.github.io/ingress-nginx
  - name: jetstack
    url: https://charts.jetstack.io

releases:
  - name: external-dns
    namespace: $NAMESPACE_KUBEADDONS
    chart: bitnami/external-dns
    # version: 5.1.1
    values:
      - provider: azure
        azure:
          resourceGroup: $AZ_RESOURCE_GROUP
          tenantId: $AZ_TENANT_ID
          subscriptionId: $AZ_SUBSCRIPTION_ID
          useManagedIdentityExtension: true
        logLevel: $EXTERNALDNS_LOG_LEVEL
        domainFilters:
          - $AZ_DNS_DOMAIN
        txtOwnerId: external-dns

  - name: ingress-nginx
    namespace: $NAMESPACE_KUBEADDONS
    chart: ingress-nginx/ingress-nginx
    # version: 3.34.0
    values:
      - controller:
          replicaCount: 2
          nodeSelector:
            kubernetes.io/os: linux
          admissionWebhooks:
            patch:
              nodeSelector:
                kubernetes.io/os: linux
          service:
            externalTrafficPolicy: Local
        defaultBackend:
          nodeSelector:
            kubernetes.io/os: linux

  - name: cert-manager
    namespace: $NAMESPACE_KUBEADDONS
    chart: jetstack/cert-manager
    # version: 1.4.0
    values:
      - installCRDs: true
        extraArgs:
          - --cluster-resource-namespace=$NAMESPACE_KUBEADDONS
        global:
          logLevel: 2
EOF

#-----------------------------------------------------------------------------
# Apply and cleanup
#-----------------------------------------------------------------------------
helmfile apply
rm helmfile.yaml

#-----------------------------------------------------------------------------
# Install cert-manager clusterissuers
#-----------------------------------------------------------------------------
cat <<-EOF >helmfile.yaml
repositories:
  - name: itscontained
    url: https://charts.itscontained.io

releases:
  - name: cert-manager-issuers
    chart: itscontained/raw
    namespace: $NAMESPACE_KUBEADDONS
    # version:  0.2.5
    ## only required if releases included in same helmfile
    ## otherwise, comment out
    # needs:
    #   - kube-addons/cert-manager
    disableValidation: true
    values:
      - resources:
          - apiVersion: cert-manager.io/v1
            kind: ClusterIssuer
            metadata:
              name: letsencrypt-staging
            spec:
              acme:
                server: https://acme-staging-v02.api.letsencrypt.org/directory
                email: $ACME_ISSUER_EMAIL
                privateKeySecretRef:
                  name: letsencrypt-staging
                solvers:
                  - dns01:
                      azureDNS:
                        subscriptionID: $AZ_SUBSCRIPTION_ID
                        resourceGroupName: $AZ_RESOURCE_GROUP
                        hostedZoneName: $AZ_DNS_DOMAIN
                        environment: AzurePublicCloud

          - apiVersion: cert-manager.io/v1
            kind: ClusterIssuer
            metadata:
              name: letsencrypt-prod
            spec:
              acme:
                server: https://acme-v02.api.letsencrypt.org/directory
                email: $ACME_ISSUER_EMAIL
                privateKeySecretRef:
                  name: letsencrypt-prod
                solvers:
                  - dns01:
                      azureDNS:
                        subscriptionID: $AZ_SUBSCRIPTION_ID
                        resourceGroupName: $AZ_RESOURCE_GROUP
                        hostedZoneName: $AZ_DNS_DOMAIN
                        environment: AzurePublicCloud
EOF
#-----------------------------------------------------------------------------
# Apply and cleanup
#-----------------------------------------------------------------------------
helmfile apply
rm helmfile.yaml
set +x
