#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### Yugabyte storage
#-----------------------------------------------------------------------------
set -x

helm install yb-demo -n $NAMESPACE_YUGA yugabytedb/yugabyte \
  --version 2.15.3 \
  --create-namespace \
  --set storage.master.count=3 \
  --set storage.tserver.count=3 \
  --set storage.master.storageClass=default \
  --set storage.tserver.storageClass=default \
  --set resource.master.requests.cpu=1 \
  --set resource.master.requests.memory=1Gi \
  --set resource.tserver.requests.cpu=1 \
  --set resource.tserver.requests.memory=1Gi \
  --set resource.master.limits.cpu=1 \
  --set resource.master.limits.memory=1Gi \
  --set resource.tserver.limits.cpu=1 \
  --set resource.tserver.limits.memory=1Gi \
  --set domainName=db.$AZ_DNS_DOMAIN \
  --timeout=15m

kubectl get pods --namespace $NAMESPACE_YUGA
kubectl get services --namespace $NAMESPACE_YUGA

cat <<-EOF >yuga-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: yuga-rule
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
    - host: "db.$AZ_DNS_DOMAIN"
      http:
        paths:
          - path: /
            pathType: "Prefix"
            backend:
              service:
                name: yb-master-ui.$NAMESPACE_YUGA
                port:
                  number: 7000
EOF
kubectl apply -f yuga-ingress.yaml
rm yuga-ingress.yaml
set +x
