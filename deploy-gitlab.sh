#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### gitlab
#-----------------------------------------------------------------------------

kubectl create secret generic gitlab-postgresql-password \
  --from-literal=postgresql-password=$(head -c 512 /dev/urandom | LC_CTYPE=C tr -cd 'a-zA-Z0-9' | head -c 64) \
  --from-literal=postgresql-postgres-password=$(head -c 512 /dev/urandom | LC_CTYPE=C tr -cd 'a-zA-Z0-9' | head -c 64)

helm upgrade --install gitlab gitlab/gitlab \
  --set global.hosts.domain=$AZ_DNS_DOMAIN \
  --set certmanager-issuer.ACME_ISSUER_EMAIL=$ACME_ISSUER_EMAIL \
  --set postgresql.install=false \
  --set global.psql.host=yb-tserver-service.$NAMESPACE_YUGA.svc.cluster.local \
  --set global.psql.password.secret=gitlab-postgresql-password \
  --set global.psql.password.key=postgres-password \
  --set global.psql.port: 5433 \
  --set global.psql.database: gitlab \
  --set global.psql.username: yugabyte \
  --set redis.install=false \
  --set global.redis.host=redis.$NAMESPACE_YUGA.svc.cluster.local \
  --set global.redis.password.secret=gitlab-redis \
  --set global.redis.password.key=redis-password \
  kubectl get ingress -lrelease=gitlab

kubectl get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode
# echo
set +x
