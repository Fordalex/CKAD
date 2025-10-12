# Blue-Green Deployment Strategy - CKAD Exam Task

## Task

You are responsible for implementing a blue-green deployment strategy for a web application.

**Scenario:**
Your team is running a web application in production (blue version) and needs to deploy a new version (green version) with zero downtime. You'll use Kubernetes deployments and services to implement this strategy.

**Requirements:**

1. Create a Deployment named **web-blue** in the namespace **production**:
   - Use the image **nginx:1.21-alpine**
   - Set **3** replicas
   - Add the label **app=web** and **version=blue**
   - Container should listen on port **80**

2. Create a Service named **web-service** in the namespace **production**:
   - Type: **ClusterIP**
   - Expose port **80**
   - Initially route traffic to the **blue** version using label selector **app=web, version=blue**

3. Create a second Deployment named **web-green** in the namespace **production**:
   - Use the image **nginx:1.22-alpine** (new version)
   - Set **3** replicas
   - Add the label **app=web** and **version=green**
   - Container should listen on port **80**

4. Verify both deployments are running and all pods are ready.

5. Switch the **web-service** to route traffic to the **green** version by updating the service selector.

6. Verify the traffic is now being routed to the green version.

7. After successful verification, scale down the **web-blue** deployment to **0** replicas.

## Starting Files

- `blue-deployment.yaml` - Partially complete blue deployment (needs labels)
- `service.yaml` - Service configuration (needs selector)

## Verification Commands

```bash
# Check deployments
kubectl get deployments -n production

# Check pods with labels
kubectl get pods -n production --show-labels

# Check service endpoints
kubectl get endpoints web-service -n production

# Describe service to verify selector
kubectl describe service web-service -n production
```

## Tips

- Use label selectors effectively to control traffic routing
- Remember that changing a service selector takes effect immediately
- The blue-green strategy allows instant rollback by switching the service selector back
- Make sure all pods are in Ready state before switching traffic

## Time Limit

**15 minutes**
