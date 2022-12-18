#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
export CLUSTER=dtrd-eks
export REGION=eu-west-3

eksctl delete cluster \
  --name $CLUSTER \
  --region $REGION \
  --force

set +x
