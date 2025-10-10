# Blue-Green Deployment with Kubernetes

This project demonstrates blue-green deployment strategy using Kubernetes, allowing instant traffic switching between two versions of an application.

## Project Structure

```
blue-green-deployment/
├── service.yaml          # Public service (production, switchable)
├── blue/
│   ├── Dockerfile
│   ├── index.html
│   ├── deployment.yaml   # Blue deployment (role: blue)
│   └── service.yaml      # Blue service (testing on :8080)
└── green/
    ├── Dockerfile
    ├── index.html
    ├── deployment.yaml   # Green deployment (role: green)
    └── service.yaml      # Green service (testing on :8081)
```

## Services Overview

- **blue-service** - Testing blue version at http://localhost:8080
- **green-service** - Testing green version at http://localhost:8081
- **public-service** - Production traffic at http://localhost:80 (switchable)

## Deployment

### 1. Build Docker Images

```bash
# Build blue version
docker build -t blue-app:1.0 ./blue

# Build green version
docker build -t green-app:1.0 ./green
```

### 2. Deploy to Kubernetes

```bash
# Deploy both versions (specify YAML files only)
kubectl apply -f blue/deployment.yaml -f blue/service.yaml
kubectl apply -f green/deployment.yaml -f green/service.yaml
kubectl apply -f service.yaml

# Verify deployments
kubectl get deployments
kubectl get pods
kubectl get services
```

## Testing

### Access Each Version

```bash
# Test blue version
curl http://localhost:8080

# Test green version
curl http://localhost:8081

# Check production (starts pointing to blue)
curl http://localhost:80
```

## Blue-Green Switching

### Switch Production Traffic

```bash
# Switch to green
kubectl set selector service public-service 'role=green'

# Verify the switch
kubectl describe svc public-service | grep Selector
curl http://localhost:80  # Should show green

# Switch back to blue
kubectl set selector svc public-service 'role=blue'
```

## Key Concepts

### Role Labels

Both deployments use a `role` label for switching:
- Blue deployment: `role: blue`
- Green deployment: `role: green`

The public service selector switches between these roles to redirect traffic.

### Creating Deployments Imperatively

```bash
# Generate deployment YAML
kubectl create deployment blue-app-deployment \
  --image=blue-app:1.0 \
  --replicas=3 \
  --port=80 \
  --dry-run=client -o yaml > deployment.yaml
```

**Dry-run options:**
- `client` - Validate locally, no server contact (fast, for generating YAML)
- `server` - Validate on server (checks permissions, admission controllers)

### Creating Services

**Using expose (automatic):**
```bash
kubectl expose deployment blue-app-deployment \
  --type=LoadBalancer \
  --port=80 \
  --name=blue-service
```

**Using create (manual):**
```bash
kubectl create service loadbalancer blue-service --tcp=80:80
# Must manually edit selector to match deployment labels
```

**Key difference:**
- `expose` - "Make this existing resource accessible" (auto-wires selector)
- `create` - "Make a new thing from scratch" (manual configuration)

## Cleanup

```bash
# Delete all resources
kubectl delete -f blue/
kubectl delete -f green/
kubectl delete -f service.yaml
```

## Workflow Summary

1. Deploy blue version (current production)
2. Deploy green version (new version)
3. Test green independently at localhost:8081
4. When ready, switch public-service to green
5. Monitor production
6. Rollback to blue if issues arise
7. When stable, green becomes the new production baseline
