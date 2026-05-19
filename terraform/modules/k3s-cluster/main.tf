# =============================================================================
# K3s Cluster Module - Main Resource Definitions
# =============================================================================
# Production relevance: This module provisions a k3s Kubernetes cluster using
# a null_resource pattern to execute the k3s install script. In a real
# production environment, you would use cloud-specific modules:
#   - AWS: EKS module (terraform-aws-modules/eks/aws)
#   - GCP: GKE module
#   - Azure: AKS module
#
# The k3s approach is chosen for this lab because:
#   1. Zero cost - runs on local hardware or VMs
#   2. CNCF-certified Kubernetes - not a toy distribution
#   3. Single binary with low resource footprint
#   4. Production features: etcd, HA control plane, embedded registry
#
# Tradeoff: k3s bundles some components (CoreDNS, metrics-server) that would
# be separately managed in a full production cluster. This is acceptable for
# a lab environment but should be noted in documentation.
# =============================================================================

# Generate a random token for k3s cluster join authentication.
# In production, this would be managed via a secrets store.
resource "random_password" "k3s_token" {
  length  = 32
  special = false
}

# Install k3s on the target node.
# For local installation (node_ip = 127.0.0.1), this runs directly.
# For remote installation, this would use the connection block below.
resource "null_resource" "k3s_install" {
  # Build the k3s install command with appropriate flags
  # --disable=traefik: We use NGINX ingress controller instead
  # --write-kubeconfig-mode: Allows non-root kubectl access
  # --token: Shared secret for joining nodes to the cluster
  provisioner "local-exec" {
    command = <<-EOT
      curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${var.k3s_version} K3S_TOKEN=${random_password.k3s_token.result} sh -s - \
        ${var.disable_traefik ? "--disable=traefik" : ""} \
        --write-kubeconfig-mode 644 \
        --kubelet-arg eviction-hard=memory.available<256Mi,nodefs.available<10% \
        --kubelet-arg system-reserved=cpu=200m,memory=256Mi \
        --kubelet-arg kube-reserved=cpu=200m,memory=256Mi
    EOT
  }

  # Uninstall k3s cleanly on destroy.
  # This ensures no orphaned processes, containers, or network config remain.
  provisioner "local-exec" {
    when    = destroy
    command = "/usr/local/bin/k3s-uninstall.sh 2>/dev/null || true"
  }

  # For remote node installation, uncomment the connection block:
  # connection {
  #   type        = "ssh"
  #   host        = var.node_ip
  #   user        = var.ssh_user
  #   private_key = file(var.ssh_private_key_path)
  # }

  triggers = {
    k3s_version = var.k3s_version
    cluster_name = var.cluster_name
  }
}

# Wait for k3s to be ready before declaring creation complete.
# This is a production practice: always verify infrastructure is healthy
# before proceeding. In CI/CD pipelines, this prevents race conditions
# where downstream steps try to use infrastructure that isn't ready.
resource "null_resource" "k3s_ready" {
  depends_on = [null_resource.k3s_install]

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for k3s API server to be ready..."
      for i in $(seq 1 30); do
        if kubectl get nodes 2>/dev/null | grep -q "Ready"; then
          echo "k3s cluster is ready!"
          exit 0
        fi
        echo "Attempt $i/30: k3s not ready yet, waiting 10s..."
        sleep 10
      done
      echo "ERROR: k3s cluster did not become ready within 300s"
      exit 1
    EOT
  }

  triggers = {
    install_id = null_resource.k3s_install.id
  }
}
