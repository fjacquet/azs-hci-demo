#!/usr/bin/env bash
# -*- coding: utf-8 -*-
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
