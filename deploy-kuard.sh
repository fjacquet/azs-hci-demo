#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
#### Kubeapps
#-----------------------------------------------------------------------------

kubectl apply -f yaml/kuard.yaml

kubectl describe certificate quickstart-example-tls

set +x
