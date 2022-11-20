#!/usr/bin/env bash
# -*- coding: utf-8 -*-

####  permission for provider
#-----------------------------------------------------------------------------
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.ContainerService --wait
