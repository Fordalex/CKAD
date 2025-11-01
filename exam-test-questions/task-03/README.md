# Task 3: Create a ConfigMap and Use It in a Pod

**Weight**: 4%
**Time Estimate**: 6 minutes

## Task

1. Create a ConfigMap named `app-config` in the `task3` namespace with the following key-value pairs:
   - `db_host=mysql.example.com`
   - `db_port=3306`

2. Create a Pod named `config-pod` using the image `nginx:alpine` that uses the ConfigMap to set environment variables `DB_HOST` and `DB_PORT`

## Solution Approach

- Use `kubectl create configmap --from-literal`
- Create Pod YAML with `envFrom` or `env` with `configMapKeyRef`

## Verification

```bash
kubectl get configmap app-config
kubectl exec config-pod -- env | grep DB_
```

Expected: Should show `DB_HOST=mysql.example.com` and `DB_PORT=3306`

## Things learnt

When you add `--from-literal` if you have mutliple values you have to re-write that for each key value pair.

`kubectl set env deployment/app-config --from=configmap/app-config` this can be used if you have a deployment, if you are just creating a pod you'll need to edit the yaml with `kubectl edit config-pod` and changes this:

envFrom:
   - configMapRef:
      name: app-config
