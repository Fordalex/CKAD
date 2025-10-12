# Resource Limits and Quotas - CKAD Exam Task

## Task

You need to configure resource requests, limits, and namespace quotas to ensure fair resource allocation.

**Scenario:**
Your team needs to deploy applications with proper resource management to prevent resource starvation and ensure quality of service. You'll configure CPU and memory requests/limits for Pods and set namespace-level quotas.

**Requirements:**

1. Create a namespace named **production**.

2. Create a ResourceQuota named **prod-quota** in the **production** namespace with these limits:
   - Maximum **4** Pods
   - Total CPU requests: **2** cores
   - Total memory requests: **4Gi**
   - Total CPU limits: **4** cores
   - Total memory limits: **8Gi**

3. Create a LimitRange named **prod-limits** in the **production** namespace:
   - **Container defaults:**
     - Default CPU request: **100m**
     - Default memory request: **128Mi**
     - Default CPU limit: **500m**
     - Default memory limit: **512Mi**
   - **Container min/max:**
     - Min CPU: **50m**
     - Max CPU: **1** core
     - Min memory: **64Mi**
     - Max memory: **1Gi**

4. Create a Deployment named **web-app** in the **production** namespace:
   - Replicas: **2**
   - Image: **nginx:1.21-alpine**
   - Container name: **nginx**
   - Resource requests: CPU **200m**, Memory **256Mi**
   - Resource limits: CPU **500m**, Memory **512Mi**

5. Verify the ResourceQuota is being enforced by checking current usage.

6. Try to create a third Pod (manually) that would exceed quota limits and observe the error.

7. Create a Pod named **batch-job** in the **production** namespace:
   - Image: **busybox:1.35**
   - Command: `sleep 3600`
   - Resource requests: CPU **300m**, Memory **512Mi**
   - Resource limits: CPU **800m**, Memory **1Gi**

8. Check if the **batch-job** Pod was created or rejected based on quota limits.

## Starting Files

- `resourcequota.yaml` - ResourceQuota template
- `limitrange.yaml` - LimitRange template
- `deployment.yaml` - Deployment with partial resource configuration

## Resource Management Concepts

**Requests:**
- Minimum amount of resources guaranteed to container
- Used by scheduler to decide which node to place Pod
- Container can use more than requested if available

**Limits:**
- Maximum amount of resources container can use
- Container will be throttled (CPU) or killed (memory) if exceeded
- Cannot exceed node capacity

**Quality of Service (QoS) Classes:**
- **Guaranteed**: requests = limits for all containers
- **Burstable**: requests < limits or requests set without limits
- **BestEffort**: No requests or limits set

**ResourceQuota:**
- Limits aggregate resource consumption per namespace
- Enforced at Pod creation time
- Can limit: CPU, memory, storage, object counts

**LimitRange:**
- Sets default requests/limits for containers
- Enforces min/max constraints
- Applied when Pods are created

## Verification Commands

```bash
# Check ResourceQuota
kubectl get resourcequota -n production
kubectl describe resourcequota prod-quota -n production

# Check LimitRange
kubectl get limitrange -n production
kubectl describe limitrange prod-limits -n production

# Check Deployment and Pods
kubectl get deployment web-app -n production
kubectl get pods -n production

# View Pod resource configuration
kubectl describe pod <pod-name> -n production

# Check quota usage in real-time
kubectl get resourcequota prod-quota -n production -o yaml

# Try to exceed quota (should fail)
kubectl run test-pod --image=nginx -n production --requests=cpu=2,memory=2Gi

# View QoS class of Pods
kubectl get pods -n production -o custom-columns=NAME:.metadata.name,QOS:.status.qosClass
```

## Tips

- Requests must be <= Limits
- If no requests specified but limits are, requests default to limits
- LimitRange defaults are applied only when container doesn't specify values
- ResourceQuota is enforced at namespace level
- Pods without resource definitions may be rejected in namespaces with ResourceQuota
- Use millicores (m) for CPU: 1000m = 1 core
- Use Mi (Mebibyte) or Gi (Gibibyte) for memory
- QoS class affects eviction priority during resource pressure
- Guaranteed QoS Pods have highest priority (last to be evicted)

## Time Limit

**20 minutes**
