# Task 4: Create a Secret and Mount It as Volume

**Weight**: 5%
**Time Estimate**: 6 minutes

## Task

1. Create a Secret named `db-secret` in the `default` namespace with:
   - `username=admin`
   - `password=P@ssw0rd123`

2. Create a Pod named `secret-pod` using image `busybox:1.35` with command `sleep 3600` that mounts the Secret at `/etc/db-config`

## Solution Approach

- Use `kubectl create secret generic --from-literal`
- Create Pod with volume mount referencing the Secret

## Verification

```bash
kubectl get secret db-secret
kubectl exec secret-pod -- ls /etc/db-config
kubectl exec secret-pod -- cat /etc/db-config/username
kubectl exec secret-pod -- cat /etc/db-config/password
```

Expected: Files `username` and `password` should exist with correct values.
