# Task 14: Fix a Broken Pod

**Weight**: 5%
**Time Estimate**: 6 minutes

## Task

A Pod named `broken-pod` in the `default` namespace is not starting.

1. Identify the issue
2. Fix the Pod
3. Verify it's running

## Setup (Pre-existing - has error)

The Pod has an incorrect image name: `ngin:alpine` (should be `nginx:alpine`).

```bash
kubectl run broken-pod --image=ngin:alpine
```

## Solution Approach

Use `kubectl describe` or `kubectl get events`, then delete and recreate or edit the Pod.

## Verification

```bash
kubectl get pod broken-pod
kubectl describe pod broken-pod
```

Expected: Pod should be in `Running` state with `1/1` ready.
