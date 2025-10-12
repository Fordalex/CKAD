# Task 1: Create a Pod with Multiple Containers

**Weight**: 4%
**Time Estimate**: 5 minutes

## Task

Create a Pod named `multi-app` in the `default` namespace with two containers:

1. First container:
   - Name: `nginx-container`
   - Image: `nginx:1.21`
   -
2. Second container:
   - Name: `busybox-container`
   - Image: `busybox:1.35`
   - Command: `sh -c "while true; do echo $(date) >> /var/log/output.txt; sleep 5; done"`

Verify both containers are running.

## Solution Approach

Use `kubectl run` to create the initial Pod, then edit it to add the second container.

## Verification

```bash
kubectl get pod multi-app
kubectl describe pod multi-app
kubectl logs multi-app -c busybox-container
```

Expected: Pod status should be `Running` with `2/2` containers ready.
