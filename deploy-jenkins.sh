#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### jenkins
#-----------------------------------------------------------------------------

helm upgrade --install jenkins bitnami/jenkins \
  --create-namespace \
  -n $NAMESPACE_JENKINS \
  -f config/values.jenkins.yaml --wait

# kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-password}" | base64 -d
set +x
