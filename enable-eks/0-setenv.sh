#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

# Environment
export AZDATA_LOGSUI_USERNAME=delltech
export AZDATA_LOGSUI_PASSWORD=D3m0plaza

export AZDATA_METRICSUI_USERNAME=delltech
export AZDATA_METRICSUI_PASSWORD=D3m0plaza

export AZ_DATA_SERVICES_NS=data-services

export AZDATA_USERNAME=delltech
export AZDATA_PASSWORD=D3m0plaza

export subscription=41e76d28-bdcf-4254-bda2-d06420a1f30d
export resourceGroup=fred
export clusterName=arcks
export location=westeurope
export adsExtensionName=eks-dc
export namespace=$AZ_DATA_SERVICES_NS
export namespaceDc=data-ctrl

export CLUSTER=dtrd-eks
export REGION=eu-west-3
export IAM=240388846865

set +x
