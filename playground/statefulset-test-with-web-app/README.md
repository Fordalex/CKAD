# Notes App - Kubernetes StatefulSet Demo

A simple Ruby Sinatra app with PostgreSQL to demonstrate Kubernetes StatefulSets and service discovery.

## What's Inside

- **Backend**: Ruby Sinatra REST API
- **Frontend**: Simple HTML/JS form to create and view notes
- **Database**: PostgreSQL running as a StatefulSet
- **Container**: Docker image for the app
- **K8s Resources**: StatefulSet for PostgreSQL, Deployment for the app

## How Kubernetes Service Discovery Works

When you create a Service named `postgres-service`, Kubernetes automatically creates a DNS entry. Any pod in the same namespace can reach it using that DNS name.

In `app.rb:10-16`, we connect using:
```ruby
host: 'postgres-service'  # This is the K8s Service name, not an IP!
```

Kubernetes DNS resolution:
- Service name: `postgres-service`
- Resolves to: The cluster IP of the Service
- Service routes to: The PostgreSQL pod via label selectors

## Project Structure

```
.
├── app.rb                    # Sinatra backend
├── Gemfile                   # Ruby dependencies
├── config.ru                 # Rack config
├── Dockerfile                # Container image
├── public/
│   └── index.html           # Frontend UI
└── k8s/
    ├── postgres-service.yaml      # Headless Service for PostgreSQL
    ├── postgres-statefulset.yaml  # StatefulSet for PostgreSQL
    ├── app-deployment.yaml        # Deployment for the app
    └── app-service.yaml          # NodePort Service for the app
```

## Quick Start

### 1. Build the Docker Image

```bash
docker build -t notes-app:latest .
```

### 2. Deploy to Kubernetes

```bash
# Deploy PostgreSQL StatefulSet
kubectl apply -f k8s/postgres-statefulset.yaml

# Wait for PostgreSQL to be ready
kubectl wait --for=condition=ready pod -l app=postgres --timeout=60s

# Deploy the app
kubectl apply -f k8s/app-deployment.yaml

# Wait for app to be ready
kubectl wait --for=condition=ready pod -l app=notes-app --timeout=60s
```

### 3. Access the App

```bash
# Get the service URL (Minikube)
minikube service notes-app-service --url

# Or access directly via NodePort
# http://localhost:30080 (if using Docker Desktop)
# http://<node-ip>:30080 (if using Minikube/other)
```

## Verify It's Working

### Check the pods
```bash
kubectl get pods
```

You should see:
- `postgres-0` (StatefulSet pod)
- `notes-app-xxxxxxxx-xxxxx` (Deployment pods)

### Check StatefulSet and PVC
```bash
kubectl get statefulset
kubectl get pvc
```

The StatefulSet automatically creates a PersistentVolumeClaim for data persistence.

### Test DNS resolution
```bash
# Exec into the app pod
kubectl exec -it deployment/notes-app -- sh

# Test DNS lookup
nslookup postgres-service
# Should resolve to the postgres service IP

# Test connection
nc -zv postgres-service 5432
```

## Key Kubernetes Concepts Demonstrated

### StatefulSet (postgres-statefulset.yaml:9-46)
- **Stable network identity**: Pod name is `postgres-0` (predictable)
- **Persistent storage**: Uses `volumeClaimTemplates` for automatic PVC creation
- **Ordered deployment**: Pods created/deleted in order (important for databases)

### Headless Service (postgres-statefulset.yaml:1-8)
- `clusterIP: None` makes it headless
- Used by StatefulSet for stable pod DNS names
- Each pod gets: `postgres-0.postgres-service.default.svc.cluster.local`

### Service Discovery
- Regular Service: `postgres-service` resolves to Service IP
- Kubernetes DNS automatically manages this
- No hardcoded IPs needed!

## Clean Up

```bash
kubectl delete -f k8s/app-deployment.yaml
kubectl delete -f k8s/postgres-statefulset.yaml

# Delete PVCs (persistent data)
kubectl delete pvc postgres-storage-postgres-0
```

## Testing StatefulSet Features

### Data Persistence
```bash
# Add some notes via the UI
# Delete the postgres pod
kubectl delete pod postgres-0

# StatefulSet automatically recreates it with the SAME name and SAME volume
# Your data should still be there!
```

### Scale the StatefulSet
```bash
kubectl scale statefulset postgres --replicas=2

# You'll get postgres-0 and postgres-1
kubectl get pods -l app=postgres
```

## Troubleshooting

### App can't connect to database
```bash
# Check if postgres is ready
kubectl get pods -l app=postgres

# Check logs
kubectl logs -l app=postgres
kubectl logs -l app=notes-app

# Test DNS from app pod
kubectl exec -it deployment/notes-app -- nslookup postgres-service
```

### Port not accessible
```bash
# Check service
kubectl get svc notes-app-service

# For Minikube, use:
minikube service notes-app-service
```

## What You Learned

1. **StatefulSets** provide stable pod identities and persistent storage
2. **Kubernetes DNS** automatically creates service discovery entries
3. **Headless Services** (`clusterIP: None`) enable direct pod DNS names
4. **Service names** like `postgres-service` work as hostnames within the cluster
5. **volumeClaimTemplates** automatically provision storage per pod
