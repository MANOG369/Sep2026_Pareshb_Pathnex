# Day 27 — Serverless Scaling with Lambda and DynamoDB

## Objective

Learn how Ansible, Terraform, Kubernetes/Kubeless, Jenkins, and Docker
can be used in a serverless application workflow.

## 1. Ansible — Deploy Serverless Lambda Functions

File: `ansible/deploy-lambda.yml`

- Instructor's AWS Lambda creation command preserved.
- Syntax validation:
  `ansible-playbook --syntax-check day27/ansible/deploy-lambda.yml`
- Result: Syntax check passed.
- The playbook was not executed because the example contains a
  placeholder AWS account ID and IAM role ARN, and the EC2 role
  does not have Lambda deployment permissions.

## 2. Terraform — DynamoDB Table

Files:
- `terraform/main.tf`
- `terraform/dynamodb.tf`

Configuration:
- Table name: `pathnex-table`
- Partition key: `id`
- Attribute type: String
- Billing mode: PAY_PER_REQUEST
- AWS region: `ap-southeast-2`

Validation performed:
- `terraform init` — successful
- `terraform validate` — successful
- `terraform plan` — proposed 1 resource to add

Important:
Terraform apply was intentionally not executed. No DynamoDB table
was created. PAY_PER_REQUEST can incur AWS usage charges.

## 3. Kubernetes — Kubeless Function

File: `kubernetes/function.yaml`

- Function name: `pathnex-lambda`
- Namespace: `default`
- Runtime specified by instructor: `nodejs14`

The YAML was saved and inspected with:
`cat -n day27/kubernetes/function.yaml`

Deployment was not attempted because kubectl is not installed on
this EC2 instance. No Kubernetes cluster or resources were created.

Note: Node.js 14 is an outdated runtime.

## 4. Jenkins — Lambda Deployment Pipeline

Files:
- `jenkins/Jenkinsfile`
- `jenkins/lambda/index.js`
- `jenkins/lambda.zip`

Pipeline stages:
1. Build — packages the Lambda code into lambda.zip.
2. Deploy to Lambda — updates an existing Lambda function.

Local build test:
`cd day27/jenkins`
`zip -r lambda.zip lambda/`
`unzip -l lambda.zip`

Result: ZIP archive created and verified. It contains
`lambda/index.js`.

The AWS deployment stage was not executed. The Lambda function
does not exist in this exercise, and the EC2 IAM role lacks the
required Lambda permissions.

## 5. Docker — Exec and Resource Limits

File: `docker-commands.sh`

Instructor commands preserved:
- `docker exec -it pathnex-nginx bash`
- `docker stats`
- `docker run -d --memory="512m" --cpus="1.0" nginx`

Troubleshooting:
- `docker --version` returned `docker: command not found`.
- Docker is not installed on this EC2 instance.
- The commands were saved but not executed.
- No containers were created.

## Troubleshooting Lessons

| Issue | Root cause | Action |
|---|---|---|
| `kubectl: command not found` | kubectl unavailable | Saved YAML; no cluster created |
| `docker: command not found` | Docker unavailable | Saved commands; no containers started |
| `node: command not found` | Node.js unavailable | Saved example; no runtime installation |
| Ansible warnings about inventory | Playbook uses localhost | Syntax check passed |
| Lambda deployment not performed | Missing Lambda permissions and function | Preserved deployment command only |

## Cost and Safety

- No Lambda function was created.
- No DynamoDB table was created.
- No new EC2 or Kubernetes cluster was created.
- No Docker containers were started.
- Terraform apply was not run.
- Existing Kubernetes EC2 resources were not changed.

## Key Learning

Serverless means running application code without managing the
underlying application servers directly. AWS Lambda provides
function execution, DynamoDB provides a managed NoSQL database,
and CI/CD tools can automate packaging and deployment.

Configuration validation and deployment are different steps.
A successful syntax check or Terraform plan does not mean that
cloud resources have been created.
