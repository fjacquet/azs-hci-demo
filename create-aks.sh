#!/usr/bin/env bash

####  AKS
az group create --name yugabytedbRG --location switzerlandwest

az group create --name yugabytedbRG --location switzerlandnorth
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.ContainerService --wait

az aks create \
--resource-group yugabytedbRG \
--name yugabytedbAKSCluster \
--node-count 3 \
--node-vm-size Standard_D4ds_v4 \
--enable-addons monitoring \
--generate-ssh-keys


az aks get-credentials --resource-group yugabytedbRG --name yugabytedbAKSCluster

kubectl get nodes
kubectl create clusterrolebinding yb-kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard --user=clusterUser

az aks browse --resource-group yugabytedbRG --name yugabytedbAKSCluster


#### Yuga

helm repo add yugabytedb https://charts.yugabyte.com
helm repo update
helm search repo yugabytedb/yugabyte --version 2.15.3
kubectl create namespace yb-demo
helm install yb-demo -n yb-demo yugabytedb/yugabyte \
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

kubectl get pods --namespace yb-demo

kubectl get services --namespace yb-demo

####  benchmark
wget https://github.com/yugabyte/tpcc/releases/download/2.0/tpcc.tar.gz
tar -zxvf tpcc.tar.gz
cd tpcc


IPS=$(kubectl get service yb-master-ui  -n yb-demo --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
./tpccbenchmark --nodes=$IPS  --create=true
./tpccbenchmark --load=true --nodes=$IPS
./tpccbenchmark  --nodes=$IPS  --enable-foreign-keys=true
./tpccbenchmark --nodes=$IPS --execute=true


#### wikijs
helm repo add requarks https://charts.js.wiki

kubectl run ysqlsh-client -it --rm  --image yugabytedb/yugabyte-client --command -- ysqlsh -h yb-tservers.yb-demo.svc.cluster.local

create database wikijs;

helm upgrade --install my-release requarks/wiki -n wikijs \
  --set postgresql.enabled=false \
  --set ingres.enabled=true \
  --set externalPostgresql.databaseURL="postgresql://yugabyte@yb-tserver-service.yb-demo.svc.cluster.local:5433/wikijs?sslmode=disable"

podname=$(kubectl get pod -n wikijs -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward -n wikijs $podname 8081:3000

kubectl scale --replicas 5 deployment my-release-wiki -n wikijs

#### jenkins
helm install my-release azure-marketplace/jenkins


#### Prometheus
# Define public Kubernetes chart repository in the Helm configuration
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# Update local repositories
helm repo update
# Search for newly installed repositories
helm repo list
# Create a namespace for Prometheus and Grafana resources
kubectl create ns monitoring
# Install Prometheus using HELM
helm  upgrade --install prometheus prometheus-community/kube-prometheus-stack -n monitoring --values values.yml
# Check all resources in Prometheus Namespace
kubectl get all -n monitoring
# Port forward the Prometheus service
kubectl port-forward -n monitoring prometheus-prometheus-kube-prometheus-prometheus-0 9090# Get the Username
kubectl get secret -n monitoring prometheus-grafana -o=jsonpath='{.data.admin-user}' |base64 -d
# Get the Password
kubectl get secret -n monitoring prometheus-grafana -o=jsonpath='{.data.admin-password}' |base64 -d
# Port forward the Grafana service
kubectl port-forward -n monitoring prometheus-grafana-5449b6ccc9-b4dv4 3000


sub=$(az account subscription list -o tsv |cut -f3)
scope="$sub/resourceGroups/yugabytedbRG"
az ad sp create-for-rbac --role="Monitoring Reader" --scopes=$scope