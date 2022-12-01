# Installation jenkins

## Description
NAME: kubeapps
LAST DEPLOYED: Sat Nov 26 10:12:12 2022
NAMESPACE: kubeapps
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: kubeapps
CHART VERSION: 12.1.1
APP VERSION: 2.6.1** Please be patient while the chart is being deployed **

Tip:

  Watch the deployment status using the command: kubectl get pods -w --namespace kubeapps

Kubeapps can be accessed via port 80 on the following DNS name from within your cluster:

   kubeapps.kubeapps.svc.cluster.local

To access Kubeapps from outside your K8s cluster, follow the steps below:

1. Get the Kubeapps URL and associate Kubeapps hostname to your cluster external IP:

   export CLUSTER_IP=$(minikube ip) # On Minikube. Use: `kubectl cluster-info` on others K8s clusters
   echo "Kubeapps URL: http://apps.aks.ez-lab.xyz/"
   echo "$CLUSTER_IP  apps.aks.ez-lab.xyz" | sudo tee -a /etc/hosts

2. Open a browser and access Kubeapps using the obtained URL.