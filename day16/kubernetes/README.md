# Day16 Kubernetes - Multi-Cluster Federation

## Objective
Demonstrate how a common Kubernetes application can be prepared for deployment
across multiple Kubernetes clusters.

## Application
- Deployment: day16-app
- Replicas: 2
- Container: nginx:alpine
- Service: day16-service

## Multi-Cluster Configuration
The federation-config.yaml file demonstrates two Kubernetes contexts:
- Mumbai cluster
- Virginia cluster

The configuration is a demonstration only. No real cluster credentials are
stored in this repository.

## Deployment Flow
1. Configure multiple Kubernetes cluster contexts.
2. Select the target cluster with kubectl.
3. Deploy the common application manifest.
4. Verify the application and service in each cluster.
