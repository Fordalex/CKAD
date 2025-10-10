# Simple Node Server - CKAD Practice

A basic Node.js HTTP server project for practicing Kubernetes concepts and preparing for the Certified Kubernetes Application Developer (CKAD) exam.

## Project Files

### Application Files

- **`server.js`** - Simple HTTP server running on port 3000 that responds with "Hello, from Kubernetes!"
- **`Dockerfile`** - Container image definition using Node.js 14 Alpine base image

### Kubernetes Manifests

- **`manifest.yaml`** - Pod definition that runs a single instance of the application
- **`simple-node-server-service.yaml`** - NodePort Service to expose the Pod externally

## Key CKAD Concepts Covered

### Pods (`manifest.yaml`)
- Basic Pod resource with single container
- Container image specification and pull policy
- Port configuration (containerPort: 3000)
- Labels for identification and Service selection

### Services (`simple-node-server-service.yaml`)
- NodePort Service type for external access
- Label selector to target Pods (`app: simple-node-server`)
- Port mapping: NodePort 30080 ’ Service Port 3000 ’ Target Port 3000

## Quick Start

### 1. Build the Docker Image
```bash
docker build -t simple-node-server:v1.0 .
```

### 2. Deploy to Kubernetes
```bash
# Create the Pod
kubectl apply -f manifest.yaml

# Create the Service
kubectl apply -f simple-node-server-service.yaml

# Verify Pod is running
kubectl get pods

# Verify Service is created
kubectl get services
```

### 3. Access the Application
```bash
# If using Minikube
minikube service simple-node-server-service

# Or access directly via NodePort
curl http://<node-ip>:30080
```

## Common kubectl Commands for CKAD Practice

```bash
# View Pod details
kubectl describe pod simple-node-server-pod

# Check Pod logs
kubectl logs simple-node-server-pod

# Execute commands in the Pod
kubectl exec -it simple-node-server-pod -- sh

# Port forward to test locally
kubectl port-forward pod/simple-node-server-pod 8080:3000

# Delete resources
kubectl delete -f manifest.yaml
kubectl delete -f simple-node-server-service.yaml

# Get all resources
kubectl get all
```

## CKAD Exam Tips

1. **Labels and Selectors** - Notice how the Service uses `selector.app: simple-node-server` to match the Pod's label
2. **Service Types** - This uses NodePort for external access; also know ClusterIP (internal) and LoadBalancer
3. **ImagePullPolicy: Never** - Used for locally built images; in production use `Always` or `IfNotPresent`
4. **Port Terminology**:
   - `containerPort`: Port the container listens on
   - `targetPort`: Port on the Pod the Service forwards to
   - `port`: Port the Service exposes internally
   - `nodePort`: Port exposed on the Node (range: 30000-32767)

## Troubleshooting

```bash
# Pod not starting?
kubectl describe pod simple-node-server-pod
kubectl logs simple-node-server-pod

# Service not working?
kubectl describe service simple-node-server-service
kubectl get endpoints

# Image pull errors?
# Make sure imagePullPolicy is set to Never for local images
# Verify image exists: docker images | grep simple-node-server
```

## Next Steps for CKAD Practice

- Add resource limits and requests
- Implement liveness and readiness probes
- Create a Deployment instead of a bare Pod
- Add ConfigMaps and Secrets
- Use environment variables
- Implement multi-container Pods
- Practice rolling updates and rollbacks
