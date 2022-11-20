#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
####  permission for provider
#-----------------------------------------------------------------------------
az provider register --namespace Microsoft.Network --wait
az provider register --namespace Microsoft.Compute --wait
az provider register --namespace Microsoft.Storage --wait
az provider register --namespace Microsoft.ContainerService --wait
set +x