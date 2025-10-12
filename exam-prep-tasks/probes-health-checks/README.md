# Liveness, Readiness, and Startup Probes - CKAD Exam Task

## Task

You need to configure health checks for applications using liveness, readiness, and startup probes.

**Scenario:**
You're deploying a web application that takes time to start up and needs health monitoring. You must implement appropriate probes to ensure Kubernetes can detect when the application is healthy, ready to serve traffic, and restart it if it becomes unhealthy.

**Requirements:**

1. Create a namespace named **monitoring**.

2. Create a Pod named **web-server** in the **monitoring** namespace:
   - Image: **nginx:1.21-alpine**
   - Container port: **80**

   **Liveness Probe:**
   - Type: **HTTP GET**
   - Path: `/healthz`
   - Port: **80**
   - Initial delay: **10** seconds
   - Period: **5** seconds
   - Failure threshold: **3**

   **Readiness Probe:**
   - Type: **HTTP GET**
   - Path: `/ready`
   - Port: **80**
   - Initial delay: **5** seconds
   - Period: **3** seconds
   - Failure threshold: **2**

3. Create a Pod named **database** in the **monitoring** namespace:
   - Image: **postgres:14-alpine**
   - Environment variable: `POSTGRES_PASSWORD=testpass`

   **Startup Probe:**
   - Type: **TCP Socket**
   - Port: **5432**
   - Initial delay: **0** seconds
   - Period: **5** seconds
   - Failure threshold: **6** (allows 30 seconds for startup)

   **Liveness Probe:**
   - Type: **Exec command**
   - Command: `["pg_isready", "-U", "postgres"]`
   - Period: **10** seconds
   - Failure threshold: **3**

   **Readiness Probe:**
   - Type: **Exec command**
   - Command: `["pg_isready", "-U", "postgres"]`
   - Period: **5** seconds
   - Failure threshold: **2**

4. Create a Deployment named **api-service** in the **monitoring** namespace:
   - Replicas: **3**
   - Image: **hashicorp/http-echo:0.2.3**
   - Args: `["-text=API is running"]`
   - Container port: **5678**

   **Readiness Probe:**
   - Type: **HTTP GET**
   - Path: `/`
   - Port: **5678**
   - Initial delay: **5** seconds
   - Period: **5** seconds

   **Liveness Probe:**
   - Type: **HTTP GET**
   - Path: `/`
   - Port: **5678**
   - Initial delay: **15** seconds
   - Period: **10** seconds

5. Verify all Pods are running and passing health checks.

6. Observe Pod restarts when liveness probes fail (optional: simulate failure).

## Starting Files

- `web-server-pod.yaml` - Pod template with partial probe configuration
- `database-pod.yaml` - Pod template for database
- `api-deployment.yaml` - Deployment template

## Probe Types and Usage

**Liveness Probe:**
- Determines if container is running properly
- If fails: Kubernetes **restarts the container**
- Use for: Detecting deadlocks, hung processes
- Example: Check if web server is responding

**Readiness Probe:**
- Determines if container is ready to serve traffic
- If fails: Pod **removed from Service endpoints** (not restarted)
- Use for: Slow-starting apps, temporary unavailability
- Example: Database connection check, cache warming

**Startup Probe:**
- Checks if application has started successfully
- Disables liveness/readiness until succeeds
- If fails: Kubernetes **restarts the container**
- Use for: Slow-starting applications
- Example: Large application initialization

**Probe Mechanisms:**
- **httpGet**: HTTP GET request (200-399 = success)
- **tcpSocket**: TCP connection attempt (connection = success)
- **exec**: Execute command in container (exit 0 = success)

**Probe Configuration:**
- **initialDelaySeconds**: Delay before first probe
- **periodSeconds**: How often to probe
- **timeoutSeconds**: Timeout for probe (default: 1)
- **successThreshold**: Consecutive successes needed (default: 1)
- **failureThreshold**: Consecutive failures before action taken

## Verification Commands

```bash
# Check Pods and their status
kubectl get pods -n monitoring
kubectl get pods -n monitoring -o wide

# Describe Pod to see probe configuration
kubectl describe pod web-server -n monitoring
kubectl describe pod database -n monitoring

# Check Pod events for probe failures
kubectl get events -n monitoring --sort-by='.lastTimestamp'

# Watch Pod status in real-time
kubectl get pods -n monitoring -w

# Check specific container readiness
kubectl get pod web-server -n monitoring -o jsonpath='{.status.containerStatuses[0].ready}'

# Verify Deployment rollout and replica readiness
kubectl get deployment api-service -n monitoring
kubectl rollout status deployment api-service -n monitoring

# Check Pod restart count (indicates liveness probe failures)
kubectl get pods -n monitoring -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[0].restartCount

# Simulate liveness probe failure (for testing)
kubectl exec -n monitoring web-server -- rm /usr/share/nginx/html/healthz
```

## Tips

- Liveness probes should detect unrecoverable failures only
- Set initialDelaySeconds longer than app startup time for liveness
- Readiness probes can have shorter delays than liveness
- Use startup probes for apps with variable startup times
- Failure threshold × period = time before action taken
- httpGet probes expect 2xx or 3xx status codes
- exec probes consider exit code 0 as success
- Don't use heavy operations in probes (they run frequently)
- Probes failing during startup count toward failure threshold
- Consider using startup probe to delay liveness/readiness checks

## Time Limit

**25 minutes**
