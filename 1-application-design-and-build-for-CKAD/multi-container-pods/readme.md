# Multi-Container Pods Demo

This demo showcases Kubernetes multi-container pod patterns, including init containers, sidecar containers, and shared volumes.

## Architecture

The pod consists of:
- **Init Container** (`init-startup`): Runs before main containers start, writes a startup log
- **Main Container** (`nginx`): Serves the application on port 80
- **Sidecar Container** (`log-tailer`): Tails nginx access logs in real-time
- **Shared Volume** (`shared-logs`): EmptyDir volume mounted across containers for log sharing

## Key Concepts

- **busybox**: Lightweight image that allows shell commands to be run in a container
- **Init Containers**: Run to completion before main containers start (verify with `kubectl describe`)
- **Shared Volumes**: EmptyDir volumes enable data sharing between containers in a pod

## Usage

### Deploy the pod
```bash
kubectl apply -f multi-container-app.yaml
```

### Port forward to access nginx
```bash
kubectl port-forward pod/multi-container-app 8080:80
```

### View sidecar logs
```bash
kubectl logs multi-container-app -c log-tailer
```

### Verify init container execution
```bash
kubectl describe pod multi-container-app
```

### Access container shell and check shared logs
```bash
kubectl exec -it multi-container-app -c nginx -- sh
cat /var/log/nginx/startup.log
# Output: App starting up...
```

## Notes

The init container's startup.log is written to the shared volume at `/shared/startup.log` and becomes available to the nginx container at `/var/log/nginx/startup.log` due to the volume mount paths.
