#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### Yugabyte storage
#-----------------------------------------------------------------------------
set -x

# helm upgrade --install yb-demo yugabytedb/yugabyte \
#   -n $NAMESPACE_YUGA \
#   --version 2.15.3 \
#   --create-namespace \
#   -f config/values-yuga.yaml \
#   --wait \
#   --timeout=15m

helm upgrade --install yb-demo yugabytedb/yugabyte \
  -n $NAMESPACE_YUGA \
  --version 2.15.3 \
  --create-namespace \
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
  --wait \
  --timeout=15m

kubectl get pods --namespace $NAMESPACE_YUGA
kubectl get services --namespace $NAMESPACE_YUGA

# connect to DB
# kubectl run ysqlsh-client -n $NAMESPACE_YUGA -it \
#   --rm --image yugabytedb/syugabyte-client \
#   --command -- ysqlsh -h yb-tserver \
#   -c "CREATE USER aks WITH PASSWORD 'aks';ALTER USER aks WITH SUPERUSER;"

kubectl exec --namespace $NAMESPACE_YUGA \
  -it yb-tserver-0 \
  -- /home/yugabyte/bin/ysqlsh \
  -h yb-tserver-0.yb-tservers.yugabyte \
  -c "CREATE USER aks WITH PASSWORD 'aks';ALTER USER aks WITH SUPERUSER;"

set +x
