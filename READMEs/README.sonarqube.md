NAME: sonarqube
LAST DEPLOYED: Tue Nov 22 19:22:50 2022
NAMESPACE: sonarqube
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
** Please be patient while the chart is being deployed **

Your SonarQube site can be accessed through the following DNS name from within your cluster:

    sonarqube.sonarqube.svc.cluster.local (port 80)

To access your SonarQube site from outside the cluster follow the steps below:

1. Get the SonarQube URL and associate SonarQube hostname to your cluster external IP:
```bash
   export CLUSTER_IP=$(minikube ip) # On Minikube. Use: `kubectl cluster-info` on others K8s clusters
   echo "SonarQube URL: http://sonarqube.aks.ez-lab.xyz/"
   echo "$CLUSTER_IP sonarqube.aks.ez-lab.xyz" | sudo tee -a /etc/hosts
```
2. Open a browser and access SonarQube using the obtained URL.

3. Login with the following credentials below:
```bash
echo Username: user
echo Password: \$(kubectl get secret --namespace sonarqube sonarqube -o jsonpath="{.data.sonarqube-password}" | base64 -d)
```