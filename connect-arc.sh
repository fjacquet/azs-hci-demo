#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

az connectedk8s connect --resource-group fred --name arcks

kubectl create serviceaccount arc-user
kubectl create clusterrolebinding arc-user-binding --clusterrole cluster-admin --serviceaccount default:arc-user

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: arc-user-secret
  annotations:
    kubernetes.io/service-account.name: arc-user
type: kubernetes.io/service-account-token
EOF
TOKEN=$(kubectl get secret arc-user-secret -o jsonpath='{$.data.token}' | base64 -d | sed 's/$/\n/g')
echo $TOKEN

az postgres server-arc create -n postgres01 --k8s-namespace lausanne --use-k8s
az postgres server-arc list --k8s-namespace lausanne --use-k8s

az network public-ip list -g azurearcvm-rg --query "[].{PublicIP:ipAddress}" -o table

set +x
