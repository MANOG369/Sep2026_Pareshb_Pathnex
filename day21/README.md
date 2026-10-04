# Day 21  Disaster Recovery and Backup Strategies

## Objective

Learn backup, restore, persistent storage, and disaster recovery concepts
using Ansible, Terraform, Kubernetes, Jenkins, GitLab CI/CD, and Docker Compose.

## Ansible

Created an Ansible backup and restore playbook.

Backup:

```bash
tar -czvf /tmp/etc-backup.tar.gz /etc
