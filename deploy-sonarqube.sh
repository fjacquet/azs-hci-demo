#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
kubectl exec --namespace yugabyte \
  -it yb-tserver-0 \
  -- /home/yugabyte/bin/ysqlsh \
  -h yb-tserver-0.yb-tservers.yugabyte \
  -c "DROP database sonarqube  ;"

kubectl exec --namespace yugabyte \
  -it yb-tserver-0 \
  -- /home/yugabyte/bin/ysqlsh \
  -h yb-tserver-0.yb-tservers.yugabyte \
  -c "CREATE database sonarqube  ;"

helm upgrade --install sonarqube bitnami/sonarqube \
  -f config/values-sonar.yaml \
  --namespace $NAMESPACE_SONAR \
  --create-namespace \
  --wait \
  --timeout=15m

set +x
