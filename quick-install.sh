#!/usr/bin/env bash
# -*- coding: utf-8 -*-

git clone https://github.com/kubernetes-csi/external-snapshotter/
cd ./external-snapshotter
git checkout release-6.1
kubectl kustomize client/config/crd | kubectl create -f -
kubectl -n kube-system kustomize deploy/kubernetes/snapshot-controller | kubectl create -f -

cd ..

# CSI
kubectl create namespace isilon
kubectl create secret generic isilon-creds \
  -n isilon \
  --from-file=config=my/secret.yaml \
  -o yaml \
  --dry-run=client | kubectl apply -f -

kubectl create \
  -f my/empty-secret.yaml

# kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-3.0/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml

# kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-3.0/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml

# helm install csi-isilon dell/csi-isilon -n isilon -f my/values.yaml

cd dell-csi-helm-installer && ./csi-install.sh \
  --namespace isilon \
  --values ../../azs-hci-demo/my/values.yaml

cd ../dell-csi-operator
kubectl create -f my/sc.yaml
kubectl create -f my/vsc.yaml
kubectl create -f my/pvc.yaml

# CSM
kubectl create namespace karavi
kubectl get secret isilon-creds \
  -n isilon \
  -o yaml |
  sed 's/namespace: isilon/namespace: karavi/' |
  kubectl create -f -

kubectl get configmap isilon-config-params \
  -o yaml |
  sed 's/namespace: isilon/namespace: karavi/' |
  kubectl create -f

kubectl get secret karavi-authorization-config proxy-server-root-certificate proxy-authz-tokens \
  -n isilon \
  -o yaml |
  sed 's/namespace: isilon/namespace: karavi/' |
  sed 's/name: karavi-authorization-config/name: isilon-karavi-authorization-config/' |
  sed 's/name: proxy-server-root-certificate/name: isilon-proxy-server-root-certificate/' |
  sed 's/name: proxy-authz-tokens/name: isilon-proxy-authz-tokens/' |
  kubectl create -f -

helm install karavi-observability dell/karavi-observability -n karavi -f my/karavi-values.yaml
