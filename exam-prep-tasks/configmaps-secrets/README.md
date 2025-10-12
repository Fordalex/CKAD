# ConfigMaps and Secrets - CKAD Exam Task

## Task

You need to configure a web application to use environment variables from ConfigMaps and Secrets.

**Scenario:**
A development team needs to deploy a web application that requires database credentials (sensitive) and application configuration (non-sensitive). You must create the necessary ConfigMaps and Secrets, then configure a Pod to consume them.

**Requirements:**

1. Create a namespace named **webapp**.

2. Create a ConfigMap named **app-config** in the **webapp** namespace with the following data:
   - `APP_ENV=production`
   - `LOG_LEVEL=info`
   - `MAX_CONNECTIONS=100`

3. Create a file named `database.conf` with the following content:
   ```
   db_host=postgres.example.com
   db_port=5432
   db_name=appdb
   ```

4. Create a ConfigMap named **db-config** from the `database.conf` file in the **webapp** namespace.

5. Create a Secret named **db-credentials** in the **webapp** namespace with the following data:
   - `username=admin`
   - `password=SecureP@ssw0rd123`
   - Type: **Opaque**

6. Create a Pod named **web-app** in the **webapp** namespace:
   - Use image **nginx:1.21-alpine**
   - Set environment variables from the **app-config** ConfigMap as individual env vars
   - Set environment variable **DB_USERNAME** from the **db-credentials** Secret (username key)
   - Set environment variable **DB_PASSWORD** from the **db-credentials** Secret (password key)
   - Mount the **db-config** ConfigMap as a volume at `/etc/config/database.conf`

7. Verify the Pod is running and exec into it to confirm:
   - All environment variables are set correctly
   - The database.conf file exists at `/etc/config/database.conf` with correct content

## Starting Files

- `app-configmap.yaml` - Partial ConfigMap definition
- `pod-template.yaml` - Pod template needing ConfigMap/Secret integration

## Important Notes

- Secrets should be created with type **Opaque** for generic credentials
- Use `--from-literal` flag for creating secrets from command line
- Use `--from-file` flag for creating ConfigMaps from files
- Environment variables from ConfigMaps use `configMapKeyRef`
- Environment variables from Secrets use `secretKeyRef`

## Verification Commands

```bash
# Check ConfigMaps
kubectl get configmaps -n webapp
kubectl describe configmap app-config -n webapp
kubectl describe configmap db-config -n webapp

# Check Secrets (note: data is base64 encoded)
kubectl get secrets -n webapp
kubectl describe secret db-credentials -n webapp

# Verify Pod configuration
kubectl get pod web-app -n webapp
kubectl describe pod web-app -n webapp

# Exec into Pod and verify
kubectl exec -n webapp web-app -- env | grep -E 'APP_|LOG_|MAX_|DB_'
kubectl exec -n webapp web-app -- cat /etc/config/database.conf
```

## Tips

- Use `kubectl create configmap` with `--from-literal` for key-value pairs
- Use `kubectl create configmap` with `--from-file` for file-based configs
- Use `kubectl create secret generic` for Opaque secrets
- Remember that Secret values are base64 encoded in the manifest
- ConfigMaps and Secrets must exist before Pods that reference them
- Volume mounts require a `volumeMounts` section in containers and `volumes` section in Pod spec

## Time Limit

**15 minutes**
