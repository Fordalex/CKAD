# ReplicaSet

## What is it?
A ReplicaSet ensures that a specified number of Pod replicas are running at any given time. It's the next-generation ReplicationController with more expressive Pod selectors.

## Key Characteristics
- **Replica management**: Maintains a stable set of replica Pods
- **Self-healing**: Automatically creates new Pods if some fail or are deleted
- **Label selector**: Uses set-based selectors (in, notin, exists)
- **Managed by Deployment**: Usually not created directly; Deployments manage ReplicaSets

## Common Use Cases
- Ensuring high availability by running multiple instances
- Maintaining a desired number of identical Pods
- Usually managed automatically by Deployments (not created directly)

## Basic Example
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
```

## ReplicaSet with matchExpressions
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
spec:
  replicas: 3
  selector:
    matchExpressions:
    - key: app
      operator: In
      values:
      - nginx
      - web
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
```

## Important kubectl Commands
```bash
# Get ReplicaSets
kubectl get replicasets
kubectl get rs

# Describe a ReplicaSet
kubectl describe rs <replicaset-name>

# Scale a ReplicaSet
kubectl scale rs <replicaset-name> --replicas=5

# Delete a ReplicaSet
kubectl delete rs <replicaset-name>

# Delete ReplicaSet but keep Pods
kubectl delete rs <replicaset-name> --cascade=orphan
```

## CKAD Exam Tips
- ReplicaSets are rarely created directly; Deployments manage them
- Understand the relationship: Deployment → ReplicaSet → Pods
- Know the difference between matchLabels and matchExpressions
- ReplicaSets don't support rolling updates (that's why we use Deployments)
- The selector must match the Pod template labels
- Changing the ReplicaSet template doesn't update existing Pods (only new ones)
