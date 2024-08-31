# Example 06 - VM with Google Cloud

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

```bash
terraform destroy
```

> Terraform reads the configuration files in your project and identifies the resources that were created. It then proceeds to destroy those resources, removing them from your infrastructure. This can include terminating virtual machines, deleting storage accounts, removing network configurations, and so on, depending on what resources were defined in your Terraform configuration.
