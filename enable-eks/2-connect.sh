#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

# add feature
az extension add --name k8s-extension
az extension add --name connectedk8s
az extension add --name k8s-configuration
az extension add --name customlocation

# Create Arc connexion
az connectedk8s connect \
  --resource-group ${resourceGroup} \
  --name ${clusterName}

# Create permissions
kubectl create serviceaccount arc-user
kubectl create clusterrolebinding arc-user-binding \
  --clusterrole cluster-admin \
  --serviceaccount default:arc-user

# Get token to register
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

set +x
