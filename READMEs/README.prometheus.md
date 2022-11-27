NAME: prometheus
LAST DEPLOYED: Sat Nov 26 22:40:31 2022
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: kube-prometheus
CHART VERSION: 8.2.2
APP VERSION: 0.61.1

** Please be patient while the chart is being deployed **

Watch the Prometheus Operator Deployment status using the command:

    kubectl get deploy -w --namespace monitoring -l app.kubernetes.io/name=kube-prometheus-operator,app.kubernetes.io/instance=prometheus

Watch the Prometheus StatefulSet status using the command:

    kubectl get sts -w --namespace monitoring -l app.kubernetes.io/name=kube-prometheus-prometheus,app.kubernetes.io/instance=prometheus

Prometheus can be accessed via port "9090" on the following DNS name from within your cluster:

    prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local

To access Prometheus from outside the cluster execute the following commands:

You should be able to access your new Prometheus installation through

http://prometheus.aks.ez-lab.xyz

Watch the Alertmanager StatefulSet status using the command:

    kubectl get sts -w --namespace monitoring -l app.kubernetes.io/name=kube-prometheus-alertmanager,app.kubernetes.io/instance=prometheus

Alertmanager can be accessed via port "9093" on the following DNS name from within your cluster:

    prometheus-kube-prometheus-alertmanager.monitoring.svc.cluster.local

To access Alertmanager from outside the cluster execute the following commands:

    echo "Alertmanager URL: http://127.0.0.1:9093/"
    kubectl port-forward --namespace monitoring svc/prometheus-kube-prometheus-alertmanager 9093:9093
