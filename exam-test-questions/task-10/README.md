# Task 10: Create PersistentVolumeClaim and Use It

**Weight**: 6%
**Time Estimate**: 7 minutes

## Task

1. Create a PersistentVolumeClaim named `data-pvc` in the `default` namespace:
   - Access mode: `ReadWriteOnce`
   - Storage request: `1Gi`
   - Storage class: `standard` (or default)

2. Create a Pod named `pvc-pod` that:
   - Uses image: `nginx:alpine`
   - Mounts the PVC at `/usr/share/nginx/html`

## Solution Approach

Create PVC YAML and Pod YAML separately.

## Verification

```bash
kubectl get pvc data-pvc
kubectl get pod pvc-pod
kubectl describe pod pvc-pod | grep -A 5 Volumes
```

Expected: PVC should be `Bound` and Pod should mount it successfully.
