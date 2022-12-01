#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
cat <<-EOF >sample-app.yaml
apiVersion: v1
kind: Pod
metadata:
  name: webserver
  labels:
    app: nginx
    name: sample
spec:
  containers:
  - name: main
    image: nginx:alpine
    resources:
      limits:
        memory: "64Mi"
        cpu: "200m"
      requests:
        memory: "48Mi"
        cpu: "100m"
    ports:
      - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  selector:
    app: nginx
    name: sample
  ports:
  - port: 8080
    targetPort: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-rule
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/use-regex: "true"
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-staging"
spec:
  tls:
  - hosts:
      - hello.$AZ_DNS_DOMAIN
    secretName: hello-secret-tls
  rules:
    - host: "hello.$AZ_DNS_DOMAIN"
      http:
        paths:
          - path: /
            pathType: "Prefix"
            backend:
              service:
                name: web
                port:
                  number: 8080

EOF
kubectl apply -f sample-app.yaml
# rm sample-app.yaml
set +x
