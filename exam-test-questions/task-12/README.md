# Task 12: Rollout and Rollback a Deployment

**Weight**: 5%
**Time Estimate**: 6 minutes

## Task

There is a Deployment named `app-deployment` in the `default` namespace running image `nginx:1.20`.

1. Update the Deployment to use image `nginx:1.21`
2. Record the change
3. Check the rollout status
4. Rollback to the previous version

## Setup (Pre-existing)

```bash
kubectl create deployment app-deployment --image=nginx:1.20 --replicas=3
```

## Solution Approach

Use `kubectl set image`, `kubectl rollout status`, and `kubectl rollout undo`.

## Verification

```bash
kubectl rollout history deployment app-deployment
kubectl get deployment app-deployment -o jsonpath='{.spec.template.spec.containers[0].image}'
```

Expected: Image should be back to `nginx:1.20` after rollback.
