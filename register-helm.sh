
. ./deploy-jenkins.sh
#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

# Define public Kubernetes chart repository in the Helm configuration
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add gitlab https://charts.gitlab.io/
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jenkins https://charts.jenkins.io
helm repo add jetstack https://charts.jetstack.io
helm repo add nginx https://kubernetes.github.io/ingress-nginx
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add requarks https://charts.js.wiki
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo add stable https://charts.helm.sh/stable
helm repo add yugabytedb https://charts.yugabyte.com

# Update local repositories
helm repo update

set +x
