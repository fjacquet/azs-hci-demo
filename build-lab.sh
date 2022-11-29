#!/usr/bin/env bash

. ./setenv.sh
. ./register-provider.sh
. ./register-helm.sh
. ./create-rg.sh
. ./create-aks.sh
. ./create-dns.sh
. ./deploy-extdns.sh
. ./deploy-ingress.sh
# . ./create-pip.sh

. ./deploy-monitoring.sh
. ./deploy-certmgr.sh
. ./deploy-hello.sh
. ./deploy-kuard.sh
# . ./deploy-whoami.sh
. ./deploy-db.sh
# . ./deploy-redis.sh

. ./deploy-wikijs.sh
. ./deploy-kubeapps.sh
. ./deploy-sonarqube.sh
. ./deploy-jenkins.sh
. ./deploy-keycloak.sh
. ./deploy-gitlab.sh
