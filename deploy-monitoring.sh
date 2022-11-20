#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#-----------------------------------------------------------------------------
#### Prometheus
#-----------------------------------------------------------------------------
# Define public Kubernetes chart repository in the Helm configuration
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# Update local repositories
helm repo update
# Search for newly installed repositories
helm repo list
# Create a namespace for Prometheus and Grafana resources
kubectl create ns $MONITORING_NAMESPACE
# Install Prometheus using HELM
helm upgrade --install $DIST prometheus-community/kube-prometheus-stack -n $MONITORING_NAMESPACE \
  --set kubeEtcd.enabled=false \
  --set kubeControllerManager.enabled=false \
  --set kubeScheduler.enabled=false \
  --set kubelet.serviceMonitor.https=false
# Check all resources in Prometheus Namespace
kubectl get all -n $MONITORING_NAMESPACE
# Port forward the Prometheus service
kubectl port-forward -n $MONITORING_NAMESPACE prometheus-prometheus-kube-prometheus-prometheus-0 9090 &
# Get the Username
kubectl get secret -n $MONITORING_NAMESPACE prometheus-grafana -o=jsonpath='{.data.admin-user}' | base64 -d
# Get the Password
kubectl get secret -n $MONITORING_NAMESPACE prometheus-grafana -o=jsonpath='{.data.admin-password}' | base64 -d
# Port forward the Grafana service
