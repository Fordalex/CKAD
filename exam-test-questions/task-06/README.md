# Task 6: Scale a Deployment

**Weight**: 3%
**Time Estimate**: 3 minutes

## Task

In the `default` namespace:

1. There is an existing Deployment named `api-deployment`
2. Scale it to `5` replicas
3. Verify all 5 Pods are running

## Setup (Pre-existing)

```bash
kubectl create deployment api-deployment --image=nginx:alpine --replicas=2
```

## Solution Approach

Use `kubectl scale` command.

## Verification

```bash
kubectl get deployment api-deployment
kubectl get pods -l app=api-deployment
```

Expected: Deployment should show `5/5` ready replicas.
