# K3s Cluster Bootstrap Guide

## Overview

This guide walks you through provisioning a local k3s Kubernetes cluster for the SRE Platform Lab. K3s is a **CNCF-certified** Kubernetes distribution that runs as a single binary, making it ideal for local development and lab environments.

---

## Prerequisites

| Requirement | Version | Check Command |
|-------------|---------|---------------|
| Linux (Ubuntu 20.04+, WSL2) | - | `uname -a` |
| curl | Any | `curl --version` |
| kubectl | >= 1.28 | `kubectl version --client` |
| flux CLI | >= 2.0 | `flux --version` |
| GitHub account | - | - |
| GitHub PAT (Personal Access Token) | - | GitHub Settings → Developer settings → Personal access tokens |

### GitHub PAT Requirements

Your Personal Access Token needs these permissions for FluxCD bootstrap:

| Permission | Why |
|------------|-----|
| `repo` (full control) | Flux needs to commit manifests back to the repository |
| `read:org` | For GitHub organization repos (optional) |

---

## Step 1: Install k3s

### Local Installation (Single Node)

```bash
# Install k3s with custom configuration:
# --disable=traefik    → We'll use NGINX ingress instead
# --write-kubeconfig-mode 644 → Allow non-root kubectl access
# K3S_TOKEN            → Shared secret for node joining (required even for single-node)
curl -sfL https://get.k3s.io | \
  INSTALL_K3S_VERSION=v1.30.0+k3s1 \
  K3S_TOKEN=sre-platform-lab-token \
  sh -s - \
  --disable=traefik \
  --write-kubeconfig-mode 644
```

**Why each flag matters:**

| Flag | Purpose | Production Relevance |
|------|---------|---------------------|
| `INSTALL_K3S_VERSION` | Pin exact k3s version | Prevents unexpected upgrades; always pin versions |
| `K3S_TOKEN` | Shared secret for cluster join | Required for multi-node clusters; must be stored securely |
| `--disable=traefik` | Remove default ingress | We deploy NGINX ingress via GitOps for consistency |
| `--write-kubeconfig-mode 644` | Readable kubeconfig | Enables non-root kubectl; in production, use SSO-based access |

### Verify Installation

```bash
# Check that k3s is running
sudo systemctl status k3s

# Verify the node is ready
sudo k3s kubectl get nodes

# Expected output:
# NAME              STATUS   ROLES                  AGE   VERSION
# your-hostname     Ready    control-plane,master   60s   v1.30.0+k3s1
```

---

## Step 2: Configure kubectl Access

```bash
# Copy the kubeconfig to your local config
# (k3s generates this at /etc/rancher/k3s/k3s.yaml)
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

# IMPORTANT: The default kubeconfig uses 127.0.0.1 as the server address.
# If accessing remotely, replace with the actual server IP:
# sed -i 's/127.0.0.1/YOUR_SERVER_IP/g' ~/.kube/config

# Verify kubectl works
kubectl get nodes
kubectl get pods -A
```

