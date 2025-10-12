# Task 18: Create a Headless Service

**Weight**: 4%
**Time Estimate**: 5 minutes

## Task

1. Create a Deployment named `stateful-app` with 3 replicas using image `nginx:alpine` and label `app=stateful`

2. Create a Headless Service named `stateful-svc` that:
   - Selects Pods with label `app=stateful`
   - Has `clusterIP: None`
   - Exposes port `80`

## Solution Approach

Create deployment, then create Service YAML with `clusterIP: None`.

## Verification

```bash
kubectl get svc stateful-svc
kubectl get svc stateful-svc -o jsonpath='{.spec.clusterIP}'
```

Expected: Service should show `None` for clusterIP.
