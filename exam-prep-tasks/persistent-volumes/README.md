# Persistent Volumes and Claims - CKAD Exam Task

## Task

You need to configure persistent storage for a database application using PersistentVolumes and PersistentVolumeClaims.

**Scenario:**
A PostgreSQL database needs persistent storage that survives Pod restarts. You must create a PersistentVolume, claim it with a PersistentVolumeClaim, and mount it in a Pod.

**Requirements:**

1. Create a namespace named **database**.

2. Create a PersistentVolume named **db-pv** with the following specifications:
   - Storage: **2Gi**
   - Access Mode: **ReadWriteOnce**
   - StorageClass: **manual**
   - HostPath: `/mnt/data/postgres`
   - Reclaim Policy: **Retain**

3. Create a PersistentVolumeClaim named **db-pvc** in the **database** namespace:
   - Request: **1Gi** storage
   - Access Mode: **ReadWriteOnce**
   - StorageClass: **manual**
   - Should bind to the **db-pv** PersistentVolume

4. Create a Pod named **postgres-db** in the **database** namespace:
   - Image: **postgres:14-alpine**
   - Environment variable: `POSTGRES_PASSWORD=secretpass`
   - Mount the **db-pvc** at `/var/lib/postgresql/data`
   - Volume mount should have `subPath: pgdata` to avoid permission issues

5. Verify the PersistentVolumeClaim is bound to the PersistentVolume.

6. Verify the Pod is running and using the persistent storage.

7. Exec into the Pod and create a test file in `/var/lib/postgresql/data/pgdata/test.txt`.

8. Delete the Pod and recreate it with the same PVC - verify the test file still exists (demonstrating persistence).

## Starting Files

- `pv.yaml` - PersistentVolume template
- `pvc.yaml` - PersistentVolumeClaim template
- `pod.yaml` - Pod template

## Important Concepts

**PersistentVolume (PV):**
- Cluster-level resource representing physical storage
- Provisioned by administrator or dynamically
- Has lifecycle independent of Pods

**PersistentVolumeClaim (PVC):**
- Namespace-level resource
- Request for storage by a user
- Binds to a PV that satisfies requirements

**Access Modes:**
- **ReadWriteOnce (RWO)**: Volume can be mounted read-write by single node
- **ReadOnlyMany (ROX)**: Volume can be mounted read-only by many nodes
- **ReadWriteMany (RWX)**: Volume can be mounted read-write by many nodes

**Reclaim Policies:**
- **Retain**: Manual reclamation (data preserved)
- **Delete**: Volume and data deleted
- **Recycle**: Basic scrub (deprecated)

## Verification Commands

```bash
# Check PersistentVolume
kubectl get pv
kubectl describe pv db-pv

# Check PersistentVolumeClaim
kubectl get pvc -n database
kubectl describe pvc db-pvc -n database

# Verify binding (STATUS should be Bound)
kubectl get pv db-pv -o jsonpath='{.status.phase}'
kubectl get pvc db-pvc -n database -o jsonpath='{.status.phase}'

# Check Pod
kubectl get pod postgres-db -n database
kubectl describe pod postgres-db -n database

# Create test file
kubectl exec -n database postgres-db -- sh -c "echo 'test data' > /var/lib/postgresql/data/pgdata/test.txt"

# Verify test file
kubectl exec -n database postgres-db -- cat /var/lib/postgresql/data/pgdata/test.txt

# Delete and recreate Pod to test persistence
kubectl delete pod postgres-db -n database
kubectl apply -f pod.yaml
kubectl exec -n database postgres-db -- cat /var/lib/postgresql/data/pgdata/test.txt
```

## Tips

- PV must be created before PVC for manual binding
- StorageClassName must match between PV and PVC for binding
- Capacity, Access Modes, and StorageClass determine PV-PVC binding
- Use `subPath` with postgres to avoid the "lost+found" directory issue
- PVC remains bound even when Pod is deleted (unless reclaim policy is Delete)
- HostPath volumes are only suitable for single-node clusters (not production)

## Time Limit

**20 minutes**
