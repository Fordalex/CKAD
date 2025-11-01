# Task 5: Create a Pod with Resource Requests and Limits

**Weight**: 4%
**Time Estimate**: 5 minutes

## Task

Create a Pod named `resource-pod` in namespace `task5` with:
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

# Things I've learnt

resources:
    requests:
        cpu: 100m
        memory: 128Mi
    limits:
        cpu: 200m        # Don't let me use more than 0.2 CPU (throttled)
        memory: 256Mi    # Kill me if I use more than 256MB

k8s:

m = millicores (1000m = 1 CPU core)
Mi = Mebibyte (binary, 1024-based)
M = Megabyte (decimal, 1000-based)

Computer science:

memory: "128Mi"   # 128 Mebibytes = 134,217,728 bytes
memory: "256Mi"   # 256 Mebibytes = 268,435,456 bytes
memory: "1Gi"     # 1 Gibibyte = 1,073,741,824 bytes
```

**Binary units (powers of 1024):**
```
Ki = Kibibyte = 1024 bytes
Mi = Mebibyte = 1024² = 1,048,576 bytes
Gi = Gibibyte = 1024³ = 1,073,741,824 bytes
Ti = Tebibyte = 1024⁴ bytes
```

**Decimal units (powers of 1000):**
```
K = Kilobyte = 1000 bytes
M = Megabyte = 1000² = 1,000,000 bytes
G = Gigabyte = 1000³ = 1,000,000,000 bytes
T = Terabyte = 1000⁴ bytes
```