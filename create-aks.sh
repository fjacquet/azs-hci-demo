#!/usr/bin/env bash

REGION=switzerlandnorth
SIZE=Standard_D4ds_v5
RSGRP=aksrg
AKSNAME=akscluster
YBNS=dbns
WJNS=wikijs
PNS=monitoring

####  ressource group
az group create --name $RSGRP --location switzerlandwest
# oups ...
s
az group create --name $RSGRP --location $REGION
# add provider
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.ContainerService --wait

####  AKS
az aks create \
--resource-group yugabytedbRG \
--name yugabytedbAKSCluster \
--node-count 3 \
--node-vm-size $SIZE \
--enable-addons monitoring \
--generate-ssh-keys


az aks get-credentials --resource-group $RSGRP --name $AKSNAME
kubectl get nodes
kubectl create clusterrolebinding yb-kubernetes-dashboard --clusterrole=cluster-admin \
--serviceaccount=kube-system:kubernetes-dashboard --user=clusterUser
az aks browse --resource-group $RSGRP --name $AKSNAME


#### Yuga
helm repo add yugabytedb https://charts.yugabyte.com
helm repo update
helm search repo yugabytedb/yugabyte --version 2.15.3
kubectl create namespace $YBNS
helm install yb-demo -n $YBNS yugabytedb/yugabyte \
--version 2.15.3 \
--set storage.master.count=3 \
--set storage.tserver.count=3 \
--set storage.master.storageClass=default \
--set storage.tserver.storageClass=default \
--set resource.master.requests.cpu=1 \
--set resource.master.requests.memory=1Gi \
--set resource.tserver.requests.cpu=1 \
--set resource.tserver.requests.memory=1Gi \
--set resource.master.limits.cpu=1 \
--set resource.master.limits.memory=1Gi \
--set resource.tserver.limits.cpu=1 \
--set resource.tserver.limits.memory=1Gi \
--timeout=15m

kubectl get pods --namespace $YBNS
kubectl get services --namespace $YBNS

####  benchmark
wget https://github.com/yugabyte/tpcc/releases/download/2.0/tpcc.tar.gz
tar -zxvf tpcc.tar.gz
cd tpcc


IPS=$(kubectl get service yb-master-ui  -n $YBNS --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
./tpccbenchmark --nodes=$IPS --create=true
./tpccbenchmark --nodes=$IPS --load=true
./tpccbenchmark --nodes=$IPS --enable-foreign-keys=true
./tpccbenchmark --nodes=$IPS --execute=true


#### wikijs
helm repo add requarks https://charts.js.wiki
# connect to DB
kubectl run ysqlsh-client -it --rm  --image yugabytedb/yugabyte-client \
--command -- ysqlsh -h yb-tservers.$RSGRP.svc.cluster.local
# create DB
create database wikijs;

helm upgrade --install lab requarks/wiki -n $WJNS \
--set postgresql.enabled=false \
--set ingres.enabled=true \
--set externalPostgresql.databaseURL="postgresql://yugabyte@yb-tserver-service.$RSGRP.svc.cluster.local:5433/wikijs?sslmode=disable"


podname=$(kubectl get pod -n $WJNS -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward -n $WJNS $podname 8081:3000
kubectl scale --replicas 5 deployment lab-wiki -n $WJNS

#### jenkins
helm install lab azure-marketplace/jenkins




#### Prometheus
# Define public Kubernetes chart repository in the Helm configuration
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# Update local repositories
helm repo update
# Search for newly installed repositories
helm repo list
# Create a namespace for Prometheus and Grafana resources
kubectl create ns $PNS
# Install Prometheus using HELM
helm  upgrade --install prometheus prometheus-community/kube-prometheus-stack -n $PNS\
--set kubeEtcd.enabled=false \
--set kubeControllerManager.enabled=false \
--set kubeScheduler.enabled=false \
--set kubelet.serviceMonitor.https=false
# Check all resources in Prometheus Namespace
kubectl get all -n $PNS
# Port forward the Prometheus service
kubectl port-forward -n $PNS prometheus-prometheus-kube-prometheus-prometheus-0 9090
# Get the Username
kubectl get secret -n $PNS prometheus-grafana -o=jsonpath='{.data.admin-user}' |base64 -d
# Get the Password
kubectl get secret -n $PNS prometheus-grafana -o=jsonpath='{.data.admin-password}' |base64 -d
# Port forward the Grafana service


#### nginx
helm upgrade ingress-nginx ingress-nginx \
--repo https://kubernetes.github.io/ingress-nginx \
--namespace ingress-nginx \
--set controller.metrics.enabled=true \
--set controller.metrics.serviceMonitor.enabled=true \
--set controller.metrics.serviceMonitor.additionalLabels.release="prometheus"\
--set-string controller.podAnnotations."prometheus\.io/scrape"="true" \
--set-string controller.podAnnotations."prometheus\.io/port"="10254" \
--set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false


podname=$(kubectl get pod -n $WJNS -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward -n $PNS prometheus-grafana-5449b6ccc9-b4dv4 3000

# Enable access
sub=$(az account subscription list -o tsv |cut -f3)
scope="$sub/resourceGroups/$YBNS"
az ad sp create-for-rbac --role="Monitoring Reader" --scopes=$scope
