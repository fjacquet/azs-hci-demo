#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### Kubeapps
#-----------------------------------------------------------------------------

helm upgrade --install keycloak bitnami/keycloak \
  -n $NAMESPACE_KEYCLOAK \
  -f config/values.keycloak.yaml \
  --create-namespace --wait \
  --timeout=15m

set +x
