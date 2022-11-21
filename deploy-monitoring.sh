#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### Prometheus
#-----------------------------------------------------------------------------

# Create a namespace for Prometheus and Grafana resources
kubectl create namespace $NAMESPACE_MONITORING

helm install prometheus-operator \
  prometheus-community/kube-prometheus-stack \
  -f values-monitoring.yaml \
  --namespace $NAMESPACE_MONITORING

kubectl -n $NAMESPACE_MONITORING get all -l "release=prometheus-operator"

# Check to see that all the Pods are running
kubectl get pods -n monitoring

# Other Useful Prometheus Operator Resources to Peruse
kubectl get prometheus -n $NAMESPACE_MONITORING
kubectl get prometheusrules -n $NAMESPACE_MONITORING
kubectl get servicemonitor -n $NAMESPACE_MONITORING
kubectl get cm -n $NAMESPACE_MONITORING
kubectl get secrets -n $NAMESPACE_MONITORING

# Install Prometheus using HELM
helm upgrade --install $DIST prometheus-community/kube-prometheus-stack -n $NAMESPACE_MONITORING \
  --set kubeEtcd.enabled=false \
  --set kubeControllerManager.enabled=false \
  --set kubeScheduler.enabled=false \
  --set kubelet.serviceMonitor.https=false
# Check all resources in Prometheus Namespace
kubectl get all -n $NAMESPACE_MONITORING
# Port forward the Prometheus service
kubectl port-forward -n $NAMESPACE_MONITORING prometheus-prometheus-kube-prometheus-prometheus-0 9090 &
# Get the Username
kubectl get secret -n $NAMESPACE_MONITORING prometheus-grafana -o=jsonpath='{.data.admin-user}' | base64 -d
# Get the Password
kubectl get secret -n $NAMESPACE_MONITORING prometheus-grafana -o=jsonpath='{.data.admin-password}' | base64 -d
# Port forward the Grafana service
set +x
