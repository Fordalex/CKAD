# Task 5: Create a Pod with Resource Requests and Limits

**Weight**: 4%
**Time Estimate**: 5 minutes

## Task

Create a Pod named `resource-pod` in namespace `default` with:
- Image: `nginx:alpine`
- CPU request: `100m`
- CPU limit: `200m`
- Memory request: `128Mi`
- Memory limit: `256Mi`

## Solution Approach

Use `kubectl run` with `--dry-run=client -o yaml`, then add resource specifications.

## Verification

```bash
kubectl get pod resource-pod
kubectl describe pod resource-pod | grep -A 5 Requests
```

Expected: Should show correct resource requests and limits.
