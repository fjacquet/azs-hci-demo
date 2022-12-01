#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
kubectl apply -f whoami/001-app.yaml
kubectl apply -f whoami/002-service.yaml
kubectl apply -f whoami/003-lets-encrypt.yaml
kubectl apply -f whoami/004-lets-encrypt-cert.yaml
kubectl get certificate
kubectl apply -f whoami/005-ingress-route-https.yaml

# kubectl create secret tls mysecretname --key mycert.key --cert mycert.crt
set +x
