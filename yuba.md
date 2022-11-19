# Installation yuga

NAME: yb-demo

LAST DEPLOYED: Sat Nov 19 14:24:12 2022
NAMESPACE: yb-demo
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:

1. Get YugabyteDB Pods by running this command:

```bash
  kubectl --namespace yb-demo get pods
```

2. Get list of YugabyteDB services that are running:

```bash
  kubectl --namespace yb-demo get services
```

3. Get information about the load balancer services:

```bash
  kubectl get svc --namespace yb-demo
```

4. Connect to one of the tablet server:

```bash
  kubectl exec --namespace yb-demo -it yb-tserver-0 bash
```

5. Run YSQL shell from inside of a tablet server:

```bash
  kubectl exec --namespace yb-demo -it yb-tserver-0 -- /home/yugabyte/bin/ysqlsh -h yb-tserver-0.yb-tservers.yb-demo
```

6. Cleanup YugabyteDB Pods
  For helm 2:
  helm delete yb-demo --purge
  For helm 3:

```bash
  helm delete yb-demo -n yb-demo
```

  NOTE: You need to manually delete the persistent volume

```bash
  kubectl delete pvc --namespace yb-demo -l app=yb-master
  kubectl delete pvc --namespace yb-demo -l app=yb-tserver
```
