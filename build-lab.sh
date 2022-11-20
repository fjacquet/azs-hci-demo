#!/usr/bin/env bash
az config set extension.use_dynamic_install=yes_without_prompt
. ./setenv.sh

. ./register-provider.sh

. ./create-rg.sh
. ./create-aks.sh
. ./create-dns-v2.sh
. ./create-pip.sh

. ./deploy-certmgr.sh
. ./deploy-hello.sh
. ./deploy-db.sh
. ./deploy-wikijs.sh

. ./deploy-jenkins.sh
. ./deploy-gitlab.sh

. ./deploy-monitoring.sh

podname=$(kubectl get pod -n $NAMESPACE_WIKIJS -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward -n $NAMESPACE_MONITORING $podname 3000
