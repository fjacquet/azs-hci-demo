# Installation YugabyteDB

NAME: lab
LAST DEPLOYED: Tue Nov 22 16:41:01 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: redis
CHART VERSION: 17.3.11
APP VERSION: 7.0.5

** Please be patient while the chart is being deployed **

Redis&reg; can be accessed on the following DNS names from within your cluster:

    lab-redis-master.default.svc.cluster.local for read/write operations (port 6379)
    lab-redis-replicas.default.svc.cluster.local for read-only operations (port 6379)

To get your password run:

```bash
  export REDIS_PASSWORD=$(kubectl get secret --namespace default lab-redis -o jsonpath="{.data.redis-password}" | base64 -d)
```

To connect to your Redis&reg; server:

1. Run a Redis&reg; pod that you can use as a client:

```bash
kubectl run --namespace default redis-client --restart='Never' --env REDIS_PASSWORD=\$REDIS_PASSWORD --image docker.io/bitnami/redis-cluster:7.0.5-debian-11-r15 --command -- sleep infinity
```

Use the following command to attach to the pod:

```bash
kubectl exec --tty -i redis-client --namespace default -- bash
```

2. Connect using the Redis&reg; CLI:

```bash
REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h lab-redis-master
REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h lab-redis-replicas
```

To connect to your database from outside the cluster execute the following commands:

```bash
kubectl port-forward --namespace default svc/lab-redis-master 6379:6379 &
REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h 127.0.0.1 -p 6379
```
