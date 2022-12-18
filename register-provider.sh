#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
####  permission for provider
#-----------------------------------------------------------------------------

az config set extension.use_dynamic_install=yes_without_prompt

# az feature unregister --name EnablePodIdentityPreview --namespace Microsoft.ContainerService
# az feature unregister --name AutoUpgradePreview --namespace Microsoft.ContainerService

# az extension add --name aks-preview
# az extension update --name aks-preview

az provider register --namespace Microsoft.Network --wait
az provider register --namespace Microsoft.Compute --wait
az provider register --namespace Microsoft.Storage --wait
az provider register --namespace Microsoft.ContainerService --wait
az provider register --namespace Microsoft.HybridCompute --wait
az provider register --namespace Microsoft.GuestConfiguration --wait
az provider register --namespace Microsoft.Kubernetes --wait
az provider register --namespace Microsoft.KubernetesConfiguration --wait
az provider register --namespace Microsoft.ExtendedLocation --wait
az provider register --namespace Microsoft.AzureArcData --wait
az provider register --namespace Microsoft.OperationsManagement --wait
az provider register --namespace Microsoft.AzureStackHCI --wait
az provider register --namespace Microsoft.ResourceConnector --wait

az extension add --upgrade --name arcappliance
az extension add --upgrade --name connectedk8s
az extension add --upgrade --name k8s-configuration
az extension add --upgrade --name k8s-extension
az extension add --upgrade --name customlocation
az extension add --upgrade --name azurestackhci

set +x
