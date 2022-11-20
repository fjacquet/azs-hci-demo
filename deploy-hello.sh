#!/usr/bin/env bash
# -*- coding: utf-8 -*-

cat <<-EOF >helmfile.yml
repositories:
  - name: itscontained
    url: https://charts.itscontained.io

releases:
  - name: hello-kubernetes
    namespace: hello
    chart: itscontained/raw
    version: 0.2.5
    values:
      - resources:
          - apiVersion: apps/v1
            kind: Deployment
            metadata:
              name: hello-kubernetes
            spec:
              replicas: 3
              selector:
                matchLabels:
                  app: hello-kubernetes
              template:
                metadata:
                  labels:
                    app: hello-kubernetes
                spec:
                  containers:
                    - name: hello-kubernetes-basic
                      image: paulbouwer/hello-kubernetes:1.10
                      ports:
                        - containerPort: 8080
                      resources:
                        requests:
                          memory: "64Mi"
                          cpu: "80m"
                        limits:
                          memory: "128Mi"
                          cpu: "250m"
                      env:
                        - name: KUBERNETES_NAMESPACE
                          valueFrom:
                            fieldRef:
                              fieldPath: metadata.namespace
                        - name: KUBERNETES_NODE_NAME
                          valueFrom:
                            fieldRef:
                              fieldPath: spec.nodeName

          - apiVersion: v1
            kind: Service
            metadata:
              name: hello-kubernetes
              annotations:
                external-dns.alpha.kubernetes.io/hostname: hello.{{ requiredEnv "DNS_DOMAIN" }}
            spec:
              type: LoadBalancer
              ports:
                - port: 80
                  targetPort: 8080
              selector:
                app: hello-kubernetes

EOF
#-----------------------------------------------------------------------------
# Apply and cleanup
#-----------------------------------------------------------------------------
helmfile apply
rm helmfile.yml
#-----------------------------------------------------------------------------
# verify
#-----------------------------------------------------------------------------
JMESPATH="[?type=='Microsoft.Network/dnszones/A'] | [].{Name:name,Record:aRecords[0].ipv4Address,TTL:ttl}"

az network dns record-set list \
  --resource-group $DNS_RESOURCE_GROUP \
  --zone-name $DNS_DOMAIN \
  --output table \
  --query "$JMESPATH"
