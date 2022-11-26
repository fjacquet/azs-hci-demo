#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### prepare secret
#-----------------------------------------------------------------------------
kubectl create namespace $NAMESPACE_KUBEAPPS

cat <<EOF >secret-kubeapps.yaml
apiVersion: v1
kind: Secret
metadata:
  name: kubeapps-operator-token
  namespace: $NAMESPACE_KUBEAPPS
  annotations:
    kubernetes.io/service-account.name: kubeapps-operator
type: kubernetes.io/service-account-token
EOF
kubectl apply -f secret-kubeapps.yaml
rm secret-kubeapps.yml

#-----------------------------------------------------------------------------
#### Kubeapps
#-----------------------------------------------------------------------------

helm upgrade --install kubeapps bitnami/kubeapps \
  -n $NAMESPACE_KUBEAPPS \
  -f config/values.kubeapps.yaml \
  --set ingress.hostname=apps.$AZ_DNS_DOMAIN \
  --create-namespace
# --wait \
# --timeout=15m # \

kubectl create -n $NAMESPACE_KUBEAPPS \
  serviceaccount \
  kubeapps-operator

kubectl create clusterrolebinding kubeapps-operator \
  --clusterrole=cluster-admin \
  --serviceaccount=default:kubeapps-operator

kubectl get -n $NAMESPACE_KUBEAPPS secret kubeapps-operator-token \
  -o go-template='{{.data.token | base64decode}}'

# kubectl port-forward -n $NAMESPACE_KUBEAPPS svc/kubeapps 8080:80 &
set +x
