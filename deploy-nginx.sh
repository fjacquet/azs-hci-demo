#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### nginx
#-----------------------------------------------------------------------------

# Create Kubernetes namespace
kubectl create namespace $NAMESPACE_INGRESS

# Deploy ingress to Kubernetes
helm upgrade --install nginx-ingress nginx/ingress-nginx \
  --wait \
  --namespace $NAMESPACE_INGRESS \
  --set controller.metrics.enabled=true \
  --set controller.metrics.serviceMonitor.enabled=true \
  --set controller.metrics.serviceMonitor.additionalLabels.release="prometheus" \
  --set-string controller.podAnnotations."prometheus\.io/scrape"="true" \
  --set-string controller.podAnnotations."prometheus\.io/port"="10254" \
  --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false

set +x
