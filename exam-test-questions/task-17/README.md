# Task 17: Create ResourceQuota

**Weight**: 4%
**Time Estimate**: 5 minutes

## Task

Create a ResourceQuota named `dev-quota` in the `dev` namespace (create if needed) with:
- Maximum 10 Pods
- Total CPU requests: `4` cores
- Total memory requests: `8Gi`

## Solution Approach

Create namespace first, then create ResourceQuota YAML.

## Verification

```bash
kubectl get resourcequota dev-quota -n dev
kubectl describe resourcequota dev-quota -n dev
```

Expected: ResourceQuota should show correct hard limits.
