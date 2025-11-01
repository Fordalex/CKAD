# StatefulSet

## What is it?
StatefulSet is a workload controller used to manage stateful applications. It provides guarantees about the ordering and uniqueness of Pods, unlike Deployments which treat Pods as interchangeable.

## Key Characteristics
- **Stable network identity**: Each Pod gets a persistent hostname
- **Stable storage**: Pods are associated with persistent volumes that remain across rescheduling
- **Ordered deployment**: Pods are created sequentially (0, 1, 2, ...)
- **Ordered termination**: Pods are terminated in reverse order
- **Ordered scaling**: Maintains order during scale up/down operations

## Common Use Cases
- Databases (MySQL, PostgreSQL, MongoDB)
- Distributed systems requiring stable network identities (Kafka, ZooKeeper, etcd)
- Applications requiring stable, persistent storage
- Applications requiring ordered, graceful deployment and scaling

## Basic Example
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: mysql
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: data
          mountPath: /var/lib/mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "password"
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
```

## Headless Service Example
StatefulSets require a headless Service for network identity:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  clusterIP: None  # Headless service
  selector:
    app: mysql
  ports:
  - port: 3306
    targetPort: 3306
```

## Important kubectl Commands
```bash
# Create StatefulSet
kubectl apply -f statefulset.yaml

# Get StatefulSets
kubectl get statefulsets
kubectl get sts

# Describe StatefulSet
kubectl describe sts <statefulset-name>

# Get Pods from StatefulSet (note the naming)
kubectl get pods -l app=mysql
# Pods will be named: mysql-0, mysql-1, mysql-2

# Scale StatefulSet
kubectl scale sts <statefulset-name> --replicas=5

# Delete StatefulSet
kubectl delete sts <statefulset-name>

# Delete StatefulSet but keep Pods
kubectl delete sts <statefulset-name> --cascade=orphan

# Update StatefulSet
kubectl patch sts <statefulset-name> -p '{"spec":{"replicas":5}}'
```

## Pod Naming Convention
Pods created by StatefulSet follow a predictable naming pattern:
- `<statefulset-name>-0`
- `<statefulset-name>-1`
- `<statefulset-name>-2`

Each Pod gets a DNS entry:
- `<pod-name>.<service-name>.<namespace>.svc.cluster.local`
- Example: `mysql-0.mysql.default.svc.cluster.local`

## CKAD Exam Tips
- StatefulSets require a headless Service (clusterIP: None)
- Understand volumeClaimTemplates for persistent storage
- Know the ordered Pod creation/deletion behavior
- Remember that scaling down doesn't delete PVCs (manual cleanup required)
- Pod names are stable and predictable (statefulset-name-ordinal)
- Update strategies: RollingUpdate (default) or OnDelete
- Deleting a StatefulSet doesn't delete associated PVCs
