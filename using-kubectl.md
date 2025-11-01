kubectl config set-context --current --namespace=dev

kubectl create deployment nginx-deploy --image=nginx:stable-alpine --replicas=4 --port=80

kubectl get deploy

kubectl get pods

kubectl describe deploy/nginx-deploy

kubectl get deploy nginx-deploy -o yaml

kubectl expose deployment nginx-deploy --port=9000 --target-port=80 --type=NodePort --name=nginx-svc

kubectl get services

kubectl get services -o yaml

KUBE_EDITOR='nano' kubectl edit deploy/nginx-deploy

curl localhost:[NodePort-Number]

This is helpful if you want to check and change file before applying them to k8s.
--dry-run=client -o yaml > filename.yaml

kubectl create -f ./[folder-name]

kubectl set selector service [service-name] 'key=value'

kubectl scale deploy [deployment-name] --replicates=4

kubectl set image deploy [deployment-name] [image-name]

KUBE_EDITOR='[edtior-name]' kubect edit deploy [deployment-name]

kubectl annotate deploy [deployment-name] kubernetes.io/change-cause="Chagne to nginx:1.23.1" --overwrite=true



# Outputting and parsing JSON

kubectl get dpeloy web-app -0 json | jq '.metadata.annotations."kubernetes.io/change-cause"'

# kubectl Cheatsheet

## 🔄 Rollout Commands

```bash
# Restart a deployment (zero downtime)
kubectl rollout restart deployment/my-app

# Check rollout status
kubectl rollout status deployment/my-app

# View rollout history
kubectl rollout history deployment/my-app

# View specific revision
kubectl rollout history deployment/my-app --revision=2

# Rollback to previous version
kubectl rollout undo deployment/my-app

# Rollback to specific revision
kubectl rollout undo deployment/my-app --to-revision=3

# Pause a rollout (for canary deployments)
kubectl rollout pause deployment/my-app

# Resume a paused rollout
kubectl rollout resume deployment/my-app
```

## 🌐 Expose Commands

```bash
# Expose deployment as a service
kubectl expose deployment my-app --port=80 --target-port=8080

# Expose with NodePort
kubectl expose deployment my-app --type=NodePort --port=80

# Expose with LoadBalancer
kubectl expose deployment my-app --type=LoadBalancer --port=80

# Expose pod
kubectl expose pod my-pod --port=80 --name=my-service

# Expose with specific name
kubectl expose deployment my-app --name=my-custom-service --port=80
```

## ✨ Create Commands

```bash
# Create deployment
kubectl create deployment my-app --image=nginx:latest

# Create deployment with replicas
kubectl create deployment my-app --image=nginx --replicas=3

# Create service
kubectl create service clusterip my-service --tcp=80:8080

# Create ConfigMap from literal
kubectl create configmap my-config --from-literal=key=value

# Create ConfigMap from file
kubectl create configmap my-config --from-file=config.json

# Create Secret from literal
kubectl create secret generic my-secret --from-literal=password=secret123

# Create namespace
kubectl create namespace my-namespace

# Create from YAML file
kubectl create -f deployment.yaml

# Create or update (upsert)
kubectl apply -f deployment.yaml
```

## ✏️ Edit Commands

```bash
# Edit deployment in default editor
kubectl edit deployment my-app

# Edit service
kubectl edit service my-service

# Edit ConfigMap
kubectl edit configmap my-config

# Edit with specific editor
KUBE_EDITOR="nano" kubectl edit deployment my-app

# Patch specific field (JSON)
kubectl patch deployment my-app -p '{"spec":{"replicas":5}}'

# Patch specific field (YAML)
kubectl patch deployment my-app --patch '
spec:
  replicas: 5
'

# Set image
kubectl set image deployment/my-app container-name=nginx:1.21

# Set resources
kubectl set resources deployment my-app -c=container --limits=cpu=200m,memory=512Mi

# Set environment variable
kubectl set env deployment/my-app ENV_VAR=value

# Scale deployment
kubectl scale deployment my-app --replicas=3
```

## 🔍 Helpful Get/Describe Commands

```bash
# Get all resources
kubectl get all

# Get pods
kubectl get pods
kubectl get pods -o wide  # More details
kubectl get pods -w       # Watch mode
kubectl get pods --show-lables

# Get deployments
kubectl get deployments
kubectl get deploy        # Short form

# Get services
kubectl get services
kubectl get svc           # Short form

# Get with custom columns
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase

# Describe for detailed info
kubectl describe pod my-pod
kubectl describe deployment my-app
kubectl describe service my-service

# Get YAML/JSON output
kubectl get deployment my-app -o yaml
kubectl get pod my-pod -o json

# Get across all namespaces
kubectl get pods --all-namespaces
kubectl get pods -A       # Short form
```

## 🗑️ Delete Commands

```bash
# Delete pod
kubectl delete pod my-pod

# Delete deployment
kubectl delete deployment my-app

# Delete service
kubectl delete service my-service

# Delete from file
kubectl delete -f deployment.yaml

# Delete with label selector
kubectl delete pods -l app=myapp

# Force delete pod
kubectl delete pod my-pod --grace-period=0 --force
```

## 📊 Logs & Debugging

```bash
# View logs
kubectl logs my-pod

# Follow logs (tail -f)
kubectl logs -f my-pod

# Logs from specific container
kubectl logs my-pod -c container-name

# Previous container logs (after crash)
kubectl logs my-pod --previous

# Logs from all containers in pod
kubectl logs my-pod --all-containers

# Execute command in pod
kubectl exec my-pod -- ls /app

# Interactive shell
kubectl exec -it my-pod -- /bin/bash

# Port forward to local machine
kubectl port-forward pod/my-pod 8080:80
kubectl port-forward service/my-service 8080:80

# Copy files to/from pod
kubectl cp my-pod:/path/to/file ./local-file
kubectl cp ./local-file my-pod:/path/to/file

# Top commands (requires metrics-server)
kubectl top nodes
kubectl top pods
```

## 🏷️ Labels & Selectors

```bash
# Add label
kubectl label pod my-pod env=production

# Remove label (use minus sign)
kubectl label pod my-pod env-

# Get pods by label
kubectl get pods -l app=myapp
kubectl get pods -l 'env in (prod,staging)'

# Update label
kubectl label pod my-pod env=staging --overwrite
```

## 🔧 Context & Config

```bash
# View current context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# Switch context
kubectl config use-context my-context

# Set default namespace
kubectl config set-context --current --namespace=my-namespace

# View kubeconfig
kubectl config view
```

## 🎯 Useful Aliases

Add these to your `~/.bashrc` or `~/.zshrc`:

```bash
alias k=kubectl
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kdd='kubectl describe deployment'
alias kl='kubectl logs'
alias kex='kubectl exec -it'
alias ka='kubectl apply -f'
alias kdel='kubectl delete'
```

## 💡 Quick Tips

- Use `-n namespace` to specify namespace for any command
- Use `--dry-run=client -o yaml` to generate YAML without creating resource
- Use `-w` flag to watch resources update in real-time
- Use `kubectl explain` to get documentation (e.g., `kubectl explain pod.spec`)
- Use tab completion for faster typing (install with `kubectl completion bash`)