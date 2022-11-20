#!/usr/bin/env bash
# -*- coding: utf-8 -*-

ACME_ISSUER_EMAIL=fjacquet@ljfch.onmicrosoft.com
AKS_CLUSTER_NAME=akscluster
AKS_COUNT=3
AKS_SIZE=Standard_D4ds_v5
AZ_DNS_DOMAIN=aks.ez-lab.xyz
AZ_RESOURCE_GROUP=aksrg
AZ_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
AZ_TENANT_ID=$(az account show --query tenantId --output tsv)
DIST=lab
EXTERNALDNS_LOG_LEVEL=debug
NAMESPACE_INGRESS=ingress-nginx
NAMESPACE_KUBEAPPS=kubeapps
NAMESPACE_KUBEADDONS=kube-addons
NAMESPACE_MONITORING=monitoring
NAMESPACE_WIKIJS=wikijs
NAMESPACE_YUGA=yubabyte
REGION=switzerlandnorth

export ACME_ISSUER_EMAIL
export AKS_CLUSTER_NAME
export AZ_DNS_DOMAIN
export AZ_RESOURCE_GROUP
export AZ_SUBSCRIPTION_ID
export AZ_TENANT_ID
export EXTERNALDNS_LOG_LEVEL
export NAMESPACE_INGRESS
export NAMESPACE_KUBEAPPS
export NAMESPACE_KUBEADDONS
export NAMESPACE_MONITORING
export NAMESPACE_WIKIJS
export NAMESPACE_YUGA
export REGION AKS_SIZE
