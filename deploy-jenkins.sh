#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### jenkins
#-----------------------------------------------------------------------------

helm upgrade --install \
  -f config/values-jenkins.yaml \
  myjenkins jenkins/jenkins \
  --create-namespace \
  -n $NAMESPACE_JENKINS \
  --wait \
  --timeout=15m
kubectl exec --namespace $NAMESPACE_JENKINS \
  -it svc/myjenkins \
  -c jenkins \
  -- /bin/cat /run/secrets/additional/chart-admin-password && echo kubectl \
  --namespace $NAMESPACE_JENKINS port-forward svc/myjenkins 8080:8080
set +x
