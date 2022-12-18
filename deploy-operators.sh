#!/usr/bin/env bash
# -*- coding: utf-8 -*-

curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.22.0/install.sh | bash -s v0.22.0
kubectl create -f https://operatorhub.io/install/elastic-cloud-eck.yaml
# kubectl create -f https://operatorhub.io/install/cert-manager.yaml
kubectl create -f https://operatorhub.io/install/dell-csm-operator.yaml

kubectl create -f https://operatorhub.io/install/dell-csi-operator.yaml

kubectl create -f https://operatorhub.io/install/minio-operator.yaml
kubectl create -f https://operatorhub.io/install/istio.yaml
kubectl get csv -n operators
