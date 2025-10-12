# Task 7: Create a Job

**Weight**: 4%
**Time Estimate**: 5 minutes

## Task

Create a Job named `batch-job` in the `default` namespace with:
- Image: `busybox:1.35`
- Command: `sh -c "echo 'Processing batch job' && sleep 10 && echo 'Job complete'"`
- Completions: `3`
- Parallelism: `2`
- Restart policy: `Never`

## Solution Approach

Use `kubectl create job --dry-run=client -o yaml` and modify the YAML to add completions and parallelism.

## Verification

```bash
kubectl get job batch-job
kubectl get pods -l job-name=batch-job
kubectl logs -l job-name=batch-job
```

Expected: Job should complete successfully with 3 completions.
