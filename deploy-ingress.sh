#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### traefik
#----------------------------------------------------------------------------
helm upgrade --install traefik traefik/traefik \
  --create-namespace \
  -f config/values.traefik.yaml --wait
#-----------------------------------------------------------------------------
#### nginx ingress
#-----------------------------------------------------------------------------
helm upgrade --install ingress-nginx nginx/ingress-nginx \
  --namespace $NAMESPACE_INGRESS \
  --create-namespace \
  -f config/values.ingress-nginx.yaml
set +x