**Why this matters in production:**
- Kubeconfig contains cluster CA certificates and user tokens
- In production, kubeconfig access is controlled via SSO (OIDC) and RBAC
- Never commit kubeconfig to Git (it's in our .gitignore)
- Use `kubectx` and `kubens` for multi-cluster management

---

## Step 3: Verify Core Components

k3s includes several built-in components. Verify they're running:

```bash
# Check all system pods
kubectl get pods -A

# Expected system namespaces:
# kube-system       → CoreDNS, metrics-server, local-path-provisioner
# kube-public       → Cluster info (public)
# default           → Default namespace (avoid using this)
```

| Component | Namespace | Purpose |
|-----------|-----------|---------|
| CoreDNS | kube-system | DNS resolution for services |
| metrics-server | kube-system | Resource usage metrics (required for HPA) |
| local-path-provisioner | kube-system | Dynamic persistent volume provisioning |

---

## Step 4: Install FluxCD CLI

```bash
# Install flux CLI
curl -s https://fluxcd.io/install.sh | sudo bash

# Verify installation
flux --version

# Check that your cluster is ready for Flux
flux check --pre
```

The `flux check --pre` command validates:
- Kubernetes version compatibility
- Required controller namespaces don't already exist
- Network connectivity for container registry access

---

## Step 5: Bootstrap FluxCD

> **What is bootstrap?** Bootstrap installs Flux controllers on the cluster AND configures them to watch a Git repository. This creates the GitOps reconciliation loop.

### Create the GitHub Repository

```bash
# Create the repository on GitHub first
# Either use the GitHub web UI or:
gh repo create sre-platform-lab --public --clone=false
```

### Run Bootstrap

```bash
# Replace YOUR_GITHUB_USERNAME with your actual username
export GITHUB_TOKEN=your_personal_access_token
export GITHUB_USER=YOUR_GITHUB_USERNAME

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=sre-platform-lab \
  --branch=main \
  --path=clusters/dev \
  --personal \
  --read-write-key
```

**What this command does:**

1. Deploys Flux controllers to `flux-system` namespace
2. Creates a `GitRepository` resource pointing to your repo
3. Creates a `Kustomization` resource for `clusters/dev/flux-system`
4. Commits the generated manifests to your repository
5. Starts the reconciliation loop

**Why each flag matters:**

| Flag | Purpose |
|------|---------|
| `--owner` | GitHub username or organization |
| `--repository` | Repository name |
| `--branch` | Git branch to watch (main for production-like flow) |
| `--path` | Path within repo where cluster config lives |
| `--personal` | Indicates a personal repo (not org) |
| `--read-write-key` | Deploy key with write access (needed for Flux to commit) |

### Verify Bootstrap

```bash
# Check Flux controllers are running
kubectl get pods -n flux-system

# Expected pods:
# helm-controller-xxx          Running
# kustomize-controller-xxx     Running
# notification-controller-xxx  Running
# source-controller-xxx        Running
# image-automation-controller  Running (if installed)
# image-reflector-controller   Running (if installed)

# Check Flux reconciliation status
flux get kustomizations

# Check Git repository sync
flux get sources git
```

---

## Step 6: Deploy the Sample Application

After bootstrap, Flux will automatically begin reconciling the cluster state with the Git repository. The sample nginx frontend should deploy automatically:

```bash
# Watch Flux reconcile the applications
flux get kustomizations --watch

# Check the frontend deployment
kubectl get pods -n frontend
kubectl get svc -n frontend

# Test the application
kubectl port-forward -n frontend svc/frontend 8080:80

# In another terminal:
curl http://localhost:8080
```

---

## Step 7: Verify GitOps Workflow

The entire point of GitOps is that **Git is the source of truth**. Let's verify:

```bash
# 1. Check what Flux thinks the desired state is
flux get kustomizations

# 2. Make a change in Git and watch Flux reconcile
# Edit apps/frontend/deployment.yaml (e.g., change replicas)
# Push the change and watch:
flux get kustomizations --watch

# 3. Verify drift detection — manually change a resource
kubectl scale deployment frontend -n frontend --replicas=5
# Within 5 minutes, Flux will revert this back to the Git-defined state
# Watch:
kubectl get deployment frontend -n frontend -w
```

---

## Troubleshooting

### k3s won't start

```bash
# Check k3s service logs
sudo journalctl -u k3s -f

# Common issues:
# - Port 6443 already in use (another k8s distribution?)
# - Insufficient memory (need at least 2GB RAM)
# - Missing kernel modules
```

### WSL2: "modprobe overlay" failure (harmless)

If you see `ExecStartPre=/sbin/modprobe overlay (code=exited, status=1/FAILURE)` in `systemctl status k3s`, **this is safe to ignore on WSL2**. The overlay filesystem is built into the WSL2 kernel rather than being a loadable module, so `modprobe` fails — but the overlay driver works correctly.

Verify k3s is actually working despite this warning:

```bash
# If the node shows "Ready", k3s is fully operational
sudo k3s kubectl get nodes

# If you want to suppress the warning (cosmetic only):
echo "overlay" | sudo tee /etc/modules-load.d/overlay.conf
```

### Flux bootstrap fails

```bash
# Check prerequisites
flux check --pre

# Common issues:
# - Invalid GitHub token (check expiration)
# - Repository doesn't exist
# - Network connectivity issues (check proxy settings)
```

### Pods not deploying

```bash
# Check Flux reconciliation
flux get kustomizations
flux logs --level=error

# Check pod events
kubectl describe pod -n frontend <pod-name>

# Common issues:
# - Image pull errors (check network access to Docker Hub)
# - Resource constraints (node under memory pressure)
# - Kustomization path mismatch
```

---

## Cleanup

```bash
# Uninstall Flux (removes controllers and resources)
flux uninstall

# Uninstall k3s
/usr/local/bin/k3s-uninstall.sh

# Remove kubeconfig
rm ~/.kube/config
```

---

## Production Notes

| Lab Setup | Production Equivalent |
|-----------|----------------------|
| k3s single node | EKS/GKE/AKS managed cluster |
| Local kubeconfig | OIDC/SSO-based kubeconfig |
| k3s default CNI (flannel) | Calico/Cilium with network policies |
| No TLS | cert-manager + Let's Encrypt |
| No secrets management | External Secrets Operator + Vault |
| Manual bootstrap | Terraform + Flux bootstrap in CI/CD |
| Single node | 3+ control plane, N workers across AZs |
