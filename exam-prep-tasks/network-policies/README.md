# Network Policies - CKAD Exam Task

## Task

You need to implement network policies to control traffic between Pods in a multi-tier application.

**Scenario:**
Your organization runs a three-tier application with frontend, backend, and database components. You need to implement network policies to enforce the following security rules:
- Frontend can only communicate with backend
- Backend can only communicate with database
- Database accepts connections only from backend
- No other traffic should be allowed

**Requirements:**

1. Create a namespace named **secure-app**.

2. Create three Pods with appropriate labels:

   **Frontend Pod:**
   - Name: **frontend**
   - Namespace: **secure-app**
   - Image: **nginx:alpine**
   - Label: `tier=frontend`
   - Label: `app=webapp`

   **Backend Pod:**
   - Name: **backend**
   - Namespace: **secure-app**
   - Image: **nginx:alpine**
   - Label: `tier=backend`
   - Label: `app=webapp`

   **Database Pod:**
   - Name: **database**
   - Namespace: **secure-app**
   - Image: **nginx:alpine**
   - Label: `tier=database`
   - Label: `app=webapp`

3. Create a NetworkPolicy named **backend-policy** in **secure-app** namespace:
   - Apply to Pods with label `tier=backend`
   - Allow **Ingress** traffic from Pods with label `tier=frontend` on port **80**
   - Allow **Egress** traffic to Pods with label `tier=database` on port **5432**

4. Create a NetworkPolicy named **database-policy** in **secure-app** namespace:
   - Apply to Pods with label `tier=database`
   - Allow **Ingress** traffic only from Pods with label `tier=backend` on port **5432**
   - Deny all other ingress traffic

5. Create a NetworkPolicy named **frontend-policy** in **secure-app** namespace:
   - Apply to Pods with label `tier=frontend`
   - Allow **Egress** traffic to Pods with label `tier=backend` on port **80**
   - Allow **Egress** to DNS (port 53 UDP) for name resolution

6. Verify the network policies are working:
   - Frontend should be able to reach backend
   - Backend should be able to reach database
   - Frontend should NOT be able to reach database directly
   - No external traffic should reach database

## Starting Files

- `pods.yaml` - Pod definitions for all three tiers
- `backend-netpol.yaml` - Partial NetworkPolicy for backend

## Network Policy Concepts

**Policy Types:**
- **Ingress**: Controls incoming traffic to Pods
- **Egress**: Controls outgoing traffic from Pods

**Pod Selector:**
- Determines which Pods the policy applies to
- Uses label selectors

**Rules:**
- **from**: Specifies allowed sources (for Ingress)
- **to**: Specifies allowed destinations (for Egress)
- Can select by: podSelector, namespaceSelector, or ipBlock

**Default Behavior:**
- Without NetworkPolicies: All traffic allowed
- With NetworkPolicy applied: Default deny for policy types specified
- Must explicitly allow desired traffic

## Verification Commands

```bash
# Check NetworkPolicies
kubectl get networkpolicies -n secure-app
kubectl describe networkpolicy backend-policy -n secure-app
kubectl describe networkpolicy database-policy -n secure-app
kubectl describe networkpolicy frontend-policy -n secure-app

# Check Pods
kubectl get pods -n secure-app --show-labels

# Test connectivity (should succeed)
kubectl exec -n secure-app frontend -- wget -qO- --timeout=2 http://backend
kubectl exec -n secure-app backend -- nc -zv database 5432 -w 2

# Test blocked connectivity (should fail)
kubectl exec -n secure-app frontend -- nc -zv database 5432 -w 2

# Verify DNS is allowed from frontend
kubectl exec -n secure-app frontend -- nslookup backend
```

## Tips

- NetworkPolicies are namespaced resources
- Policies are additive - multiple policies can apply to same Pod
- Empty `podSelector: {}` selects all Pods in namespace
- If no NetworkPolicy selects a Pod, all traffic is allowed to/from it
- Once a NetworkPolicy selects a Pod, only explicitly allowed traffic is permitted
- CNI plugin must support NetworkPolicies (e.g., Calico, Cilium, Weave)
- Remember to allow DNS (port 53 UDP) for name resolution
- Port numbers are protocol-specific (TCP vs UDP)

## Time Limit

**25 minutes**
