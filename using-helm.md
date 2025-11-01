# Helm Chart Cheat Sheet

## Find

helm searhc hub
helm repo add
helm search repo

## Learn

helm show values
helm pull --untar

## Install

helm install 
helm upgrade
helm uninstall

## Installation & Setup

```bash
# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add a chart repository
helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update repositories
helm repo update

# List repositories
helm repo list

# Remove a repository
helm repo remove stable
```

## Chart Management

```bash
# Search for charts
helm search repo nginx
helm search hub wordpress

# Create a new chart
helm create mychart

# Package a chart
helm package mychart/

# Lint a chart (validate)
helm lint mychart/

# Show chart information
helm show chart bitnami/nginx
helm show values bitnami/nginx
helm show readme bitnami/nginx
```

## Installing & Upgrading

```bash
# Install a chart
helm install myrelease bitnami/nginx

# Install with custom values
helm install myrelease bitnami/nginx -f values.yaml
helm install myrelease bitnami/nginx --set service.type=NodePort

# Install to specific namespace
helm install myrelease bitnami/nginx -n mynamespace --create-namespace

# Dry run (test without installing)
helm install myrelease bitnami/nginx --dry-run --debug

# Upgrade a release
helm upgrade myrelease bitnami/nginx
helm upgrade myrelease bitnami/nginx -f values.yaml

# Install or upgrade (if exists)
helm upgrade --install myrelease bitnami/nginx

# Upgrade with rollback on failure
helm upgrade myrelease bitnami/nginx --atomic --timeout 5m
```

## Managing Releases

```bash
# List releases
helm list
helm list -n mynamespace
helm list --all-namespaces

# Get release status
helm status myrelease

# Get release history
helm history myrelease

# Rollback to previous revision
helm rollback myrelease
helm rollback myrelease 2  # rollback to specific revision

# Uninstall a release
helm uninstall myrelease
helm uninstall myrelease --keep-history
```

## Values & Configuration

```bash
# Get values of installed release
helm get values myrelease

# Get all values (including defaults)
helm get values myrelease --all

# Override values during install/upgrade
helm install myrelease bitnami/nginx \
  --set replicaCount=3 \
  --set image.tag=1.21.0 \
  --set service.type=LoadBalancer

# Multiple values files
helm install myrelease bitnami/nginx \
  -f values.yaml \
  -f values-prod.yaml
```

## Chart Structure

```
mychart/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default values
├── charts/             # Chart dependencies
├── templates/          # Template files
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── _helpers.tpl    # Template helpers
│   └── NOTES.txt       # Post-install notes
└── .helmignore        # Files to ignore
```

## Chart.yaml Structure

```yaml
apiVersion: v2
name: mychart
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1.0"
keywords:
  - example
  - kubernetes
maintainers:
  - name: Your Name
    email: you@example.com
dependencies:
  - name: postgresql
    version: "12.x.x"
    repository: https://charts.bitnami.com/bitnami
```

## Common Template Functions

```yaml
# Access values
{{ .Values.replicaCount }}

# Default values
{{ .Values.service.port | default 80 }}

# Conditionals
{{- if .Values.ingress.enabled }}
# ingress config
{{- end }}

# Loops
{{- range .Values.env }}
- name: {{ .name }}
  value: {{ .value }}
{{- end }}

# Quote strings
value: {{ .Values.name | quote }}

# Include templates
{{- include "mychart.labels" . | nindent 4 }}

# Release information
{{ .Release.Name }}
{{ .Release.Namespace }}
{{ .Chart.Name }}
{{ .Chart.Version }}

# Indent
{{ .Values.config | toYaml | nindent 2 }}
```

## Dependencies

```bash
# Add dependency to Chart.yaml, then:
helm dependency update

# List dependencies
helm dependency list

# Build dependencies
helm dependency build
```

## Testing

```bash
# Run tests
helm test myrelease

# Template rendering (local dry-run)
helm template myrelease mychart/
helm template myrelease mychart/ -f values.yaml

# Debug template rendering
helm install myrelease mychart/ --dry-run --debug
```

## Common Flags

```
-n, --namespace        Specify namespace
-f, --values          Specify values file
--set                 Set values on command line
--create-namespace    Create namespace if not exists
--wait                Wait for resources to be ready
--timeout             Timeout for operations (default 5m)
--atomic              Rollback on failure
--force               Force resource updates
--dry-run             Simulate installation
--debug               Enable verbose output
```

## Useful Commands

```bash
# Get manifest of deployed release
helm get manifest myrelease

# Get all information about a release
helm get all myrelease

# Pull a chart from repository
helm pull bitnami/nginx
helm pull bitnami/nginx --untar

# Show computed values
helm get values myrelease --revision 2

# Plugin management
helm plugin list
helm plugin install <plugin-url>

# Environment info
helm env
helm version
```

## Best Practices

- Use `{{ include }}` instead of `{{ template }}` for better control
- Always use `.Release.Name` in resource names for uniqueness
- Provide sensible defaults in `values.yaml`
- Use `_helpers.tpl` for reusable template snippets
- Add `NOTES.txt` for post-installation instructions
- Use `-` in `{{-` and `-}}` to strip whitespace
- Version your charts semantically
- Document values in comments in `values.yaml`
- Use `helm lint` before packaging
- Test charts with `helm template` and `--dry-run`
