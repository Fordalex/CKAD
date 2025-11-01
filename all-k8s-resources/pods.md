# Pod

## What is it?
A Pod is the smallest deployable unit in Kubernetes. It represents a single instance of a running process in your cluster and can contain one or more containers that share storage, network, and specifications for how to run the containers.

## Key Characteristics
- **Atomic unit**: Pods are created, scheduled, and managed as a single unit
- **Shared resources**: Containers in a Pod share the same network namespace (IP address and ports) and can share storage volumes
- **Co-located containers**: Multiple containers in a Pod run on the same node and are tightly coupled
- **Ephemeral**: Pods are designed to be disposable and replaceable

## Common Use Cases
- Running a single container (most common)
- Running multiple tightly coupled containers that need to share resources (sidecar pattern)
- Init containers for setup tasks before main containers start

## Basic Example
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80
```

## Multi-Container Example
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80
  - name: sidecar
    image: busybox
    command: ['sh', '-c', 'while true; do echo "Sidecar running"; sleep 10; done']
```

## Important kubectl Commands
```bash
# Create a pod
kubectl run nginx --image=nginx

# Get pods
kubectl get pods
kubectl get pods -o wide

# Describe a pod
kubectl describe pod <pod-name>

# Get pod logs
kubectl logs <pod-name>
kubectl logs <pod-name> -c <container-name>  # for multi-container pods

# Execute command in pod
kubectl exec -it <pod-name> -- /bin/bash

# Delete a pod
kubectl delete pod <pod-name>
```

## CKAD Exam Tips
- Pods are rarely created directly in production; usually created via Deployments or other controllers
- Know how to create multi-container pods
- Understand init containers and their use cases
- Be familiar with pod lifecycle and phases (Pending, Running, Succeeded, Failed, Unknown)
- Practice using kubectl run with various flags for quick pod creation
