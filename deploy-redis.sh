#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### redis
#-----------------------------------------------------------------------------
helm upgrade --install $DIST bitnami/redis \
  -f values-redis-cluster.yaml

set +x
