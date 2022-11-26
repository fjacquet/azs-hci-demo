#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#-----------------------------------------------------------------------------
#### Yugabyte storage
#-----------------------------------------------------------------------------
set -x

helm upgrade --install yugabyte yugabytedb/yugabyte \
  -n $NAMESPACE_YUGA \
  --create-namespace \
  -f config/values.yugabyte.yaml \
  --wait

sleep 300

kubectl get pods --namespace $NAMESPACE_YUGA
kubectl get services --namespace $NAMESPACE_YUGA

# connect to DB
kubectl exec --namespace $NAMESPACE_YUGA \
  -it yb-tserver-0 \
  -- /home/yugabyte/bin/ysqlsh \
  -h yb-tserver-0.yb-tservers.yugabyte \
  -c "CREATE USER aks WITH PASSWORD 'aks';ALTER USER aks WITH SUPERUSER;"

set +x
