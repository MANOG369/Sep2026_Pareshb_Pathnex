# Day 24  Advanced Terraform Modules and CI/CD Pipeline Scaling

## Objective

Learn Terraform modules, Kubernetes HPA, Helm deployments,
Jenkins CI/CD pipeline scaling concepts, and Docker healthchecks.

## Technologies

- Ansible
- Helm
- Terraform
- Kubernetes
- Jenkins
- Docker

## Terraform Modules

The root Terraform configuration uses separate VPC and instance modules.

## Ansible + Helm

Created an Ansible playbook for Helm installation and microservice deployment.

## Kubernetes

Created:
- Deployment
- HorizontalPodAutoscaler

## Jenkins

Created a pipeline demonstrating scaling, build, and deployment stages.

## Docker

Created an Nginx image with a Docker HEALTHCHECK.

## Troubleshooting

### Problem 1

Problem:

[write actual error]

Error:

[copy important error]

Investigation:

[commands used]

Root cause:

[explain why]

Solution:

[what was changed]

Validation:

[command and successful result]

## Important Lessons

- Terraform modules separate infrastructure into reusable components.
- Terraform module outputs allow data to be passed between modules.
- HPA automatically adjusts pod replicas according to resource metrics.
- Jenkins stages can represent CI/CD scaling workflows.
- Docker HEALTHCHECK commands execute inside the container.
- An executable used by HEALTHCHECK must exist inside the image.
