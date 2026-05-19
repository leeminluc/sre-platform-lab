# =============================================================================
# Dev Environment - Main Configuration
# =============================================================================
# Production relevance: This is the environment composition layer. It calls
# the reusable k3s-cluster module with dev-specific values. In production,
# each environment would have its own state file, cloud account, and
# variable overrides. The module composition pattern enables DRY IaC.
# =============================================================================

module "k3s_cluster" {
  source = "../../modules/k3s-cluster"

  cluster_name    = "sre-platform-lab-dev"
  k3s_version     = var.k3s_version
  disable_traefik = var.disable_traefik
  node_ip         = var.node_ip

  write_kubeconfig = true
  kubeconfig_path  = pathexpand("~/.kube/config")

  # SSH configuration for remote nodes (not needed for local k3s)
  # ssh_user             = var.ssh_user
  # ssh_private_key_path = var.ssh_private_key_path
}
