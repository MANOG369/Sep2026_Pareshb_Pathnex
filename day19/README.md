# Day 19  Advanced Monitoring, Logging, and Security

## Objective

Learn monitoring, logging, container observability, AWS CloudWatch,
Kubernetes logging, and CI/CD monitoring integration.

## 1. Ansible  Prometheus

Created an Ansible playbook to install:

- Prometheus
- Prometheus Node Exporter

Files:

- ansible/prometheus.yml
- ansible/inventory

## 2. Terraform  AWS CloudWatch

Created:

- CloudWatch Log Group
- CloudWatch Log Stream

Files:

- terraform/main.tf
- terraform/.gitignore

A CloudWatch log group and stream do not automatically receive
application logs without a log producer/configuration.

## 3. Kubernetes  Fluentd

Created:

- Fluentd Deployment
- Fluentd Service

File:

- kubernetes/fluentd.yml

Kubernetes execution requires a configured Kubernetes cluster.

## 4. Jenkins

Created a Jenkins pipeline for:

- Docker image build
- Docker image test
- Kubernetes Fluentd deployment
- Pod status check

File:

- jenkins/Jenkinsfile

## 5. GitLab CI/CD

Created pipeline stages for:

- Docker build
- Registry push
- Kubernetes deployment

File:

- gitlab/.gitlab-ci.yml

## 6. Docker  Flask Application

Created a Python Flask application and Docker image.

Files:

- docker/app.py
- docker/Dockerfile

The Flask application returns:

Hello Pathnex

## Troubleshooting Lessons

- Check package availability before installing software.
- Amazon Linux 2023 uses DNF.
- Validate Terraform before applying infrastructure.
- Kubernetes manifests can be prepared independently of cluster execution.
- Avoid indefinite watch commands inside CI/CD pipelines.
- Docker logs help identify application problems.
- CloudWatch resources require a log producer to receive application logs.
- CI/CD configuration should be tested separately from actual deployment.

## Learning Outcome

Day 19 introduced monitoring, logging, Kubernetes observability,
CloudWatch, CI/CD monitoring, and Docker application logging.
