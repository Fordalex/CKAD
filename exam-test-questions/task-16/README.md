# Task 16: Create Pod with Init Container

**Weight**: 5%
**Time Estimate**: 6 minutes

## Task

Create a Pod named `init-pod` in the `default` namespace with:

**Init Container:**
- Name: `init-setup`
- Image: `busybox:1.35`
- Command: `sh -c "echo 'Initialization complete' > /work-dir/init.txt"`
- Volume mount: `/work-dir`

**Main Container:**
- Name: `main-app`
- Image: `nginx:alpine`
- Volume mount: `/work-dir`

Use an `emptyDir` volume named `workdir`.

## Solution Approach

Create Pod YAML with `initContainers` section and shared volume.

## Verification

```bash
kubectl get pod init-pod
kubectl logs init-pod -c init-setup
kubectl exec init-pod -- cat /work-dir/init.txt
```

Expected: Init container completes successfully, main container can access the file.
