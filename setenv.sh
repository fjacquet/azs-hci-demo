#!/usr/bin/env bash
# -*- coding: utf-8 -*-

AKS_CLUSTER_NAME=akscluster
AKS_COUNT=3
AKS_RESOURCE_GROUP=aksrg
AKS_SIZE=Standard_D4ds_v5
AZ_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
AZ_TENANT_ID=$(az account show --query tenantId --output tsv)
DIST=lab
DNS_DOMAIN=aks.ez-lab.xyz
DNS_RESOURCE_GROUP=dnsrg
EMAIL=fjacquet@ljfch.onmicrosoft.com
NAMESPACE_INGRESS=ingress-nginx
NAMESPACE_KUBEAPPS=kubeapps
NAMESPACE_MONITORING=monitoring
NAMESPACE_WIKIJS=wikijs
NAMESPACE_YUGA=dbns
REGION=switzerlandnorth

export AKS_CLUSTER_NAME
export AKS_RESOURCE_GROUP
export AZ_SUBSCRIPTION_ID
export AZ_TENANT_ID
export DNS_DOMAIN
export DNS_RESOURCE_GROUP
export EMAIL
export NAMESPACE_INGRESS
export NAMESPACE_KUBEAPPS
export NAMESPACE_MONITORING
export NAMESPACE_WIKIJS
export NAMESPACE_YUGA
export REGION AKS_SIZE
