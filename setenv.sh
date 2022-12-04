#!/usr/bin/env bash
# -*- coding: utf-8 -*-

ACME_ISSUER_EMAIL=fjacquet@ljfch.onmicrosoft.com
AKS_CLUSTER_NAME=aks-demo
AKS_COUNT=4
AKS_SIZE=Standard_D4ds_v5
AZ_DNS_DOMAIN=aks.ez-lab.xyz
AZ_RESOURCE_GROUP=aksrg
AZ_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
AZ_TENANT_ID=$(az account show --query tenantId --output tsv)
DIST=lab
EXTERNALDNS_LOG_LEVEL=debug
NAMESPACE_CERTMGR=cert-manager
NAMESPACE_ELASTIC=elastic-system
NAMESPACE_EXTERNALDNS=external-dns
NAMESPACE_INGRESS=nginx-ingress
NAMESPACE_GITLAB=gitlab
NAMESPACE_JENKINS=jenkins
NAMESPACE_KEYCLOAK=keycloak
NAMESPACE_KUBEAPPS=kubeapps
NAMESPACE_KUBEADDONS=kube-addons
NAMESPACE_MONITORING=monitoring
NAMESPACE_REDIS=redis
NAMESPACE_SONAR=sonarqube
NAMESPACE_TRAEFIK=traefik
NAMESPACE_WIKIJS=wikijs
NAMESPACE_YUGA=yugabyte
REGION=switzerlandnorth

export ACME_ISSUER_EMAIL
export AKS_CLUSTER_NAME
export AZ_DNS_DOMAIN
export AZ_RESOURCE_GROUP
export AZ_SUBSCRIPTION_ID
export AZ_TENANT_ID
export EXTERNALDNS_LOG_LEVEL
export NAMESPACE_CERTMGR
export NAMESPACE_ELASTIC
export NAMESPACE_EXTERNALDNS
export NAMESPACE_GITLAB
export NAMESPACE_INGRESS
export NAMESPACE_JENKINS
export NAMESPACE_KEYCLOAK
export NAMESPACE_KUBEAPPS
export NAMESPACE_KUBEADDONS
export NAMESPACE_MONITORING
export NAMESPACE_REDIS
export NAMESPACE_SONAR
export NAMESPACE_TRAEFIK
export NAMESPACE_WIKIJS
export NAMESPACE_YUGA
export REGION AKS_SIZE
