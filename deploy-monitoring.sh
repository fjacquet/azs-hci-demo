#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

#-----------------------------------------------------------------------------
#### nginx ingress
#-----------------------------------------------------------------------------
helm upgrade --install ingress-nginx nginx/ingress-nginx \
  --namespace $NAMESPACE_INGRESS \
  --create-namespace \
  --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
  --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
  -f config/values.nginx-ingress-controller.yaml

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
helm upgrade --install grafana bitnami/grafana-operator \
  --set grafana.ingress.hostname=grafana.$AZ_DNS_DOMAIN \
  --namespace $NAMESPACE_MONITORING \
  --create-namespace \
  -f config/values.grafana-operator.yaml

#-----------------------------------------------------------------------------
#### nginx ingress monitoring
#-----------------------------------------------------------------------------
helm upgrade --install ingress-nginx nginx/ingress-nginx \
  --namespace $NAMESPACE_INGRESS \
  --set metrics.enabled=true
set +x
