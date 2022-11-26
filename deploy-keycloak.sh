#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### Kubeapps
#-----------------------------------------------------------------------------

helm upgrade --install keycloak bitnami/keycloak \
  -n $NAMESPACE_KEYCLOAK \
  --set auth.adminPassword=delltech \
  --set ingress.enabled=true \
  --set ingress.ingressClassName=nginx \
  --set ingress.hostname=keycloak.$AZ_DNS_DOMAIN \
  --create-namespace --wait \
  --timeout=15m # -f config/values-keycloak.yaml \
# \

set +x
