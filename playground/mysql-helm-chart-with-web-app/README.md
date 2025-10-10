# Notes App - MySQL Helm Chart Demo

A simple Ruby Sinatra notes application with MySQL 8.4 backend deployed via Helm chart. This project demonstrates Helm chart usage, StatefulSets for databases, imperative kubectl commands, and Kubernetes service discovery.

## Application Features

- **Create Notes**: Add notes with a title and content
- **View Notes**: Display all notes in reverse chronological order
- **Delete Notes**: Remove notes from the database
- **Health Check**: Endpoint at `/health` for liveness and readiness probes
- **Persistent Storage**: All notes are stored in MySQL with persistent volumes

## Project Structure

```
.
├── app.rb                      # Sinatra backend
├── Gemfile                     # Ruby dependencies
├── config.ru                   # Rack config
├── Dockerfile                  # Container image
├── public/
│   └── index.html             # Frontend UI
└── k8s/                       # Kubernetes manifests
    ├── mysql-values.yaml      # Helm values for MySQL (PRODUCTION APPROACH)
    ├── mysql-manifests.yaml   # Generated manifests (for reference)
    ├── app-deployment.yaml    # App deployment
    └── app-service.yaml       # App service
```

## Technology Stack

**Backend:**
- Ruby 3.x with Sinatra web framework
- MySQL2 gem for database connectivity
- RESTful API endpoints

**Database:**
- MySQL 8.4.5 (via Bitnami Legacy chart)
- Deployed as StatefulSet via Helm
- Persistent storage with 8Gi volume

**Infrastructure:**
- Kubernetes deployment with 2 replicas
- NodePort service (port 30081)
- Liveness and readiness probes
- Service discovery via Kubernetes DNS

## Prerequisites

- Docker
- Kubernetes cluster (Minikube, Docker Desktop, etc.)
- Helm 3.x installed
- kubectl CLI tool

## Quick Start

### 1. Build the Docker Image

```bash
# Navigate to the project directory
cd playground/mysql-helm-chart-with-web-app

# Build the image
docker build -t notes-app-mysql:1.0 .
```

### 2. Deploy MySQL using Helm

```bash
# Add the Bitnami Helm repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Navigate to the k8s directory
cd k8s

# Install MySQL using the values file
# Note: Using bitnamilegacy/mysql repository (specified in mysql-values.yaml)
helm install mysql bitnami/mysql -f mysql-values.yaml

# Verify the installation
helm list
kubectl get statefulset
kubectl get pvc
kubectl get pods -l app.kubernetes.io/name=mysql
```

### 3. Deploy the Notes App (Imperative Commands)

```bash
# Create the Deployment
kubectl create deployment notes-app \
  --image=notes-app-mysql:1.0 \
  --replicas=2 \
  --port=3000

# Set image pull policy to Never (for local images)
kubectl set image deployment/notes-app notes-app=notes-app-mysql:1.0
kubectl patch deployment notes-app -p '{"spec":{"template":{"spec":{"containers":[{"name":"notes-app","imagePullPolicy":"Never"}]}}}}'

# Add health checks
kubectl set probe deployment/notes-app \
  --liveness \
  --get-url=http://:3000/health \
  --initial-delay-seconds=10 \
  --period-seconds=5

kubectl set probe deployment/notes-app \
  --readiness \
  --get-url=http://:3000/health \
  --initial-delay-seconds=5 \
  --period-seconds=3

# Expose the app via NodePort
kubectl expose deployment notes-app \
  --type=NodePort \
  --port=80 \
  --target-port=3000 \
  --name=notes-app-service

# Set specific NodePort (optional)
kubectl patch service notes-app-service --type='json' -p='[{"op":"replace","path":"/spec/ports/0/nodePort","value":30081}]'

# Wait for the app to be ready
kubectl wait --for=condition=ready pod -l app=notes-app --timeout=60s
```

### 4. Access the App

```bash
# Get the service URL (Minikube)
minikube service notes-app-service --url

# Or access directly via NodePort
# http://localhost:30081 (Docker Desktop)
# http://<node-ip>:30081 (Minikube/other)

# For Minikube, get the IP
minikube ip
# Then visit http://<minikube-ip>:30081
```

## Helm Chart Configuration

### Using Values File (RECOMMENDED for CKAD)

The professional approach is to use a `mysql-values.yaml` file:

```yaml
# MySQL Helm Chart Values
# Chart: bitnami/mysql
# Documentation: https://github.com/bitnami/charts/tree/main/bitnami/mysql

image:
  registry: docker.io
  repository: bitnamilegacy/mysql
  tag: "8.4.5"

auth:
  rootPassword: "rootpass123"
  database: "testdb"
  username: "testuser"
  password: "testpass123"

primary:
  persistence:
    enabled: true
    storageClass: "hostpath"
    size: 8Gi
```

