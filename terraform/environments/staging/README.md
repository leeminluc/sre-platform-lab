# Staging Environment

## Status: Placeholder (Future Milestone)

This directory will contain the Terraform configuration for the **staging** environment.

## Planned Configuration

Staging mirrors production with reduced resources:

| Parameter        | Dev         | Staging       | Prod          |
|-----------------|-------------|---------------|---------------|
| k3s_version     | latest      | pinned        | pinned + validated |
| Node count      | 1           | 3 (HA)        | 5+ (HA)       |
| Resource limits  | relaxed     | production-like| strict        |
| State backend   | local       | S3 + DynamoDB | S3 + DynamoDB |
| Monitoring      | basic       | full stack    | full + SLIs   |

## Production Relevance

Staging exists to:
1. **Validate changes** before production — catch regressions early
2. **Mirror production topology** — same Helm charts, same config patterns
3. **Enable failure testing** — chaos engineering, load testing
4. **Provide confidence** — if it works in staging, it's likely safe for prod

## Usage (Future)

```bash
cd terraform/environments/staging
terraform init
terraform plan
terraform apply
```
