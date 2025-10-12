# Canary Deployment Strategy - CKAD Exam Task

## Task

You are responsible for implementing a canary deployment strategy to gradually roll out a new version of an application.

**Scenario:**
Your application is currently running in production (stable version). You need to deploy a new version (canary) to a small percentage of users first to test it in production before fully rolling it out.

**Requirements:**

1. Create a namespace named **app-prod** if it doesn't exist.

2. Create a Deployment named **api-stable** in the namespace **app-prod**:
   - Use the image **httpd:2.4.54-alpine**
   - Set **9** replicas
   - Add labels **app=api** and **version=stable**
   - Add label **track=stable**
   - Container should listen on port **80**

3. Create a Service named **api-service** in the namespace **app-prod**:
   - Type: **ClusterIP**
   - Expose port **8080** and target port **80**
   - Route traffic to pods with label **app=api** (without version-specific selector)

4. Create a second Deployment named **api-canary** in the namespace **app-prod**:
   - Use the image **httpd:2.4.55-alpine** (new version)
   - Set **1** replica (approximately 10% of traffic)
   - Add labels **app=api** and **version=canary**
   - Add label **track=canary**
   - Container should listen on port **80**

5. Verify both deployments are running.

6. Test the canary deployment by checking the service endpoints - you should see approximately 90% stable pods and 10% canary pods.

7. After successful testing, scale the **api-canary** deployment to **5** replicas (50% traffic split).

8. Finally, scale **api-stable** to **0** replicas and **api-canary** to **10** replicas to complete the rollout.

## Starting Files

- `stable-deployment.yaml` - Template for stable deployment (needs completion)
- `namespace.yaml` - Namespace definition

## Key Concepts

**Canary Deployment** gradually shifts traffic to a new version:
- Start with small percentage (e.g., 10%)
- Monitor metrics and errors
- Gradually increase traffic to canary
- Roll back instantly if issues detected
- Complete rollout when confident

**Traffic Distribution:**
- With 9 stable + 1 canary = ~10% canary traffic
- With 5 stable + 5 canary = 50% canary traffic
- With 0 stable + 10 canary = 100% canary traffic

## Verification Commands

```bash
# Check deployments
kubectl get deployments -n app-prod

# Check pods with labels
kubectl get pods -n app-prod -L version,track

# Check service endpoints distribution
kubectl get endpoints api-service -n app-prod -o yaml

# Count pods by version
kubectl get pods -n app-prod -l version=stable --no-headers | wc -l
kubectl get pods -n app-prod -l version=canary --no-headers | wc -l
```

## Tips

- The service uses **app=api** label to route to both versions simultaneously
- Traffic distribution is proportional to the number of replicas
- Use different labels like **track** to distinguish between deployments
- Monitor logs from both versions during the canary phase
- Canary allows gradual rollout with quick rollback capability

## Time Limit

**20 minutes**
