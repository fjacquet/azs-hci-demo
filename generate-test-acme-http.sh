#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# -----------------------------
# create issuer test
# -----------------------------
cat <<EOF >test-acme.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
  namespace: $NAMESPACE_CERTMGR
spec:
  acme:
    email: $ACME_ISSUER_EMAIL
    # ACME server URL for Let’s Encrypt’s staging environment.
    # The staging environment will not issue trusted certificates but is
    # used to ensure that the verification process is working properly
    # before moving to production
    server: https://acme-staging-v02.api.letsencrypt.org/directory

    privateKeySecretRef:
      # Secret resource used to store the account's private key.
      name: letsencrypt-staging-secret
    solvers:
      - http01:
          ingress:
            class: nginx
            podTemplate:
              spec:
                nodeSelector:
                  "kubernetes.io/os": linux

EOF
