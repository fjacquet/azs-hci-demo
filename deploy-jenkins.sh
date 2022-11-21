#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### jenkins
#-----------------------------------------------------------------------------

helm upgrade --install -f values-jenkins.yaml myjenkins jenkins/jenkins
kubectl exec --namespace default -it svc/myjenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
kubectl --namespace default port-forward svc/myjenkins 8080:8080
set +x
