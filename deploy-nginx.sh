#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### nginx
#-----------------------------------------------------------------------------

# Deploy ingress to Kubernetes
helm upgrade --install nginx-ingress nginx/ingress-nginx \
  --wait \
  --create-namespace \
  --namespace $NAMESPACE_INGRESS \
  -f config/values-nginx.yaml

kubectl get all -n $NAMESPACE_INGRESS
set +x
