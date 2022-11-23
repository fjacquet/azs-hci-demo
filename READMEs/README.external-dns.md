# Installation external dns

## Description

NAME: external-dns
LAST DEPLOYED: Mon Nov 21 18:45:09 2022
NAMESPACE: externaldns
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
kubectl --namespace=external-dns get pods -l "app.kubernetes.io/name=external-dns,app.kubernetes.io/instance=external-dns"

```
