#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
kubectl create namespace longhorn-system
helm install longhorn longhorn/longhorn --namespace longhorn-system
set +x

