# Day 17  Multi-Cloud Deployments, Auto-healing, and Advanced CI/CD

## Completed Topics

### 1. Ansible
Created an Ansible playbook for nginx auto-healing using systemd.

Key concept:
- nginx is enabled and started
- systemd Restart=always is configured
- systemd daemon is reloaded

### 2. Terraform
Created multi-cloud Terraform configuration for:
- AWS VPC
- Azure Resource Group
- Azure Virtual Network

Sensitive Terraform state and variables are excluded from Git.

### 3. Kubernetes
Created a 3-replica nginx Deployment with:
- Liveness probe
- Readiness probe
- Health endpoint

### 4. Jenkins
Created Jenkinsfile for:
- Docker build
- Testing
- Kubernetes deployment
- Rollout verification

### 5. GitLab CI/CD
Created GitLab pipeline for:
- Build
- Container registry push
- AWS deployment
- Azure deployment

### 6. Docker
Ran MySQL 8 container and inspected:
`/var/lib/mysql`

## Troubleshooting Lessons

- Cloud resources must use valid current AMIs.
- Terraform state and provider binaries must not be committed.
- Cloud passwords must not be stored directly in Git.
- Kubernetes probes require a valid health endpoint.
- Jenkins/GitLab configurations are not the same as actually executing the pipelines.
