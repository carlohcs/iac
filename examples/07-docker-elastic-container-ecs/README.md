# Example 07 - Docker, ECR and ECS

![Hello World page result](./doc/hello-world-ecs.png)

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

## Take the generated url

Something like:

```bash
Outputs:
development_load_balancer_dns = "ecs-load-balancer-1732799033.us-east-1.elb.amazonaws.com"
```

## Push the image and the application will be deployed

```bash
docker push 520138362070.dkr.ecr.us-east-1.amazonaws.com/ecr-repository-dev:latest
```

## Access the previous url at the browser adding the port

```text
ecs-load-balancer-1732799033.us-east-1.elb.amazonaws.com:3000
```
