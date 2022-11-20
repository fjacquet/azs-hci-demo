#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#-----------------------------------------------------------------------------
# demo tpcc benchmark
#-----------------------------------------------------------------------------
wget https://github.com/yugabyte/tpcc/releases/download/2.0/tpcc.tar.gz
tar -zxvf tpcc.tar.gz
cd tpcc

IPS=$(kubectl get service yb-master-ui -n $YUGA_NAMESPACE --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
./tpccbenchmark --nodes=$IPS --create=true
./tpccbenchmark --nodes=$IPS --load=true
./tpccbenchmark --nodes=$IPS --enable-foreign-keys=true
./tpccbenchmark --nodes=$IPS --execute=true
