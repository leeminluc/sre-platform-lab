# =============================================================================
# K3s Cluster Module - Outputs
# =============================================================================
# Production relevance: Outputs expose computed values that downstream
# configurations or CI/CD pipelines need. Marking sensitive outputs prevents
# accidental exposure in logs. Outputs also serve as documentation of what
# a module produces.
# =============================================================================

output "cluster_name" {
  description = "The name of the provisioned k3s cluster."
  value       = var.cluster_name
}

output "k3s_version" {
  description = "The k3s version installed on the cluster."
  value       = var.k3s_version
}

output "node_ip" {
  description = "The IP address of the k3s node."
  value       = var.node_ip
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig file for cluster access."
  value       = var.write_kubeconfig ? var.kubeconfig_path : null
}

output "k3s_token" {
  description = "The k3s cluster join token. Handle with care."
  value       = random_password.k3s_token.result
  sensitive   = true
}

output "cluster_ready" {
  description = "Whether the k3s cluster has passed readiness checks."
  value       = null_resource.k3s_ready.id != null
}
