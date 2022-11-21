# Installation YugabyteDB

NAME: yubabyte

LAST DEPLOYED: Sat Nov 19 14:24:12 2022
NAMESPACE: yubabyte
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:

1. Get YugabyteDB Pods by running this command:

```bash
  kubectl --namespace yubabyte get pods
```

2. Get list of YugabyteDB services that are running:

```bash
  kubectl --namespace yubabyte get services
```

3. Get information about the load balancer services:

```bash
  kubectl get svc --namespace yubabyte
```

4. Connect to one of the tablet server:

```bash
  kubectl exec --namespace yubabyte -it yb-tserver-0 bash
```

5. Run YSQL shell from inside of a tablet server:

```bash
  kubectl exec --namespace yubabyte -it yb-tserver-0 -- /home/yugabyte/bin/ysqlsh -h yb-tserver-0.yb-tservers.yubabyte
```

6. Cleanup YugabyteDB Pods
  For helm 2:
  helm delete yubabyte --purge
  For helm 3:

```bash
  helm delete yubabyte -n yubabyte
```

  NOTE: You need to manually delete the persistent volume

```bash
  kubectl delete pvc --namespace yubabyte -l app=yb-master
  kubectl delete pvc --namespace yubabyte -l app=yb-tserver
```
