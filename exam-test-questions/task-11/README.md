# Task 11: Create a NetworkPolicy

**Weight**: 6%
**Time Estimate**: 8 minutes

## Task

In the `secure` namespace (create if needed):

1. Create a Pod named `backend-pod` with label `app=backend` using image `nginx:alpine`

2. Create a NetworkPolicy named `backend-policy` that:
   - Applies to Pods with label `app=backend`
   - Allows ingress traffic only from Pods with label `app=frontend` on port `80`
   - Denies all other ingress traffic

## Solution Approach

Create NetworkPolicy YAML with podSelector and ingress rules.

## Verification

```bash
kubectl get networkpolicy backend-policy -n secure
kubectl describe networkpolicy backend-policy -n secure
```

Expected: Policy should show correct pod selector and ingress rules.
