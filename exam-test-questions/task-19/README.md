# Task 19: Debug Application Logs

**Weight**: 4%
**Time Estimate**: 5 minutes

## Task

A multi-container Pod named `logger-pod` exists in the `default` namespace with containers `app` and `sidecar`.

1. View the logs of the `sidecar` container from the last 20 lines
2. Save the logs to a file at `/root/sidecar-logs.txt`
3. Check if either container has restarted in the past hour

## Setup (Pre-existing)

```bash
# Pod with two containers already exists
kubectl get pod logger-pod
```

## Solution Approach

Use `kubectl logs` with `-c` flag for specific container and `--tail` for line limit.

## Verification

```bash
cat /root/sidecar-logs.txt
kubectl get pod logger-pod -o jsonpath='{.status.containerStatuses[*].restartCount}'
```

Expected: Log file should contain the last 20 lines from sidecar container.
