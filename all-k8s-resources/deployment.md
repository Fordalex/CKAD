# Deployment

## What is it?
A Deployment provides declarative updates for Pods and ReplicaSets. It manages the desired state of your application, handling rollouts, rollbacks, and scaling automatically.

## Key Characteristics
- **Declarative updates**: Describe the desired state and Kubernetes makes it happen
- **Rolling updates**: Gradually replace old Pods with new ones to minimize downtime
- **Rollback capability**: Easy rollback to previous versions if issues occur
- **Scaling**: Scale up or down by changing the replica count
- **Self-healing**: Automatically replaces failed Pods

## Common Use Cases
- Deploying stateless applications
- Rolling out new versions of applications
- Scaling applications horizontally
- Managing replica Pods

## Basic Example
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
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

## Deployment with Update Strategy
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
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

## Important kubectl Commands
```bash
# Create a deployment
kubectl create deployment nginx --image=nginx --replicas=3

# Get deployments
kubectl get deployments
kubectl get deploy

# Describe a deployment
kubectl describe deployment <deployment-name>

# Scale a deployment
kubectl scale deployment <deployment-name> --replicas=5

# Update deployment image
kubectl set image deployment/<deployment-name> nginx=nginx:1.22

# Check rollout status
kubectl rollout status deployment/<deployment-name>

# View rollout history
kubectl rollout history deployment/<deployment-name>

# Rollback to previous version
kubectl rollout undo deployment/<deployment-name>

# Rollback to specific revision
kubectl rollout undo deployment/<deployment-name> --to-revision=2

# Pause/Resume rollout
kubectl rollout pause deployment/<deployment-name>
kubectl rollout resume deployment/<deployment-name>

# Delete a deployment
kubectl delete deployment <deployment-name>
```

## CKAD Exam Tips
- Deployments are the most common way to run applications in Kubernetes
- Understand the difference between Deployment, ReplicaSet, and Pod
- Know how to perform rolling updates and rollbacks
- Be familiar with update strategies (RollingUpdate vs Recreate)
- Practice using kubectl create deployment with dry-run to generate YAML
- Understand maxSurge and maxUnavailable in rolling updates
- Remember that selector labels must match template labels
