# Kubernetes Workload Controllers

A demo project exploring different Kubernetes workload controllers and their use cases.

## Overview

This project demonstrates three primary Kubernetes workload controllers:
- **Deployment** - Manages stateless applications with rolling updates
- **DaemonSet** - Runs a pod on every node in the cluster
- **CronJob** - Schedules jobs to run at specific times

## Contents

- `server.js` - Simple Node.js HTTP server
- `Dockerfile` - Container image for the web application
- `deployment.yaml` - Deployment with 3 replicas of the web server
- `service.yaml` - NodePort service to expose the deployment
- `daemonset.yaml` - DaemonSet that writes logs on every node
- `cronjob.yaml` - CronJob that runs a cleanup task every minute

## Usage

### Build the Docker Image

```bash
docker build -t workload-controllers:v1.0 .
```

### Deploy the Application

```bash
# Create the deployment (3 replicas)
kubectl apply -f deployment.yaml

# Expose the deployment via service
kubectl apply -f service.yaml

# Create the DaemonSet (runs on every node)
kubectl apply -f daemonset.yaml

# Create the CronJob (runs every minute)
kubectl apply -f cronjob.yaml
```

### Verify Deployments

```bash
# Check deployment status
kubectl get deployments
kubectl get pods -l app=nodeweb

# Check DaemonSet
kubectl get daemonsets
kubectl get pods -l name=log-writer

# Check CronJob
kubectl get cronjobs
kubectl get jobs
```

### Access the Web Application

```bash
# Get the NodePort
kubectl get service nodeweb-service

# Access the service (replace <node-ip> and <node-port>)
curl http://<node-ip>:<node-port>
```

## Workload Controller Comparison

| Controller | Use Case | Replicas | Scheduling |
|------------|----------|----------|------------|
| Deployment | Stateless apps, web servers | Configurable | Any available node |
| DaemonSet | Node monitoring, logging | One per node | Every node |
| CronJob | Scheduled tasks, backups | Per schedule | On schedule |

## Clean Up

```bash
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
kubectl delete -f daemonset.yaml
kubectl delete -f cronjob.yaml
```
