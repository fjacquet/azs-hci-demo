#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### redis
#-----------------------------------------------------------------------------
helm upgrade --install $DIST bitnami/redis \
  -f config/values-redis-cluster.yaml \
  --create-namespace \
  --namespace $NAMESPACE_REDIS \
  --wait \
  --timeout=15m

set +x
