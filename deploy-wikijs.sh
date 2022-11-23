#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### wikijs
#-----------------------------------------------------------------------------

# connect to DB

kubectl exec --namespace yugabyte -it yb-tserver-0 -- /home/yugabyte/bin/ysqlsh -h yb-tserver-0.yb-tservers.yugabyte -c "create database wikijs;"
# create DB
helm upgrade --install $DIST requarks/wiki \
  --create-namespace \
  -n $NAMESPACE_WIKIJS \
  -f config/values-wiki.yaml \
  --wait \
  --timeout=15m

#
set +x
