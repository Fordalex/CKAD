# Task 15: Create an Ingress Resource

**Weight**: 6%
**Time Estimate**: 7 minutes

## Task

In the `default` namespace:

1. There is a Service named `web-service` running on port `80`
2. Create an Ingress named `web-ingress` that routes traffic from `app.example.com` to the `web-service` on port `80`
3. Use path `/` for the routing

## Setup (Pre-existing)

```bash
kubectl create deployment web-app --image=nginx:alpine --replicas=2
kubectl expose deployment web-app --name=web-service --port=80
```

## Solution Approach

Create Ingress YAML with host, path, and backend service configuration.

## Verification

```bash
kubectl get ingress web-ingress
kubectl describe ingress web-ingress
```

Expected: Ingress should show the correct host and backend service.
