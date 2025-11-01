# Task 4: Create a Secret and Mount It as Volume

**Weight**: 5%
**Time Estimate**: 6 minutes

## Task

1. Create a Secret named `db-secret` in the `task4` namespace with:
   - `username=admin`
   - `password=P@ssw0rd123`

2. Create a Pod named `secret-pod` using image `busybox:1.35` with command `sleep 3600` that mounts the Secret at `/etc/db-config`

## Solution Approach

- Use `kubectl create secret generic --from-literal`
- Create Pod with volume mount referencing the Secret

## Verification

```bash
kubectl get secret db-secret
kubectl exec secret-pod -- ls /etc/db-config
kubectl exec secret-pod -- cat /etc/db-config/username
kubectl exec secret-pod -- cat /etc/db-config/password
```

Expected: Files `username` and `password` should exist with correct values.

# Things I've learnt

I need to remember, running a pod is different to creating a deployment

k create deployment deployment-name
k run pod-name

When creating a pod impreatively and adding a command, the command should come last and but done with --. example for a sleep 3600:

k run secret-pod --image=busybox:1.35 --dry-run=client -o yaml -- sleep 3600 > delete.yaml

When mounting volumes, you'll first need to define the volumes in the spec of the deployment or pod first. Then you can reference the volumn using volumeMounts inside a container.

spec:
  volumes:
  - name: db-secret
    secret:
      secretName: db-secret


image: busybox:1.35
mountVolumes:
   - name: db-secret
      mountPath: /etc/db-config