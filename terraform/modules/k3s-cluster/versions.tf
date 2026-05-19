# =============================================================================
# K3s Cluster Module - Terraform & Provider Version Constraints
# =============================================================================
# Production relevance: Pinning provider and Terraform versions prevents
# supply-chain style breakages from unexpected upstream changes. In production,
# teams use version ranges (e.g., ~> 1.0) to allow patches but not minors.
# =============================================================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    # For k3s on local/remote machines, we use the null resource pattern
    # to execute provisioning scripts via SSH. In a cloud production
    # environment, this would be replaced with the appropriate cloud
    # provider (aws, azurerm, google) to provision managed Kubernetes.
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}
