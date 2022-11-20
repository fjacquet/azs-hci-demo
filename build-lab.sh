#!/usr/bin/env bash

. ./setenv.sh

. ./register-provider.sh
. ./create-rg.sh
. ./create-dns.sh
. ./create-aks.sh
. ./create-pip.sh

. ./deploy-db.sh
. ./deploy-wikijs.sh

. ./deploy-jenkins.sh
. ./deploy-gitlab.sh

. ./deploy-monitoring.sh



podname=$(kubectl get pod -n $WIKIJS_NAMESPACE -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward -n $MONITORING_NAMESPACE $podname 3000
