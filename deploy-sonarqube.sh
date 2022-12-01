#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

helm upgrade --install sonarqube bitnami/sonarqube \
  --namespace $NAMESPACE_SONAR \
  -f config/values.sonarqube.yaml \
  --create-namespace

set +x
