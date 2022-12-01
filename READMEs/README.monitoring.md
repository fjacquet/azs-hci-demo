# Installation external dns

## Description

NAME: prometheus-operator
LAST DEPLOYED: Tue Nov 22 15:53:09 2022
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
NOTES:
kube-prometheus-stack has been installed. Check its status by running:

```bash
  kubectl --namespace monitoring get pods -l "release=prometheus-operator"
```

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.
