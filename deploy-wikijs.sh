#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### wikijs
#-----------------------------------------------------------------------------

# connect to DB
kubectl run ysqlsh-client -it --rm --image yugabytedb/yugabyte-client \
  --command -- echo "create database wikijs;" | ysqlsh -h yb-tservers.$NAMESPACE_YUGA.svc.cluster.local
# create DB
# create database wikijs
helm upgrade --install $DIST requarks/wiki \
  --create-namespace \
  -n $NAMESPACE_WIKIJS \
  --set postgresql.enabled=false \
  --set ingres.enabled=true \
  --set ingress.annotations='{"kubernetes.io/ingress.class": "nginx"}' \
  --set ingress.hosts=[{"host": "wiki.$AZ_DNS_DOMAIN", "paths": ["/"]}] \
  --set externalPostgresql.databaseURL="postgresql://yugabyte@yb-tserver-service.$NAMESPACE_YUGA.svc.cluster.local:5433/wikijs?sslmode=disable"

podname=$(kubectl get pod -n $NAMESPACE_WIKIJS -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward -n $NAMESPACE_WIKIJS $podname 8081:3000
kubectl scale --replicas 5 deployment $DIST-wiki -n $NAMESPACE_WIKIJS
set +x
