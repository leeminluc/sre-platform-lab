# =============================================================================
# Dev Environment - Provider Configuration
# =============================================================================
# Production relevance: Each environment has its own provider configuration.
# In production, this would include cloud provider credentials scoped to
# the specific environment (e.g., AWS assumed role per account).
# The provider block here is minimal since k3s uses local-exec provisioning.
# =============================================================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}
