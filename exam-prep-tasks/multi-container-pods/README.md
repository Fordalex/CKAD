# Multi-Container Pods - CKAD Exam Task

## Task

You need to create a Pod with multiple containers following different multi-container design patterns.

**Scenario:**
A microservice application needs a main application container, a sidecar container for logging, and an init container for setup tasks. You must implement these patterns correctly.

**Requirements:**

1. Create a namespace named **microservices**.

2. Create a Pod named **app-pod** in the **microservices** namespace with the following specifications:

   **Init Container:**
   - Name: **init-setup**
   - Image: **busybox:1.35**
   - Command: Create a file at `/work-dir/initialized.txt` with content "Setup Complete"
   - Use a volume mount at `/work-dir`

   **Main Application Container:**
   - Name: **main-app**
   - Image: **nginx:1.21-alpine**
   - Volume mount at `/usr/share/nginx/html` (shared with sidecar)
   - Volume mount at `/work-dir` (from init container)

   **Sidecar Container:**
   - Name: **log-sidecar**
   - Image: **busybox:1.35**
   - Command: Run an infinite loop that writes the current date to `/usr/share/nginx/html/logs.txt` every 5 seconds
   - Use command: `sh -c "while true; do date >> /usr/share/nginx/html/logs.txt; sleep 5; done"`
   - Volume mount at `/usr/share/nginx/html` (shared with main-app)

3. Define an **emptyDir** volume named **shared-data** for sharing data between main-app and log-sidecar.

4. Define an **emptyDir** volume named **init-data** for the init container output.

5. Verify the Pod is running with all containers ready (1 init container completed, 2 containers running).

6. Verify the init container created the `initialized.txt` file.

7. Verify the sidecar is writing logs to the shared volume that the nginx container can access.

## Starting Files

- `multi-container-pod.yaml` - Pod template with partial configuration

## Multi-Container Patterns

**Init Containers:**
- Run to completion before main containers start
- Used for setup, configuration, or waiting for dependencies
- Run sequentially in the order defined

**Sidecar Pattern:**
- Helper container that extends/enhances the main container
- Common uses: logging, monitoring, proxying
- Runs alongside main container throughout Pod lifecycle

**Shared Volumes:**
- emptyDir volumes are created when Pod is assigned to a node
- Exist for the lifetime of the Pod
- Can be shared between containers for data exchange

## Verification Commands

```bash
# Check Pod status (should show 2/2 ready)
kubectl get pod app-pod -n microservices

# Check init container logs
kubectl logs app-pod -n microservices -c init-setup

# Check main app logs
kubectl logs app-pod -n microservices -c main-app

# Check sidecar logs
kubectl logs app-pod -n microservices -c log-sidecar

# Verify init container output
kubectl exec -n microservices app-pod -c main-app -- cat /work-dir/initialized.txt

# Verify sidecar is writing logs
kubectl exec -n microservices app-pod -c main-app -- cat /usr/share/nginx/html/logs.txt

# Watch logs being written in real-time
kubectl exec -n microservices app-pod -c main-app -- tail -f /usr/share/nginx/html/logs.txt
```

## Tips

- Init containers are defined in `initContainers` section (same level as `containers`)
- Init containers run sequentially and must complete successfully
- Main containers run in parallel
- emptyDir volumes are perfect for sharing data between containers
- Container names must be unique within a Pod
- Use `-c` flag with kubectl logs/exec to specify container name
- The Pod is Ready only when all init containers complete AND all containers are ready

## Time Limit

**18 minutes**
