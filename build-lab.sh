#!/usr/bin/env bash

. ./setenv.sh
. ./register-provider.sh
. ./register-helm.sh
. ./create-rg.sh
. ./create-aks.sh
. ./create-dns.sh
. ./create-pip.sh

. ./deploy-nginx.sh
. ./deploy-monitoring.sh
. ./deploy-hello.sh
. ./deploy-certmgr.sh
. ./deploy-db.sh
. ./deploy-redis.sh

. ./deploy-wikijs.sh
. ./deploy-kubeapps.sh
. ./deploy-sonarqube.sh
. ./deploy-jenkins.sh
. ./deploy-gitlab.sh


