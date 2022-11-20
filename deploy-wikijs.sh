#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#-----------------------------------------------------------------------------
#### wikijs
#-----------------------------------------------------------------------------
helm repo add requarks https://charts.js.wiki
# connect to DB
kubectl run ysqlsh-client -it --rm --image yugabytedb/yugabyte-client \
  --command -- ysqlsh -h yb-tservers.$RESOURCE_GROUP_AKS.svc.cluster.local
# create DB
create database wikijs

helm upgrade --install $DIST requarks/wiki -n $NAMESPACE_WIKIJS \
  --set postgresql.enabled=false \
  --set ingres.enabled=true \
  --set externalPostgresql.databaseURL="postgresql://yugabyte@yb-tserver-service.$RESOURCE_GROUP_AKS.svc.cluster.local:5433/wikijs?sslmode=disable"

podname=$(kubectl get pod -n $NAMESPACE_WIKIJS -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward -n $NAMESPACE_WIKIJS $podname 8081:3000
kubectl scale --replicas 5 deployment $DIST-wiki -n $NAMESPACE_WIKIJS
