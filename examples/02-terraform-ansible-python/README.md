# Example 02 - Running Python, virtualenv and Django web page

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

## Run

```bash
cd /home/ec2-user/tcc/venv
```

```bash
django-admin startproject setup .
```

```bash
vim setup/settings.py
```

Change `ALLOWED_HOSTS` to `ALLOWED_HOSTS = ['*']`

```bash
python manage.py runserver 0.0.0.0:8000
```

Access again the page (\<e2-ip\>:8000). It should display:

![django running](./terraform-3.png)