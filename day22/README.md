# Day 22  Multi-Cluster Kubernetes Management

## Objective

Learn how to manage Kubernetes workloads across multiple clusters using
Ansible, Terraform, Kubernetes, Jenkins, GitLab CI/CD, and Docker Compose.

## Technologies

- Kubernetes
- kubectl contexts
- Ansible
- Terraform
- Amazon EKS
- Google GKE
- Kubernetes Federation
- Jenkins
- GitLab CI/CD
- Docker Compose
- MySQL
- Nginx

## 1. Ansible

The Ansible playbook demonstrates deploying Nginx to two Kubernetes
contexts:

- us-east-cluster
- us-west-cluster

The playbook was syntax-checked.

Actual deployment requires both Kubernetes contexts to exist in kubeconfig.

## 2. Terraform

The Terraform assignment demonstrates:

- Amazon EKS
- Google GKE
- Multi-region/multi-cloud Kubernetes infrastructure

The supplied instructor Terraform code references IAM role and subnet
resources that are not included in the assignment.

Therefore the configuration was validated as coursework code but was not
applied to create cloud clusters.

EKS also requires appropriate VPC/subnet configuration.

## 3. Kubernetes

The standard Nginx Deployment contains:

- 3 replicas
- nginx image
- port 80

The FederatedDeployment example was retained as an instructor example.

Federation resources require an appropriate federation controller/CRDs;
a normal Kubernetes cluster does not automatically provide FederatedDeployment.

## 4. Jenkins

The Jenkinsfile contains two deployment stages:

1. Deploy to us-east-cluster
2. Deploy to us-west-cluster

Actual execution requires Jenkins access to both Kubernetes clusters.

## 5. GitLab CI/CD

The GitLab pipeline contains two deployment jobs targeting the two
Kubernetes contexts.

Actual execution requires a GitLab runner with kubectl and cluster access.

## 6. Docker

Docker Compose runs:

- MySQL 8
- Nginx

MySQL uses a simple classroom password:

MYSQL_ROOT_PASSWORD=root

This is not suitable for production.

## Troubleshooting Lessons

### Problem 1  Docker Compose unavailable

Error:

docker: 'compose' is not a docker command.

Cause:

Docker Compose CLI plugin was not available.

Resolution:

Install the Docker Compose CLI plugin and verify:

docker compose version

### Problem 2  Kubernetes context unavailable

If:

kubectl --context=us-east-cluster ...

fails, check:

kubectl config get-contexts

The context must exist before deployment.

### Problem 3  FederatedDeployment not recognized

A normal Kubernetes cluster may not recognize:

FederatedDeployment

because federation requires the appropriate federation controller and
CRDs.

### Problem 4  Terraform undeclared resource

The instructor Terraform references resources such as:

aws_iam_role.eks_cluster_role
aws_iam_role_policy_attachment.eks_cluster_role_policy
aws_subnet.pathnex_subnet

without defining them in the supplied snippet.

The error should be investigated from the Terraform message instead of
randomly changing configuration.

## Validation Commands

```bash
ansible-playbook --syntax-check ansible/deploy-multi-cluster.yml

terraform fmt -check terraform
terraform validate

kubectl apply --dry-run=client -f kubernetes/deployment.yaml

docker compose -f docker/compose.yml config
docker compose -f docker/compose.yml ps
