terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_instance" "app_server" {
  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  key_name      = var.ssh_key_name
  tags = {
    Name = var.instance_description
  }

  security_groups = [aws_security_group.full-dev-access.name]
}

resource "aws_key_pair" "ssh-key" {
  key_name = var.ssh_key_name
  public_key = file("${var.ssh_key}.pub") 
}

output "infra_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "cluster_endpoint" {
  value = aws_eks_cluster.basic_app_cluster.endpoint
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.basic_app_cluster.vpc_config[0].cluster_security_group_id
}