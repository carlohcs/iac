# Example 08 - Terraform and Kubernetes

## Why this approach?

- Simplifies provider migration;
- Increased fault tolerance;
- Easy service organization with pods;
- Interconnection between providers;

## ECS vs EKS

ECS is a solution developed by AWS to be easy to configure and accelerate the process of launching Docker applications in the cloud. Additionally, it easily integrates with other services such as Application Load Balancer (ALB) and autoscaling groups.

On the other hand, EKS is an open-source tool that provides us with greater flexibility, with APIs and a large community of developers, making it easier to fix errors.

In terms of costs, both ECS and EKS are paid services. However, ECS only charges for the created machines, while EKS charges for both the machines and the cluster. For small applications or a few applications, ECS ends up being slightly cheaper. But if we need more machines, EKS has the advantage due to Kubernetes' better scalability, which reduces costs.

Another important point is that ECS uses proprietary technologies, which makes it difficult to quickly migrate your infrastructure to another provider. This is not the case with EKS, as it is an open technology implemented by various providers.


## Getting Started

```bash
terraform init
```

> Terraform will download the necessary provider plugins and set up the backend configuration. This step is typically performed before running any other Terraform commands in a project.

```bash
terraform plan
```

> Terraform analyzes your configuration files and the current state of your infrastructure to determine what changes need to be made. It then generates a detailed report that outlines the actions it will take to achieve the desired state defined in your configuration files. This includes creating new resources, modifying existing resources, or destroying resources that are no longer needed.

```bash
terraform apply
```

> Terraform will apply the changes defined in the Terraform configuration files to the target infrastructure. This command is typically used after making changes to the Terraform configuration files to deploy or update the infrastructure resources.

## Set up

TODO: FIX DOC

```text
# ansible-galaxy collection install kubernetes.core
# gcloud container clusters get-credentials thermal-micron-427901-e1-gke --region us-central1 --project thermal-micron-427901-e1
# Error:
# CRITICAL: ACTION REQUIRED: gke-gcloud-auth-plugin, which is needed for continued use of kubectl, was not found or is not executable. Install gke-gcloud-auth-plugin for use with kubectl by following https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#install_plugin
# gcloud components install gke-gcloud-auth-plugin --quiet
# /Users/carlohcs/.pyenv/versions/3.9.1/bin/python -m pip install kubernetes
# ansible playbook.yaml
```

## References

- [https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform)
- [https://github.com/hashicorp/learn-consul-kubernetes](https://github.com/hashicorp/learn-consul-kubernetes)