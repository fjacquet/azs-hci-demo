#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#-----------------------------------------------------------------------------
# Generate file
#-----------------------------------------------------------------------------
cat <<-EOF >helmfile.yml
repositories:
  - name: bitnami
    url: https://charts.bitnami.com/bitnami
  - name: ingress-nginx
    url: https://kubernetes.github.io/ingress-nginx
  - name: jetstack
    url: https://charts.jetstack.io

releases:
  - name: external-dns
    namespace: {{ requiredEnv "NAMESPACE_KUBEADDONS" }}
    chart: bitnami/external-dns
    version: 5.1.1
    values:
      - provider: azure
        azure:
          resourceGroup: {{ requiredEnv "RESOURCE_GROUP_AKS" }}
          tenantId: {{ requiredEnv "AZ_TENANT_ID" }}
          subscriptionId: {{ requiredEnv "AZ_SUBSCRIPTION_ID" }}
          useManagedIdentityExtension: true
        logLevel: {{ env "EXTERNALDNS_LOG_LEVEL" | default "debug" }}
        domainFilters:
          - {{ requiredEnv "AZ_DNS_DOMAIN" }}
        txtOwnerId: external-dns

  - name: ingress-nginx
    namespace: {{ requiredEnv "NAMESPACE_KUBEADDONS" }}
    chart: ingress-nginx/ingress-nginx
    version: 3.34.0
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
    namespace: {{ requiredEnv "NAMESPACE_KUBEADDONS" }}
    chart: jetstack/cert-manager
    version: 1.4.0
    values:
      - installCRDs: true
        extraArgs:
          - --cluster-resource-namespace={{ requiredEnv "NAMESPACE_KUBEADDONS" }}
        global:
          logLevel: 2
EOF

#-----------------------------------------------------------------------------
# Apply and cleanup
#-----------------------------------------------------------------------------
helmfile apply
rm helmfile.yml

#-----------------------------------------------------------------------------
# Install cert-manager clusterissuers
#-----------------------------------------------------------------------------
cat <<-EOF >helmfile.yml
repositories:
  - name: itscontained
    url: https://charts.itscontained.io

releases:
  - name: cert-manager-issuers
    chart: itscontained/raw
    namespace: {{ requiredEnv "NAMESPACE_KUBEADDONS" }}
    version:  0.2.5
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
                email: {{ requiredEnv "ACME_ISSUER_EMAIL" }}
                privateKeySecretRef:
                  name: letsencrypt-staging
                solvers:
                  - dns01:
                      azureDNS:
                        subscriptionID: {{ requiredEnv "AZ_SUBSCRIPTION_ID" }}
                        resourceGroupName: {{ requiredEnv "AZ_RESOURCE_GROUP" }}
                        hostedZoneName: {{ requiredEnv "AZ_DNS_DOMAIN" }}
                        environment: AzurePublicCloud

          - apiVersion: cert-manager.io/v1
            kind: ClusterIssuer
            metadata:
              name: letsencrypt-prod
            spec:
              acme:
                server: https://acme-v02.api.letsencrypt.org/directory
                email: {{ requiredEnv "ACME_ISSUER_EMAIL" }}
                privateKeySecretRef:
                  name: letsencrypt-prod
                solvers:
                  - dns01:
                      azureDNS:
                        subscriptionID: {{ requiredEnv "AZ_SUBSCRIPTION_ID" }}
                        resourceGroupName: {{ requiredEnv "AZ_RESOURCE_GROUP" }}
                        hostedZoneName: {{ requiredEnv "AZ_DNS_DOMAIN" }}
                        environment: AzurePublicCloud
EOF
#-----------------------------------------------------------------------------
# Apply and cleanup
#-----------------------------------------------------------------------------
helmfile apply
rm helmfile.yml
