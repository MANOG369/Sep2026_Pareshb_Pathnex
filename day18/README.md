# Day 18  High Availability, Multi-Region, and Auto-scaling

## 1. Ansible  HAProxy Load Balancing

Configured Ansible to install and start HAProxy and manage its configuration using a Jinja2 template.

Files:
- `ansible/haproxy.yml`
- `ansible/haproxy.cfg.j2`

## 2. Terraform  Auto Scaling and Load Balancing

Prepared Terraform configuration for AWS load balancing and Auto Scaling.

Files:
- `terraform/main.tf`
- `terraform/.gitignore`

Note: AWS Auto Scaling Groups are regional resources that can span multiple Availability Zones. True multi-region architecture requires separate regional infrastructure.

## 3. Kubernetes  HPA and Multiple Replicas

Created a Kubernetes deployment with three replicas and an HPA configuration.

Files:
- `kubernetes/deployment.yml`
- `kubernetes/hpa.yml`

The HPA uses `autoscaling/v2` with CPU utilization targeting.

## 4. Kubernetes  Blue-Green Deployment

Created separate Blue and Green deployment configurations.

Files:
- `kubernetes/blue-deployment.yml`
- `kubernetes/green-deployment.yml`

## 5. Jenkins  Blue-Green Deployment

Created a Jenkins pipeline configuration for building the Docker image and applying the Blue and Green Kubernetes deployments.

File:
- `jenkins/Jenkinsfile`

This is a pipeline configuration; Jenkins was not executed on this EC2 environment.

## 6. GitLab CI/CD  Blue-Green Deployment

Created a GitLab CI/CD pipeline for Docker build, registry push, and Kubernetes deployment.

File:
- `gitlab/.gitlab-ci.yml`

This is a CI/CD configuration template; no GitLab runner was executed in this environment.

## 7. Docker  Redis

Ran a Redis Docker container and inspected its `/data` directory.

File:
- `docker/README.md`

Example:

```bash
docker run -d --name pathnex-redis redis
docker ps
docker exec pathnex-redis ls -lah /data
