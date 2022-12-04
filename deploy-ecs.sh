#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -x
# push definitions
kubectl create -f https://download.elastic.co/downloads/eck/2.5.0/crds.yaml
# push operator
kubectl apply -f https://download.elastic.co/downloads/eck/2.5.0/operator.yaml
# wait operator
kubectl -n elastic-system logs -f statefulset.apps/elastic-operator

kubectl apply -f yaml/eck-demo.yaml

# check completion
kubectl get elasticsearch

kubectl get service elasticsearch-es-http

PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')

kubectl port-forward service/elasticsearch-es-http 9200

curl -u "elastic:$PASSWORD" -k "https://localhost:9200"

kubectl get kibana

kubectl get service elasticsearch-kb-http

kubectl port-forward service/elasticsearch-kb-http 5601

kubectl get secret elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode && echo

set +x
