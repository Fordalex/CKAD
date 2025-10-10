# Kubernetes Volume Types Demo

This project demonstrates the difference between ephemeral and persistent storage in Kubernetes.

## Common Ephemeral Volume Types

- **emptyDir**: Shared scratch space that exists only for the pod's lifetime
- **configMap**: Inject configuration data into pods
- **secret**: Inject sensitive data securely

## Persistent Volumes and Claims

- **PersistentVolume (PV)**: A resource in the cluster representing physical storage
- **PersistentVolumeClaim (PVC)**: A request for storage that binds to a PV
- Essential for retaining data across pod rescheduling and restarts

### What's the Difference Between PVC and PV?

- **PersistentVolume**: Storage provisioned by an administrator (or dynamically). Exists independently of any pod.
- **PersistentVolumeClaim**: A user's request for storage. Kubernetes binds the claim to an available PV that meets the requirements.

Think of it like a storage marketplace: PVs are available storage units, and PVCs are requests to rent storage.

## Demo

This demo shows how logs stored in an `emptyDir` volume are destroyed when a pod is rescheduled, but files in a persistent volume (like `index.html`) are retained.

### Setup

1. Build the Docker image:
   ```bash
   docker build -t nginx-storage-demo:1.0 .
   ```

2. Apply the PersistentVolume and PersistentVolumeClaim:
   ```bash
   kubectl apply -f pv-pvc.yaml
   ```

3. Deploy the pod:
   ```bash
   kubectl apply -f storage-demo-pod.yaml
   ```

### Testing Persistence

1. Write data to the persistent volume:
   ```bash
   kubectl exec storage-demo-pod -- sh -c "echo 'Persistent data' > /usr/share/nginx/uploads/index.html"
   ```

2. Write logs to the ephemeral volume:
   ```bash
   kubectl exec storage-demo-pod -- sh -c "echo 'Log entry' > /var/log/nginx/test.log"
   ```

3. Delete and recreate the pod:
   ```bash
   kubectl delete pod storage-demo-pod
   kubectl apply -f storage-demo-pod.yaml
   ```

4. Check the results:
   ```bash
   # This file persists
   kubectl exec storage-demo-pod -- cat /usr/share/nginx/uploads/index.html

   # This file is gone
   kubectl exec storage-demo-pod -- cat /var/log/nginx/test.log
   ```

The persistent volume retains `index.html` across pod restarts, while the ephemeral `emptyDir` logs are lost.

## Cleanup

```bash
kubectl delete pod storage-demo-pod
kubectl delete pvc storage-demo-pvc
kubectl delete pv storage-demo-pv
```
