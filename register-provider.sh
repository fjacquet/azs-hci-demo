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

set +x
