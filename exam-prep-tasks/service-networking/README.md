# Service Networking - CKAD Exam Task

## Task

You need to configure different types of Services to expose applications and understand Kubernetes networking.

**Scenario:**
You're deploying a multi-tier application that needs different types of network exposure: internal cluster communication, external access via NodePort, and DNS-based service discovery. You'll create and configure various Service types.

**Requirements:**

1. Create a namespace named **services-demo**.

2. Create a Deployment named **backend-api** in the **services-demo** namespace:
   - Replicas: **3**
   - Image: **hashicorp/http-echo:0.2.3**
   - Args: `["-text=Backend API v1.0", "-listen=:8080"]`
   - Container port: **8080**
   - Labels: `app=backend`, `tier=api`

3. Create a **ClusterIP** Service named **backend-service** in the **services-demo** namespace:
   - Type: **ClusterIP**
   - Selector: `app=backend`
   - Port: **80** (service port)
   - TargetPort: **8080** (container port)
   - Session affinity: **ClientIP** (sticky sessions)

4. Create a Deployment named **frontend-web** in the **services-demo** namespace:
   - Replicas: **2**
   - Image: **nginx:1.21-alpine**
   - Container port: **80**
   - Labels: `app=frontend`, `tier=web`

5. Create a **NodePort** Service named **frontend-service** in the **services-demo** namespace:
   - Type: **NodePort**
   - Selector: `app=frontend`
   - Port: **80**
   - TargetPort: **80**
   - NodePort: **30080** (specific node port)

6. Create a **Headless** Service named **backend-headless** in the **services-demo** namespace:
   - Type: **ClusterIP** with `clusterIP: None`
   - Selector: `app=backend`
   - Port: **8080**
   - Purpose: Direct Pod-to-Pod communication (StatefulSet pattern)

7. Create a test Pod named **debug-pod** in the **services-demo** namespace:
   - Image: **busybox:1.35**
   - Command: `sleep 3600`

8. From the **debug-pod**, verify DNS resolution and connectivity:
   - Resolve **backend-service** DNS name
   - Resolve **backend-headless** DNS name (should return individual Pod IPs)
   - Test connectivity to **backend-service**
   - Test connectivity to **frontend-service**

9. Verify the NodePort service is accessible externally.

## Starting Files

- `backend-deployment.yaml` - Backend deployment template
- `backend-service.yaml` - ClusterIP service template
- `frontend-deployment.yaml` - Frontend deployment template
- `frontend-service.yaml` - NodePort service template

## Service Types

**ClusterIP (default):**
- Exposes service on internal cluster IP
- Only reachable within cluster
- Used for internal microservice communication
- Most common service type

**NodePort:**
- Exposes service on each Node's IP at a static port
- Accessible from outside cluster via `<NodeIP>:<NodePort>`
- Automatically creates ClusterIP service
- Port range: 30000-32767

**LoadBalancer:**
- Exposes service externally using cloud provider's load balancer
- Automatically creates NodePort and ClusterIP
- Requires cloud provider integration
- Gets external IP address

**Headless Service:**
- No cluster IP assigned (`clusterIP: None`)
- Returns Pod IPs directly via DNS
- Used for StatefulSets, direct Pod communication
- DNS returns A records for each Pod

**ExternalName:**
- Maps service to external DNS name
- No proxying, just DNS CNAME record
- Used for external service references

## Service Discovery

**DNS for Services:**
- `<service-name>.<namespace>.svc.cluster.local`
- Within same namespace: just `<service-name>`
- Example: `backend-service.services-demo.svc.cluster.local`

**DNS for Headless Services:**
- Returns individual Pod IPs
- Pod DNS: `<pod-ip>.<service-name>.<namespace>.svc.cluster.local`
- For StatefulSets: `<pod-name>.<service-name>.<namespace>.svc.cluster.local`

## Verification Commands

```bash
# Check Services
kubectl get services -n services-demo
kubectl get svc -n services-demo -o wide
kubectl describe svc backend-service -n services-demo

# Check Service endpoints (Pod IPs)
kubectl get endpoints -n services-demo
kubectl get endpoints backend-service -n services-demo -o yaml

# Check Deployments and Pods
kubectl get deployments -n services-demo
kubectl get pods -n services-demo -o wide --show-labels

# Test DNS resolution from debug pod
kubectl exec -n services-demo debug-pod -- nslookup backend-service
kubectl exec -n services-demo debug-pod -- nslookup backend-headless

# Test connectivity from debug pod
kubectl exec -n services-demo debug-pod -- wget -qO- http://backend-service
kubectl exec -n services-demo debug-pod -- wget -qO- http://backend-service.services-demo.svc.cluster.local

# Test NodePort externally (from your machine)
curl http://<node-ip>:30080

# For minikube/kind, get node IP
kubectl get nodes -o wide

# Check service session affinity
kubectl get svc backend-service -n services-demo -o jsonpath='{.spec.sessionAffinity}'

# View service port mappings
kubectl get svc frontend-service -n services-demo -o jsonpath='{.spec.ports[0].nodePort}'

# Check headless service (no ClusterIP)
kubectl get svc backend-headless -n services-demo -o jsonpath='{.spec.clusterIP}'
```

## Tips

- Service selector must match Pod labels exactly
- Service targetPort must match container port
- NodePort services are accessible on ALL nodes (even if Pod isn't on that node)
- Use `sessionAffinity: ClientIP` for sticky sessions
- Services load balance traffic across all matching Pods
- Headless services (clusterIP: None) return Pod IPs instead of VIP
- DNS names are only resolvable within cluster
- Service port can differ from targetPort
- Update service by editing or deleting and recreating
- Use `kubectl port-forward svc/<service-name>` for local testing

## Time Limit

**25 minutes**
