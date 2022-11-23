#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### Kubeapps
#-----------------------------------------------------------------------------

helm upgrade --install kubeapps bitnami/kubeapps \
  -n $NAMESPACE_KUBEAPPS \
  -f config/values-kubeapps.yaml \
  --create-namespace --wait \
  --timeout=15m

kubectl create --namespace default \
  serviceaccount \
  kubeapps-operator

kubectl create clusterrolebinding kubeapps-operator \
  --clusterrole=cluster-admin \
  --serviceaccount=default:kubeapps-operator

kubectl apply -f secret-kubeapps.yml

kubectl get --namespace default secret kubeapps-operator-token \
  -o go-template='{{.data.token | base64decode}}'
kubectl port-forward -n $NAMESPACE_KUBEAPPS svc/kubeapps 8080:80 &
set +x
