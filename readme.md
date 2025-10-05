# Initial Setup Guide

Step-by-step guide to set up your local Kubernetes development environment using Docker Desktop for CKAD practice.

## Prerequisites

- macOS (this guide is for Mac users)
- Admin access to install software

## Step 1: Install Docker Desktop

1. **Download Docker Desktop**
   - Go to [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
   - Click "Download for Mac" (choose Apple Silicon or Intel based on your Mac)

2. **Install Docker Desktop**
   - Open the downloaded `.dmg` file
   - Drag Docker.app to your Applications folder
   - Open Docker Desktop from Applications
   - Follow the installation prompts
   - Accept the terms and conditions

3. **Verify Docker Installation**
   ```bash
   docker --version
   docker ps
   ```

## Step 2: Enable Kubernetes in Docker Desktop

1. **Open Docker Desktop Settings**
   - Click the Docker icon in the menu bar (top right)
   - Select "Settings" (⚙️ gear icon)

2. **Enable Kubernetes**
   - Click "Kubernetes" in the left sidebar
   - Check the box "Enable Kubernetes"
   - Click "Apply & Restart"
   - **Wait 2-3 minutes** for Kubernetes to start (you'll see a green indicator when ready)

3. **Verify Kubernetes Installation**
   ```bash
   kubectl version --client
   kubectl cluster-info
   kubectl get nodes
   ```

   You should see output showing:
   - kubectl version
   - Kubernetes control plane running at https://kubernetes.docker.internal:6443
   - A node named `docker-desktop` in Ready status

## Step 3: Configure kubectl Context

1. **Check Available Contexts**
   ```bash
   kubectl config get-contexts
   ```

2. **Switch to docker-desktop Context** (if not already active)
   ```bash
   kubectl config use-context docker-desktop
   ```

3. **Verify the Current Context**
   ```bash
   kubectl config current-context
   ```
   Should output: `docker-desktop`

## Step 4: Verify Everything Works

Run a quick test to ensure Kubernetes is working:

```bash
# Check cluster status
kubectl cluster-info

# List all namespaces
kubectl get namespaces

# List all pods in kube-system namespace
kubectl get pods -n kube-system
```

You should see several system pods running (coredns, etcd, kube-apiserver, etc.).

## Common Issues and Solutions

### Issue: Kubernetes Won't Start

**Solution 1: Reset Kubernetes Cluster**
- Docker Desktop → Settings → Kubernetes → "Reset Kubernetes Cluster"
- Wait for it to restart

**Solution 2: Restart Docker Desktop**
- Quit Docker Desktop completely
- Reopen Docker Desktop
- Wait for Kubernetes to start

### Issue: kubectl Command Not Found

**Solution:**
Docker Desktop should install kubectl automatically. If not:
```bash
# Install kubectl via Homebrew
brew install kubectl
```

### Issue: Wrong kubectl Context

**Solution:**
```bash
# Switch to docker-desktop context
kubectl config use-context docker-desktop

# Verify
kubectl config current-context
```

### Issue: Port Already in Use

If you previously used minikube or another Kubernetes tool:
```bash
# Delete minikube cluster
minikube delete

# Remove minikube config
rm -rf ~/.minikube

# Clean up kubectl config
kubectl config delete-context minikube
kubectl config unset users.minikube
```

## Docker Desktop Resource Settings

For CKAD practice, recommended settings:

1. **Open Docker Desktop Settings → Resources**

2. **Adjust Resources:**
   - **CPUs:** 4+ cores (if available)
   - **Memory:** 4-8 GB
   - **Disk:** 20+ GB

3. **Click "Apply & Restart"**

## Next Steps

Once setup is complete:

1. Return to the main [README.md](./readme.md) for CKAD practice exercises
2. Build your first Docker image
3. Deploy pods and services to your local Kubernetes cluster

## Useful Commands Reference

```bash
# Docker commands
docker build -t <image-name>:<tag> .
docker images
docker ps
docker ps -a

# kubectl commands
kubectl get nodes
kubectl get pods
kubectl get services
kubectl apply -f <file.yaml>
kubectl delete -f <file.yaml>
kubectl describe pod <pod-name>
kubectl logs <pod-name>

# Context management
kubectl config get-contexts
kubectl config use-context <context-name>
kubectl config current-context
```

## Resources

- [Docker Desktop Documentation](https://docs.docker.com/desktop/)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [CKAD Curriculum](https://github.com/cncf/curriculum)
