#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

# Environment
export AZ_DATA_SERVICES_NS=data-services


# Enable postgresql
az postgres server-arc create \
  --name postgres01 \
  --k8s-namespace $AZ_DATA_SERVICES_NS \
  --use-k8s

az postgres server-arc list \
  --k8s-namespace $AZ_DATA_SERVICES_NS \
  --use-k8s

set +x
