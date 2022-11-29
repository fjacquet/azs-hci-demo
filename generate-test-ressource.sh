#!/usr/bin/env bash
# -*- coding: utf-8 -*-

cat <<EOF >test-resources.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager-test
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: test-selfsigned
  namespace: cert-manager-test
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: selfsigned-cert
  namespace: cert-manager-test
spec:
  dnsNames:
    - $AZ_DNS_DOMAIN
  secretName: selfsigned-cert-tls
  issuerRef:
    name: test-selfsigned
EOF
