# Task 13: Create ServiceAccount and Use It

**Weight**: 4%
**Time Estimate**: 5 minutes

## Task

1. Create a ServiceAccount named `app-sa` in the `default` namespace

2. Create a Pod named `sa-pod` using image `nginx:alpine` that uses the ServiceAccount `app-sa`

## Solution Approach

Use `kubectl create serviceaccount` and create Pod with `serviceAccountName` field.

## Verification

```bash
kubectl get serviceaccount app-sa
kubectl get pod sa-pod -o jsonpath='{.spec.serviceAccountName}'
kubectl describe pod sa-pod | grep "Service Account"
```

Expected: Pod should use the `app-sa` service account.
