# Installation jenkins

## Description

NAME: my-release
LAST DEPLOYED: Sat Nov 19 16:54:26 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: jenkins
CHART VERSION: 11.0.9
APP VERSION: 2.361.4

**Please be patient while the chart is being deployed**
Watch the status using:

```bash
kubectl get svc --namespace default -w my-release-jenkins
```


1. Get the Jenkins URL by running:

**Please ensure an external IP is associated to the my-release-jenkins service before proceeding**


```bash
  export SERVICE_IP=$(kubectl get svc --namespace default my-release-jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
  echo "Jenkins URL: http://$SERVICE_IP/"
```

2. Login with the following credentials

```bash
  echo Username: user
  echo Password: $(kubectl get secret --namespace default my-release-jenkins -o jsonpath="{.data.jenkins-password}" | base64 -d)
```
