# Day 20  Security, Hardening, and Compliance

## Objective

Learn firewall configuration, AWS security groups,
Kubernetes RBAC, CI/CD credential security, secrets management,
and Docker networking.

## 1. Ansible  iptables

Created:
- ansible/firewall.yml
- ansible/inventory

### Instructor mistake

The original task contained duplicate `command` keys.

### Troubleshooting

...

### Fix

...

### Verification

...

## 2. Terraform  Security Group

Created:
- terraform/main.tf
- terraform/.gitignore

Configured:
- SSH port 22
- HTTP port 80
- outbound traffic

Validated using:
- terraform fmt
- terraform init
- terraform validate
- terraform plan

## 3. Kubernetes  RBAC

Created:
- kubernetes/rbac.yml

Configured ClusterRoleBinding for pathnex-user.

The manifest was prepared for the assignment.
Kubernetes execution requires a working cluster.

## 4. Jenkins

Created:
- jenkins/Jenkinsfile

Learned:
- Jenkins credentials
- Docker registry credentials
- Avoiding passwords in source code

## 5. GitLab CI/CD

Created:
- gitlab/.gitlab-ci.yml

Learned:
- CI/CD variables
- password-stdin
- avoiding indefinite watch commands

## 6. Docker Networking

Created:
- pathnex-network
- container c1
- container c2

Verified container-to-container communication.

## Troubleshooting Lessons

### Lesson 1
Read the exact error before changing commands.

### Lesson 2
Separate YAML/configuration errors from runtime errors.

### Lesson 3
Check the environment before blaming the application.

### Lesson 4
Never intentionally lock yourself out of an EC2 while testing firewall rules.

### Lesson 5
Never put credentials directly into source code.

### Lesson 6
Verify Terraform with plan before applying infrastructure.

## Learning Outcome

Day20 demonstrated practical security and hardening
concepts across Ansible, AWS, Kubernetes, Jenkins,
GitLab CI/CD, and Docker.
