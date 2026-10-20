s Monitoring and Alerts

## Objective

# Day 25  Continuous Monitoring and Alerts

## Objective

Practice monitoring and alerting concepts with Ansible, Terraform, Kubernetes, Jenkins, GitLab CI/CD, and Docker.

## Technologies

* **Ansible:** Node Exporter installation and service management.
* **Terraform:** CloudWatch metric alarm and SNS topic.
* **Kubernetes:** Prometheus and Grafana Deployments.
* **Jenkins/GitLab CI/CD:** Monitoring and test stages.
* **Docker:** Build-context exclusions using `.dockerignore`.

## Practical Work

### Files created

```text
day25/
 ansible/
    node-exporter.yml
 terraform/
    main.tf
 kubernetes/
    monitoring.yaml
 jenkins/
    Jenkinsfile
 gitlab/
    .gitlab-ci.yml
 docker/
     .dockerignore
```

### Commands actually executed

**Ansible**

```bash
ansible --version
ansible-inventory --list
ansible-inventory -i 'localhost,' --list
ansible-playbook -i 'localhost,' --syntax-check node-exporter.yml
ansible-playbook -i 'localhost,' --list-hosts node-exporter.yml
```

**Terraform**

```bash
terraform fmt -check main.tf
terraform validate
```

**Kubernetes**

```bash
kubectl config current-context
kubectl cluster-info
kubectl config get-contexts
ls -la ~/.kube
```

The Kubernetes manifest was also parsed locally with Python and PyYAML.

**Jenkins**

```bash
cat Jenkinsfile
git diff --no-index /dev/null Jenkinsfile
command -v jenkins
```

**GitLab CI/CD**

The `.gitlab-ci.yml` file was parsed locally using Python and PyYAML.

**Docker**

```bash
cat .dockerignore
```

## Validation Results

| Technology                | Result                                                                                                       |
| ------------------------- | ------------------------------------------------------------------------------------------------------------ |
| Ansible                   | Syntax check passed; localhost inventory and host listing verified.                                          |
| Terraform formatting      | `terraform fmt -check main.tf` returned no output, indicating formatting passed.                             |
| Terraform validation      | Failed because `aws_instance.pathnex_ec2` is undeclared. Not fixed yet.                                      |
| Kubernetes YAML           | Parsing passed; two Deployment documents found: `prometheus` and `grafana`.                                  |
| Kubernetes cluster access | Not available in the current EC2 user's environment because no kubeconfig or current context was configured. |
| Jenkins                   | File contents reviewed. Jenkins executable was not found in `PATH`. Pipeline not executed.                   |
| GitLab CI/CD              | YAML parsing passed; `monitor` and `test` stages and jobs were found.                                        |
| Docker                    | `.dockerignore` contents confirmed. Docker image build not performed.                                        |

## Troubleshooting Log

### Problem 1  Ansible inventory warning

* **Expected:** Ansible should identify the hosts for the playbook.
* **Actual error/output:** The initial `ansible-inventory --list` command warned that no inventory was parsed and only implicit localhost was available.
* **Investigation:** Ran `ansible-inventory -i 'localhost,' --list` and `ansible-playbook -i 'localhost,' --list-hosts node-exporter.yml`.
* **Root cause:** No inventory was configured or successfully loaded by the initial inventory command.
* **Solution:** Supplied a temporary inline localhost inventory using `-i 'localhost,'` for the checks.
* **Validation:** The inventory listed localhost, the playbook syntax check printed `playbook: node-exporter.yml`, and the host listing confirmed one host.
* **Learning:** Ansible needs an inventory to identify its target hosts. A syntax check does not install Node Exporter or start its service.

### Problem 2  Terraform references an undeclared EC2 resource

* **Expected:** `terraform validate` should accept the alarm's EC2 metric dimension reference.
* **Actual error/output:**

  ```text
  Error: Reference to undeclared resource

  A managed resource "aws_instance" "pathnex_ec2"
  has not been declared in the root module.
  ```
