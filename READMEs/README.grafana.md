NAME: grafana
LAST DEPLOYED: Sat Nov 26 22:40:36 2022
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: grafana-operator
CHART VERSION: 2.7.10
APP VERSION: 4.7.1

** Please be patient while the chart is being deployed **

Watch the Grafana Operator Deployment status using the command:

    kubectl get deploy -w --namespace monitoring -l app.kubernetes.io/name=grafana-operator,app.kubernetes.io/instance=grafana

+./deploy-monitoring.sh:37> helm upgrade --install ingress-nginx nginx/ingress-nginx --namespace nginx-ingress --set 'metrics.enabled=true'
Release "ingress-nginx" has been upgraded. Happy Helming!
NAME: ingress-nginx
LAST DEPLOYED: Sat Nov 26 22:40:38 2022
NAMESPACE: nginx-ingress
STATUS: deployed
REVISION: 3
TEST SUITE: None
NOTES:
The ingress-nginx controller has been installed.
It may take a few minutes for the LoadBalancer IP to be available.
You can watch the status by running 'kubectl --namespace nginx-ingress get services -o wide -w ingress-nginx-controller'

An example Ingress that makes use of the controller:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example
  namespace: foo
spec:
  ingressClassName: traefik
  rules:
    - host: www.example.com
      http:
        paths:
          - pathType: Prefix
            backend:
              service:
                name: exampleService
                port:
                  number: 80
            path: /
  # This section is only required if TLS is to be enabled for the Ingress
  tls:
    - hosts:
        - www.example.com
      secretName: example-tls
```

If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: example-tls
  namespace: foo
data:
  tls.crt: <base64 encoded cert>
  tls.key: <base64 encoded key>
type: kubernetes.io/tls
```