**Important Notes:**
- The database name is `testdb` (as specified in mysql-values.yaml:8)
- The application connects using credentials: `testuser` / `testpass123`
- Storage class is set to `hostpath` with 8Gi size (suitable for local development)
- The app code connects to `mysql` service name (Kubernetes DNS)

**Advantages of using a values file:**
- Version controlled configuration
- Easier to review and modify
- Better for team collaboration
- Industry standard practice
- Required knowledge for CKAD

### Installation Methods Comparison

```bash
# METHOD 1: Values file (RECOMMENDED - Production approach)
helm install mysql bitnami/mysql -f mysql-values.yaml

# METHOD 2: Inline values (Quick testing)
helm install mysql bitnami/mysql --set auth.rootPassword=pass

# METHOD 3: Multiple inline values
helm install mysql bitnami/mysql \
  --set auth.rootPassword=pass \
  --set auth.database=mydb \
  --set primary.persistence.size=2Gi
```

### Viewing Generated Manifests

```bash
# Generate manifests without installing (useful for debugging)
helm template mysql bitnami/mysql -f mysql-values.yaml > mysql-manifests.yaml

# Dry run (validates but doesn't install)
helm install mysql bitnami/mysql -f mysql-values.yaml --dry-run --debug
```

## Helm Commands Reference (CKAD Essential)

```bash
# List installed releases
helm list
helm list --all-namespaces

# Get release status and details
helm status mysql
helm get values mysql              # Show values used in the release
helm get manifest mysql            # Show generated Kubernetes manifests
helm get all mysql                 # Show everything

# Upgrade the release
helm upgrade mysql bitnami/mysql -f mysql-values.yaml

# Upgrade with new values (method 1: Update values file)
# Edit mysql-values.yaml, then:
helm upgrade mysql bitnami/mysql -f mysql-values.yaml

# Upgrade with new values (method 2: Override specific values)
helm upgrade mysql bitnami/mysql -f mysql-values.yaml \
  --set primary.persistence.size=2Gi

# Rollback to previous version
helm rollback mysql              # Rollback to previous revision
helm rollback mysql 1            # Rollback to specific revision
helm history mysql               # View revision history

# Uninstall the release
helm uninstall mysql
helm uninstall mysql --keep-history  # Keep history for rollback

# Validation and debugging
helm install mysql bitnami/mysql -f mysql-values.yaml --dry-run --debug
helm template mysql bitnami/mysql -f mysql-values.yaml > output.yaml
helm lint mysql-values.yaml

# Repository management
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm repo list
helm search repo mysql

# Show chart information
helm show chart bitnami/mysql      # Chart metadata
helm show values bitnami/mysql     # Default values
helm show readme bitnami/mysql     # Chart README
helm show all bitnami/mysql        # Everything
```

## Verify Everything is Working

### Check All Resources

```bash
# Check pods
kubectl get pods

# Expected output:
# mysql-primary-0            1/1     Running
# notes-app-xxxxxxxx-xxxxx   1/1     Running
# notes-app-xxxxxxxx-xxxxx   1/1     Running

# Check services
kubectl get svc

# Check StatefulSet
kubectl get statefulset

# Check PVC (Persistent Volume Claim)
kubectl get pvc
```

### Test the Application

```bash
# Get the service URL
minikube service notes-app-service --url

# Or access via NodePort
# http://localhost:30081 (Docker Desktop)
# http://<minikube-ip>:30081 (Minikube)

# Test the API endpoints
curl http://localhost:30081/health
curl http://localhost:30081/api/notes

# Create a note via API
curl -X POST http://localhost:30081/api/notes \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Note","content":"This is a test"}'
```

### Test MySQL Connection from App Pod

```bash
# Exec into the app pod
kubectl exec -it deployment/notes-app -- sh

# Test MySQL DNS resolution
nslookup mysql

# Test MySQL connection (if mysql-client available)
nc -zv mysql 3306

# Exit the pod
exit
```

## API Endpoints

The application exposes the following RESTful API endpoints:

| Method | Endpoint | Description | Request Body |
|--------|----------|-------------|--------------|
| GET | `/` | Serve the web UI | - |
| GET | `/health` | Health check endpoint | - |
| GET | `/api/notes` | Get all notes | - |
| POST | `/api/notes` | Create a new note | `{"title": "...", "content": "..."}` |
| DELETE | `/api/notes/:id` | Delete a note by ID | - |

**Database Schema:**
```sql
CREATE TABLE notes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

### View Logs

```bash
# MySQL logs
kubectl logs -l app.kubernetes.io/name=mysql

# App logs
kubectl logs -l app=notes-app

