#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### Prometheus
#-----------------------------------------------------------------------------

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  -f config/values-mon.yaml \
  --create-namespace \
  --namespace $NAMESPACE_MONITORING \
  --wait \
  --timeout=15m
sleep 15
kubectl -n $NAMESPACE_MONITORING get all -l "release=prometheus"

# Check to see that all the Pods are running
kubectl get pods -n $NAMESPACE_MONITORING

# Other Useful Prometheus Operator Resources to Peruse
kubectl get prometheus -n $NAMESPACE_MONITORING
kubectl get prometheusrules -n $NAMESPACE_MONITORING
kubectl get servicemonitor -n $NAMESPACE_MONITORING
kubectl get cm -n $NAMESPACE_MONITORING
kubectl get secrets -n $NAMESPACE_MONITORING

helm upgrade --install nginx-ingress nginx/ingress-nginx \
  --namespace $NAMESPACE_INGRESS \
  --set controller.metrics.enabled=true \
  --set controller.metrics.serviceMonitor.enabled=true \
  --set controller.metrics.serviceMonitor.additionalLabels.release="prometheus" \
  --wait \
  --timeout=15m

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace $NAMESPACE_MONITORING \
  --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --wait \
  --timeout=15m

# Install Prometheus using HELM
# helm upgrade --install $DIST prometheus-community/kube-prometheus-stack -n $NAMESPACE_MONITORING \
#   --set kubeEtcd.enabled=false \
#   --set kubeControllerManager.enabled=false \
#   --set kubeScheduler.enabled=false \
#   --set kubelet.serviceMonitor.https=false
# Check all resources in Prometheus Namespace
kubectl get all -n $NAMESPACE_MONITORING
# Port forward the Prometheus service
# kubectl port-forward -n $NAMESPACE_MONITORING prometheus-prometheus-kube-prometheus-prometheus-0 9090 &
# # Get the Username
kubectl get secret -n $NAMESPACE_MONITORING prometheus-grafana -o=jsonpath='{.data.admin-user}' | base64 -d
# Get the Password
kubectl get secret -n $NAMESPACE_MONITORING prometheus-grafana -o=jsonpath='{.data.admin-password}' | base64 -d
podname=$(kubectl get pod -n $NAMESPACE_MONITORING -l app.kubernetes.io/name=grafana -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward -n $NAMESPACE_MONITORING $podname 3000
set +x
