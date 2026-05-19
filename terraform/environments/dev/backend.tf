# =============================================================================
# Dev Environment - Terraform State Backend
# =============================================================================
# Production relevance: Remote state backends are CRITICAL in production:
#   1. State locking prevents concurrent modifications (DynamoDB, GCS native)
#   2. Encryption at rest protects sensitive resource metadata
#   3. Shared access enables team collaboration
#   4. State versioning provides disaster recovery
#
# Common production backends:
#   - AWS: S3 + DynamoDB for locking
#   - GCP: GCS with native locking
#   - Azure: Azure Blob Storage with native locking
#   - Terraform Cloud / Spacelift (managed)
#
# For this local lab, we use local state. The configuration below shows
# what a production S3 backend would look like (commented out).
# =============================================================================

# Local state for development (default behavior)
# State files are excluded from Git via .gitignore (*.tfstate)

# Production S3 backend example:
# terraform {
#   backend "s3" {
#     bucket         = "sre-platform-lab-terraform-state"
#     key            = "dev/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#
#     # Role assumption for cross-account state access
#     # role_arn = "arn:aws:iam::123456789012:role/TerraformStateAccess"
#   }
# }
