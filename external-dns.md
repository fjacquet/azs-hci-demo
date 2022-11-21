# Installation external dns

## Description

NAME: external-dns
LAST DEPLOYED: Mon Nov 21 08:56:19 2022
NAMESPACE: kube-addons
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: external-dns
CHART VERSION: 6.12.1
APP VERSION: 0.13.1

** Please be patient while the chart is being deployed **

To verify that external-dns has started, run:

```bash
kubectl --namespace=kube-addons get pods -l "app.kubernetes.io/name=external-dns,app.kubernetes.io/instance=external-dns"
```

Listing releases matching ^external-dns\$
external-dns kube-addons 1 2022-11-21 08:56:19.016966 +0100 CET deployed external-dns-6.12.1 0.13.1

UPDATED RELEASES:
NAME CHART VERSION
external-dns bitnami/external-dns 6.12.1
