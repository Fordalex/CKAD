# Task 2: Create and Configure a Service

**Weight**: 5%
**Time Estimate**: 4 minutes

## Task

In the `production` namespace (create if it doesn't exist):

1. Create a Deployment named `web-deploy` with 3 replicas using the image `nginx:alpine`
2. Expose the Deployment using a Service named `web-svc`
3. The Service should be of type `NodePort` and expose port `80` on the Pods on port `30080` on the nodes

## Solution Approach

Use imperative commands:
- `kubectl create namespace`
- `kubectl create deployment`
- `kubectl expose deployment`

## Verification

```bash
kubectl get deployment web-deploy -n production
kubectl get svc web-svc -n production
curl http://<node-ip>:30080
```

Expected: Service should show `NodePort` type with port `30080`.
