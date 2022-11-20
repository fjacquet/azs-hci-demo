#!/usr/bin/env bash

. ./setenv.sh

. ./register-provider.sh
. ./create-rg.sh
. ./create-aks.sh
. ./create-dns-v2.sh
. ./create-pip.sh

. ./deploy-hello.sh
. ./deploy-db.sh
. ./deploy-wikijs.sh

. ./deploy-jenkins.sh
. ./deploy-gitlab.sh

. ./deploy-monitoring.sh

podname=$(kubectl get pod -n $NAMESPACE_WIKIJS -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward -n $NAMESPACE_MONITORING $podname 3000
