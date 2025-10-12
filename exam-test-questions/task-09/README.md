# Task 9: Add Liveness and Readiness Probes

**Weight**: 5%
**Time Estimate**: 7 minutes

## Task

A file `/root/probe-pod.yaml` exists with a Pod definition.

Edit the Pod to add:

**Liveness Probe:**
- HTTP GET on port `80` at path `/healthz`
- Initial delay: `10` seconds
- Period: `5` seconds

**Readiness Probe:**
- HTTP GET on port `80` at path `/ready`
- Initial delay: `5` seconds
- Period: `3` seconds

Apply the updated Pod.

## Starting File Content

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: probe-pod
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
```

## Verification

```bash
kubectl describe pod probe-pod | grep -A 10 Liveness
kubectl describe pod probe-pod | grep -A 10 Readiness
```

Expected: Probes should be configured correctly.
