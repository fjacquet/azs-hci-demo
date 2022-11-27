#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### Prometheus
#-----------------------------------------------------------------------------
helm upgrade --install prometheus bitnami/kube-prometheus \
  --namespace $NAMESPACE_MONITORING \
  --create-namespace \
  --set prometheus.ingress.hostname=prometheus.$AZ_DNS_DOMAIN \
  -f config/values.kube-prometheus.yaml

#-----------------------------------------------------------------------------
#### grafana
#-----------------------------------------------------------------------------
helm upgrade --install grafana grafana/grafana \
  --set grafana.ingress.hostname=grafana.$AZ_DNS_DOMAIN \
  --namespace $NAMESPACE_MONITORING \
  --create-namespace \
  -f config/values.grafana-operator.yaml

set +x
