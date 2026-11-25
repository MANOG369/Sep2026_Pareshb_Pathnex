# Day 26  Security, SSH Authentication, Network Policies and Monitoring

## 1. Assignment Overview

Day 26 covers six DevOps technologies:

1. Ansible  SSH key authentication
2. Terraform  AWS VPC Flow Logs and CloudWatch
3. Kubernetes  NetworkPolicy
4. Jenkins  Pipeline credentials and deployment
5. GitLab  CI/CD pipeline and secure credentials
6. Docker  Container logs and inspection

## Learning Objectives

- Understand SSH public-key authentication.
- Configure and validate Terraform resources.
- Understand Kubernetes ingress and egress rules.
- Understand Jenkins credential binding.
- Identify secure credential practices in GitLab.
- Troubleshoot Docker containers using logs and inspect.

---

## 2. Ansible  SSH Key Authentication

### Instructor Playbook

File: `ansible/ssh-key-auth.yml`

The original instructor playbook is preserved for learning and comparison.

### Local EC2 Practical

Files:
- `ansible/inventory`
- `ansible/ssh-key-auth-local.yml`

The adapted playbook uses the existing EC2 user's public key instead of
generating or replacing an SSH key.

### Commands Used

```bash
ansible --version
ansible-playbook --syntax-check -i day26/ansible/inventory day26/ansible/ssh-key-auth-local.yml
ansible-playbook -i day26/ansible/inventory day26/ansible/ssh-key-auth-local.yml
ls -l /home/ssm-user/.ssh/authorized_keys
ssh-keygen -lf /home/ssm-user/.ssh/authorized_keys
```

### Result

- Ansible syntax check passed.
- Playbook completed successfully.
- `authorized_keys` was created.
- Public-key fingerprint matched the existing RSA key.

### Learning

The `authorized_keys` file stores public keys allowed to authenticate to a Linux account. The private key must remain secret.

Note: A fresh SSH login test was not performed. The current EC2 session uses AWS Systems Manager Session Manager (SSM).

---

## 3. Terraform  AWS VPC Flow Logs

File: `terraform/main.tf`

### Objective

VPC Flow Logs capture information about IP traffic going to and from
network interfaces in an AWS VPC. CloudWatch Logs can store and help
analyze these records.

### Resources Used

- Existing VPC: `vpc-0cdee2a0cde955069`
- CloudWatch Log Group: `pathnex-flow-logs`
- Terraform resource: `aws_flow_log`

### Troubleshooting

The instructor used the resource type `aws_vpc_flow_log`, which is
unsupported by the AWS Terraform provider.

The correct resource type is `aws_flow_log`.

The CloudWatch destination is configured using the log group's ARN
through `log_destination`.

### Commands Used

```bash
terraform init
terraform validate
```
### Result

- Terraform initialization completed successfully.
- Terraform validation passed.
- Existing VPC was referenced through a Terraform data source.

### Safety and Deployment Limitations

terraform apply was intentionally not executed.

No Flow Log or CloudWatch Log Group was created.

CloudWatch delivery requires a suitable IAM role and permissions.
IAM role inspection returned AccessDenied for iam:ListRoles.
The required CloudWatch delivery role has not been confirmed.

AWS Flow Logs and CloudWatch storage may incur charges if deployed.

---


## 4. Kubernetes  NetworkPolicy

File: `kubernetes/network-policy.yaml`

### Objective
Kubernetes NetworkPolicy controls communication between selected pods.

### Policy Configuration
- Selected pods: `app=pathnex-web-app`
- Ingress allowed from: `app=pathnex-api`
- Egress allowed to: `app=pathnex-database`

### Validation
```bash
python3 -c "import yaml; yaml.safe_load(open('day26/kubernetes/network-policy.yaml')); print('YAML syntax is valid')"
```

Result: YAML syntax validation passed using Python and PyYAML.

### Troubleshooting
The Kubernetes dry-run could not connect because no current context or kubeconfig was available.

### Safety and Limitations
- The NetworkPolicy was not applied to a cluster.
- No Kubernetes cluster was created or modified.
- A NetworkPolicy-capable network plugin is required for enforcement.

---

## 5. Jenkins  Pipeline Credentials and Deployment

File: `jenkins/jenkinsfile`

### Objective
The Jenkins pipeline demonstrates credential binding, Docker image building, and AWS deployment stages.

### Important Concepts
- `credentials()` retrieves credentials stored in Jenkins.
- `docker.build()` requires the Jenkins Docker Pipeline plugin.
- The AWS deployment stage uses the AWS CLI.

### Troubleshooting and Safety
- Jenkins and Groovy were not installed for this exercise.
- Required Jenkins credential IDs must exist before execution.
- The sample AMI ID is a placeholder.
- The deployment command can create a billable EC2 instance.

### Result
The instructor Jenkinsfile was saved and inspected. The pipeline was not executed.
No AWS deployment or new EC2 instance was created.

---

## 6. GitLab  CI/CD Pipeline and Secure Credentials

File: `gitlab/.gitlab-ci.yml`

### Objective
The GitLab pipeline demonstrates build and deployment stages.

### Validation
The GitLab YAML file was validated locally using Python and PyYAML.

### Troubleshooting
- The instructor AWS CLI command uses invalid `--access-key` and `--secret-key` options.
- AWS credentials should be supplied through environment variables, a credential provider, or an IAM role.
- The sample AMI ID is a placeholder.

### Result and Safety
GitLab YAML syntax validation passed.
The GitLab pipeline was not executed. No EC2 deployment was performed.

---

## 7. Docker  Container Troubleshooting

### Objective
Docker logs help inspect container output. Docker inspect provides detailed container configuration and runtime information.

### Initial Problem
The instructor command `docker logs pathnex-nginx` returned No such container.

### Investigation
Used `docker ps -a` to identify the actual existing container name: `pathnex-day24-nginx`.

### Corrected Commands
```bash
docker logs pathnex-day24-nginx
docker inspect pathnex-day24-nginx
```

### Observed Result
- Container status: running.
- Health status: healthy.
- OOMKilled: false.
- Exit code: 0.
- Logs showed HTTP GET requests returning status 200.

### Safety
The existing container was inspected only. It was not stopped, restarted, or removed. Docker images and volumes were preserved.

---

## 8. Final Learning Outcomes

After completing Day 26, the following concepts were practised or studied:

- Ansible: SSH public-key authorization.
- Terraform: AWS VPC Flow Logs configuration and validation.
- Kubernetes: Ingress and egress NetworkPolicy rules.
- Jenkins: Credentials binding and pipeline dependencies.
- GitLab: CI/CD YAML validation and secure AWS credentials.
- Docker: Container logs, inspection, and troubleshooting.

## 9. Practical Safety Summary

- Reused the existing class EC2 instance.
- Did not create a new EC2 instance.
- Did not execute `terraform apply`.
- Did not apply Kubernetes resources.
- Did not execute Jenkins or GitLab deployment pipelines.
- Preserved existing Docker containers, images, and volumes.

Only the practical steps and validation results documented in this README were performed.
