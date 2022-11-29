#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
# -----------------------------
# activate feture
# -----------------------------
helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace $NAMESPACE_CERTMGR \
  --create-namespace \
  -f config/values.cert-manager.yaml \
  --wait

# -----------------------------
# validate deployment
# -----------------------------
. ./generate-test-ressource.sh
kubectl apply -f test-resources.yaml
kubectl describe certificate -n cert-manager-test
kubectl delete -f test-resources.yaml

. ./generate-test-acme-http.sh
kubectl apply -f test-acme.yaml

. ./generate-prod-acme-http.sh
kubectl apply -f prod-acme.yaml

set +x