* **Investigation:** Ran `terraform fmt -check main.tf` and `terraform validate`.
* **Root cause:** The code references `aws_instance.pathnex_ec2.id`, but no resource with that name is declared in the root module.
* **Solution:** No fix applied yet. Record this as an outstanding issue; do not create an EC2 instance just to make the validation pass.
* **Validation:** Formatting passed, but Terraform validation failed. The configuration is not yet validated.
* **Learning:** Terraform references must point to resources declared in the configuration or to valid available data sources. Formatting success does not mean configuration validation success.

### Problem 3  Kubernetes has no current context

* **Expected:** `kubectl` should identify a Kubernetes cluster and allow the manifest to be checked against it.
* **Actual error/output:**

  ```text
  error: current-context is not set
  ```

  `kubectl cluster-info` attempted to connect to `localhost:8080` and received a connection-refused error. `~/.kube` did not exist for `ssm-user`.
* **Investigation:** Ran `kubectl config current-context`, `kubectl cluster-info`, `kubectl config get-contexts`, and `ls -la ~/.kube`.
* **Root cause:** The current `ssm-user` environment has no configured kubeconfig or current context.
* **Solution:** No cluster configuration was changed. The manifest was checked locally instead.
* **Validation:** Python and PyYAML successfully parsed two documents and printed:

  ```text
  Kind: Deployment, Name: prometheus
  Replicas: 1
  Kind: Deployment, Name: grafana
  Replicas: 1
  ```
* **Learning:** YAML parsing confirms that the document can be read as YAML. It does not prove Kubernetes API validity or successful deployment. The error does not prove that no Kubernetes cluster exists elsewhere.

### Problem 4  Jenkins executable not found

* **Expected:** The Jenkins pipeline could be available for execution or validation.
* **Actual error/output:** `command -v jenkins` returned no path.
* **Investigation:** Reviewed `Jenkinsfile` using `cat` and `git diff --no-index /dev/null Jenkinsfile`.
* **Root cause:** A Jenkins executable was not found in the current shell's `PATH`. Whether Jenkins is installed or available through a separate server was not established.
* **Solution:** No Jenkins installation or pipeline execution was attempted.
* **Validation:** The Jenkinsfile contents were reviewed. No pipeline result is claimed.
* **Learning:** Finding no executable in `PATH` does not prove that a Jenkins server is unavailable.

### Problem 5  Avoiding unintended CloudWatch metric publication

* **Expected:** The assignment includes a monitoring stage that sends a custom CloudWatch metric with value `90`.
* **Actual error/output:** No execution error was produced because the pipeline was not run.
* **Investigation:** Reviewed the Jenkinsfile and GitLab CI configuration. Both contain a `put-metric-data` command.
* **Root cause:** Running those stages would publish a custom metric; it would not measure the EC2 instance's actual CPU utilization.
* **Solution:** Kept the assignment at the typing and syntax-validation stage. Did not run the Jenkins/GitLab pipeline or publish the test metric.
* **Validation:** The files were reviewed and the GitLab YAML was parsed locally. No CloudWatch metric publication or alarm triggering is claimed.
* **Learning:** Reading and validating pipeline code is different from executing it. A custom metric is not the same as actual EC2 CPU monitoring.

## Limitations

* A Terraform alarm requires a valid EC2 metric dimension and an appropriate notification action.
* An SNS topic alone does not configure email delivery.
* Prometheus and Grafana Deployments alone do not establish a complete monitoring stack.
* Publishing a custom metric is not the same as measuring actual EC2 CPU utilization.
* Ansible tasks were syntax-checked, not executed.
* Kubernetes manifests were parsed locally, not deployed or validated against a cluster API.
* Jenkins and GitLab pipelines were not executed.
* No Terraform apply, infrastructure creation, or monitoring deployment was performed.

## Final Status

* **Ansible syntax check:** Passed.
* **Terraform formatting:** Passed.
* **Terraform validation:** Failed  undeclared `aws_instance.pathnex_ec2` reference remains unresolved.
* **Kubernetes client-side validation:** YAML parsing passed; Kubernetes API validation not performed.
* **Jenkins:** File reviewed; pipeline not executed.
* **GitLab CI/CD:** YAML parsing passed; pipeline not executed.
* **Docker:** `.dockerignore` contents confirmed; image not built.
* **Git commit:** Pending.
* **Pull request/merge:** Pending; not yet verified.