# Follow logs
kubectl logs -f deployment/notes-app
```

## Key Kubernetes Concepts

### Helm Chart Components

1. **Chart.yaml** - Chart metadata (name, version, description)
2. **values.yaml** - Default configuration values
3. **templates/** - Kubernetes manifests with templating

### Helm Templating Example

Helm charts use Go templates for dynamic configuration:
```yaml
image: {{ .Values.auth.image }}               # References values.yaml
name: {{ .Chart.Name }}                       # References Chart.yaml
password: {{ .Values.auth.rootPassword | quote }}  # Pipe functions
```

### StatefulSet vs Deployment

**StatefulSet** (used for MySQL):
- Stable pod names: `mysql-0`, `mysql-1`, etc.
- Ordered deployment/scaling
- Persistent storage per pod
- Use for: databases, stateful apps

**Deployment** (used for the app):
- Random pod names: `notes-app-abc123-xyz789`
- Parallel deployment/scaling
- Shared or no persistent storage
- Use for: stateless apps, web servers

## Troubleshooting

### App can't connect to MySQL

```bash
# Check if MySQL is ready
kubectl get pods -l app.kubernetes.io/name=mysql

# Check MySQL logs
kubectl logs mysql-primary-0

# Check app logs
kubectl logs -l app=notes-app

# Verify DNS resolution (service name is mysql)
kubectl exec -it deployment/notes-app -- nslookup mysql
```

### Helm install fails

```bash
# Check if the release already exists
helm list --all

# Uninstall if needed
helm uninstall mysql

# Try again with debug
helm install mysql bitnami/mysql --debug \
  --set auth.rootPassword=rootpassword \
  --set auth.database=notesdb
```

### Pod stuck in Pending

```bash
# Check pod details
kubectl describe pod mysql-primary-0

# Check PVC status
kubectl get pvc

# Check if there's a storage provisioner
kubectl get storageclass
```

### Image pull errors

```bash
# Verify the image exists locally
docker images | grep notes-app-mysql

# For Minikube, ensure you built in the right Docker environment
eval $(minikube docker-env)
docker images
```

## Clean Up

### Remove Everything

```bash
# Delete the app
kubectl delete deployment notes-app
kubectl delete service notes-app-service

# Uninstall MySQL Helm release
helm uninstall mysql

# Delete PVC (persistent data) - check actual PVC name first
kubectl get pvc
kubectl delete pvc data-mysql-primary-0
```

### Remove with Imperative Commands

```bash
# Delete by labels
kubectl delete deployment,service -l app=notes-app

# Or delete by name
kubectl delete deployment notes-app
kubectl delete service notes-app-service
```

## What You'll Learn

1. **Helm Charts** - Package and deploy complex Kubernetes applications
2. **Helm Templating** - Use Go templates for configuration flexibility
3. **StatefulSets with Helm** - Deploy stateful apps with persistent storage
4. **Imperative kubectl** - Create resources without YAML files
5. **Service Discovery** - Apps connect using service names (e.g., `mysql`)
6. **Helm Lifecycle** - Install, upgrade, rollback, and uninstall releases

## Bonus: Using kubectl run for Quick Testing

```bash
# Create a quick test pod
kubectl run mysql-client \
  --image=mysql:8.4 \
  --rm -it --restart=Never \
  -- mysql -h mysql -u root -prootpassword notesdb

# This gives you a MySQL client to test queries directly!
```

## Differences from StatefulSet Demo

| Feature | StatefulSet Demo | Helm Chart Demo |
|---------|------------------|-----------------|
| Database | PostgreSQL | MySQL 8.4 |
| Deployment | Manual YAML files | Bitnami Helm chart |
| Configuration | Hardcoded | Helm values (--set flags) |
| Upgrading | Edit YAML + kubectl apply | helm upgrade |
| App Deployment | YAML files | Imperative kubectl |
| Use Case | Learning basics | Production-like setup |

## Important: Bitnami Repository Changes

**Critical Note:** Bitnami has migrated their MySQL chart to use a newer image repository. For MySQL 8.4.x compatibility, you must specify the legacy repository:

```bash
# REQUIRED: Use bitnamilegacy/mysql for MySQL 8.4.x
helm install mysql bitnami/mysql --set image.repository=bitnamilegacy/mysql

# Or specify in values file (as done in mysql-values.yaml):
# image:
#   repository: bitnamilegacy/mysql
#   tag: "8.4.5"
```

**Why this matters:**
- The default Bitnami MySQL chart now uses newer MySQL versions with different configurations
- Using `bitnamilegacy/mysql` ensures compatibility with MySQL 8.4.x
- This is already configured in `mysql-values.yaml:3` for this project

## CKAD Exam Tips

**Key Skills Demonstrated:**
1. **Helm Chart Management** - Installing, upgrading, and managing Helm releases
2. **Imperative Commands** - Creating Kubernetes resources without YAML files
3. **StatefulSets** - Understanding stateful applications with persistent storage
4. **Service Discovery** - Using Kubernetes DNS for service-to-service communication
5. **Persistent Volumes** - Working with PVCs and storage classes
6. **Health Checks** - Implementing liveness and readiness probes

**Common CKAD Tasks:**
- Deploy applications using Helm charts with custom values
- Create deployments imperatively with kubectl commands
- Configure environment-based database connections
- Set up service discovery between pods
- Manage persistent storage for stateful applications
