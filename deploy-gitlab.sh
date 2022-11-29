#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### gitlab
#-----------------------------------------------------------------------------

# kubectl run ysqlsh-client -n $NAMESPACE_YUGA -it --rm --image yugabytedb/yugabyte-client \
#   --command -- ysqlsh -h yb-tservers -c "CREATE DATABASE gitlab;"
# kubectl run ysqlsh-client -n $NAMESPACE_YUGA -it --rm --image yugabytedb/yugabyte-client \
#   --command -- ysqlsh -h yb-tservers -c "CREATE DATABASE gitlab;"

kubectl create secret generic gitlab-postgresql-password \
  --from-literal=postgresql-password=$(head -c 512 /dev/urandom | LC_CTYPE=C tr -cd 'a-zA-Z0-9' | head -c 64) \
  --from-literal=postgresql-postgres-password=$(head -c 512 /dev/urandom | LC_CTYPE=C tr -cd 'a-zA-Z0-9' | head -c 64)

helm upgrade --install gitlab gitlab/gitlab \
  -f config/values.gitlab.yaml \
  -n $NAMESPACE_GITLAB \
  --create-namespace

kubectl get ingress -lrelease=gitlab \
  -n $NAMESPACE_GITLAB

kubectl get secret gitlab-gitlab-initial-root-password \
  -ojsonpath='{.data.password}' \
  -n $NAMESPACE_GITLAB | base64 --decode
# echo
set +x
