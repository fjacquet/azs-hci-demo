#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### Yugabyte storage
#-----------------------------------------------------------------------------
set -x

helm search repo yugabytedb/yugabyte --version 2.15.3
kubectl create namespace $NAMESPACE_YUGA
helm install yb-demo -n $NAMESPACE_YUGA yugabytedb/yugabyte \
  --version 2.15.3 \
  --set storage.master.count=3 \
  --set storage.tserver.count=3 \
  --set storage.master.storageClass=default \
  --set storage.tserver.storageClass=default \
  --set resource.master.requests.cpu=1 \
  --set resource.master.requests.memory=1Gi \
  --set resource.tserver.requests.cpu=1 \
  --set resource.tserver.requests.memory=1Gi \
  --set resource.master.limits.cpu=1 \
  --set resource.master.limits.memory=1Gi \
  --set resource.tserver.limits.cpu=1 \
  --set resource.tserver.limits.memory=1Gi \
  --timeout=15m

kubectl get pods --namespace $NAMESPACE_YUGA
kubectl get services --namespace $NAMESPACE_YUGA
set +x
