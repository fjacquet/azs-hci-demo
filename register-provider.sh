#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
####  permission for provider
#-----------------------------------------------------------------------------
az provider register --namespace Microsoft.Network --wait
az provider register --namespace Microsoft.Compute --wait
az provider register --namespace Microsoft.Storage --wait
az provider register --namespace Microsoft.ContainerService --wait

# Define public Kubernetes chart repository in the Helm configuration
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add gitlab https://charts.gitlab.io/
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jenkins https://charts.jenkins.io
helm repo add jetstack https://charts.jetstack.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add requarks https://charts.js.wiki
helm repo add yugabytedb https://charts.yugabyte.com
# helm repo add itscontained https://charts.itscontained.io

# Update local repositories
helm repo update

set +x
