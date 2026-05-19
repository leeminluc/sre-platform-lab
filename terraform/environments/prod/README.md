# Production Environment

## Status: Placeholder (Future Milestone)

This directory will contain the Terraform configuration for the **production** environment.

## Production-Specific Requirements

Production environments demand stricter controls than dev/staging:

- **Version pinning**: All software versions must be explicitly pinned and validated in staging first
- **HA topology**: Minimum 3 control plane nodes, multiple worker nodes across availability zones
- **State locking**: Remote state backend with DynamoDB locking — no local state
- **Audit logging**: All `terraform plan` and `apply` runs must be auditable
- **Approval gates**: Changes require peer review and manual approval before apply
- **Encryption**: All state and secrets encrypted at rest and in transit

## Planned Architecture (Future)

```
                    ┌─────────────────┐
                    │   Load Balancer │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
        ┌─────┴─────┐ ┌─────┴─────┐ ┌─────┴─────┐
        │  Master 1  │ │  Master 2  │ │  Master 3  │
        │  (AZ-a)    │ │  (AZ-b)    │ │  (AZ-c)    │
        └─────┬──────┘ └─────┬──────┘ └─────┬──────┘
              │              │              │
        ┌─────┴─────┐ ┌─────┴─────┐ ┌─────┴─────┐
        │  Worker 1  │ │  Worker 2  │ │  Worker 3  │
        │  (AZ-a)    │ │  (AZ-b)    │ │  (AZ-c)    │
        └────────────┘ └────────────┘ └────────────┘
```

## Usage (Future)

```bash
cd terraform/environments/prod
terraform init -backend-config=backend.hcl
terraform plan -out=tfplan
# Require manual approval
terraform apply tfplan
```
