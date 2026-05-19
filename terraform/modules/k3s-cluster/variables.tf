# =============================================================================
# K3s Cluster Module - Input Variables
# =============================================================================
# Production relevance: Well-defined variables with descriptions, types, and
# defaults make modules self-documenting and enforce contracts between the
# module and its callers. Validation rules prevent misconfiguration early.
# =============================================================================

variable "cluster_name" {
  description = "Name of the k3s cluster. Used for resource naming and identification."
  type        = string
  default     = "sre-platform-lab"

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.cluster_name))
    error_message = "Cluster name must be lowercase alphanumeric with hyphens, no leading/trailing hyphens."
  }
}

variable "k3s_version" {
  description = "K3s version to install. Pin to a specific version for reproducibility."
  type        = string
  default     = "v1.30.0+k3s1"
}

variable "disable_traefik" {
  description = "Disable the default Traefik ingress controller. Set to true when using NGINX ingress instead."
  type        = bool
  default     = true
}

variable "node_ip" {
  description = "IP address of the target node for k3s installation. Use 127.0.0.1 for local install."
  type        = string
  default     = "127.0.0.1"
}

variable "ssh_user" {
  description = "SSH user for remote k3s installation. Not used for local installs."
  type        = string
  default     = null
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key for remote k3s installation. Not used for local installs."
  type        = string
  default     = null
  sensitive   = true
}

variable "write_kubeconfig" {
  description = "Whether to write kubeconfig to local filesystem after cluster creation."
  type        = bool
  default     = true
}

variable "kubeconfig_path" {
  description = "Path to write kubeconfig file. Only used if write_kubeconfig is true."
  type        = string
  default     = "~/.kube/config"
}
