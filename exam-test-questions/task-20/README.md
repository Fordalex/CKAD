# Task 20: Label and Selector Operations

**Weight**: 4%
**Time Estimate**: 5 minutes

## Task

In the `default` namespace:

1. Add label `env=production` to all Pods with label `app=web`
2. Create a Service named `prod-svc` that:
   - Selects Pods with labels `app=web` AND `env=production`
   - Type: `ClusterIP`
   - Port: `80`
   - Target port: `80`

## Setup (Pre-existing)

```bash
kubectl run web-1 --image=nginx:alpine --labels="app=web"
kubectl run web-2 --image=nginx:alpine --labels="app=web"
kubectl run web-3 --image=nginx:alpine --labels="app=web"
```

## Solution Approach

Use `kubectl label` with selector, then `kubectl create service` or create Service YAML.

## Verification

```bash
kubectl get pods --show-labels
kubectl describe svc prod-svc | grep Selector
kubectl get endpoints prod-svc
```

Expected: All web Pods should have `env=production` label and Service should select them.
