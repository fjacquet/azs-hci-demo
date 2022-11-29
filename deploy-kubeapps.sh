#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### prepare secret
#-----------------------------------------------------------------------------
kubectl create namespace $NAMESPACE_KUBEAPPS

. ./generate-secret-kubeapps.sh
kubectl apply -f secret-kubeapps.yaml
rm secret-kubeapps.yml

#-----------------------------------------------------------------------------
#### Kubeapps
#-----------------------------------------------------------------------------

helm upgrade --install kubeapps bitnami/kubeapps \
  -n $NAMESPACE_KUBEAPPS \
  --create-namespace \
  -f config/values.kubeapps.yaml
# --wait \
# --timeout=15m # \

kubectl create -n $NAMESPACE_KUBEAPPS \
  serviceaccount \
  kubeapps-operator

kubectl create clusterrolebinding kubeapps-operator \
  --clusterrole=cluster-admin -n $NAMESPACE_KUBEAPPS --serviceaccount=kubeapps:kubeapps-operator

kubectl get secret $(kubectl get serviceaccount -n $NAMESPACE_KUBEAPPS kubeapps-operator \
  -o jsonpath='{range .secrets[*]}{.name}{"\n"}{end}' |
  grep kubeapps-operator-token) -n $NAMESPACE_KUBEAPPS \
  -o jsonpath='{.data.token}' \
  -o go-template='{{.data.token  | base64decode}}' && echo

# kubectl port-forward -n $NAMESPACE_KUBEAPPS svc/kubeapps 8080:80 &
set +x
