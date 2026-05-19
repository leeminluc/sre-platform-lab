# =============================================================================
# Dev Environment - Outputs
# =============================================================================
# Production relevance: Environment outputs are consumed by CI/CD pipelines,
# monitoring systems, and developer workflows. They bridge Terraform state
# with the rest of the platform.
# =============================================================================

output "cluster_name" {
  description = "Name of the dev k3s cluster."
  value       = module.k3s_cluster.cluster_name
}

output "k3s_version" {
  description = "K3s version running in the dev cluster."
  value       = module.k3s_cluster.k3s_version
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig for the dev cluster."
  value       = module.k3s_cluster.kubeconfig_path
}

output "cluster_ready" {
  description = "Whether the dev cluster is ready to accept workloads."
  value       = module.k3s_cluster.cluster_ready
}
