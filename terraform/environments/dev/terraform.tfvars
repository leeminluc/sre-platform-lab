# =============================================================================
# Dev Environment - Variable Values
# =============================================================================
# Production relevance: .tfvars files separate configuration values from code.
# This enables the same Terraform code to manage multiple environments with
# different parameters. In production, .tfvars may contain sensitive values
# and should be handled accordingly (excluded from VCS or encrypted).
#
# NOTE: This file IS committed because our dev values are not sensitive.
# In production, you would use .tfvars.json with git-crypt or SOPS.
# =============================================================================

k3s_version     = "v1.33.11+k3s1"
disable_traefik = true
node_ip         = "127.0.0.1"
