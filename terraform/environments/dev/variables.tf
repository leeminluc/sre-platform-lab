# =============================================================================
# Dev Environment - Input Variables
# =============================================================================
# Production relevance: Environment-level variables allow the same module to
# be configured differently per environment. Dev uses relaxed defaults
# (lower resources, latest versions) while prod would pin versions and
# increase resource allocations.
# =============================================================================

variable "k3s_version" {
  description = "K3s version to install in the dev environment."
  type        = string
  default     = "v1.30.0+k3s1"
}

variable "disable_traefik" {
  description = "Disable Traefik in favor of NGINX ingress controller."
  type        = bool
  default     = true
}

variable "node_ip" {
  description = "IP address of the k3s node. Use 127.0.0.1 for local install."
  type        = string
  default     = "127.0.0.1"
}
