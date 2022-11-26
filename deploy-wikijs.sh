#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

# connect to DB
#-----------------------------------------------------------------------------
# cleanup if needed
kubectl exec \
  --namespace $NAMESPACE_YUGA \
  -it yb-tserver-0 \
  -- /home/yugabyte/bin/ysqlsh \
  -h yb-tserver-0.yb-tservers.yugabyte \
  -c "DROP DATABASE wikijs;"
# create db
kubectl exec \
  --namespace $NAMESPACE_YUGA \
  -it yb-tserver-0 \
  -- /home/yugabyte/bin/ysqlsh \
  -h yb-tserver-0.yb-tservers.yugabyte \
  -c "CREATE DATABASE wikijs;"

#-----------------------------------------------------------------------------
#### wikijs
#-----------------------------------------------------------------------------

helm upgrade --install $DIST requarks/wiki \
  --create-namespace \
  -n $NAMESPACE_WIKIJS \
  -f config/values.wiki.yaml
# --wait \
# --timeout=15m

#
set +x
