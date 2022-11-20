#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#-----------------------------------------------------------------------------
#### Kubeapps
#-----------------------------------------------------------------------------
helm repo add bitnami https://charts.bitnami.com/bitnami

helm upgrade --install -n $NAMESPACE_KUBEAPPS --create-namespace $NAMESPACE_KUBEAPPS bitnami/kubeapps

kubectl create --namespace default serviceaccount kubeapps-operator
kubectl create clusterrolebinding kubeapps-operator \
  --clusterrole=cluster-admin \
  --serviceaccount=default:kubeapps-operator

kubectl apply -f kubeapps-secret.yml

kubectl get --namespace default secret kubeapps-operator-token -o go-template='{{.data.token | base64decode}}'
kubectl port-forward -n $NAMESPACE_KUBEAPPS svc/kubeapps 8080:80 &
