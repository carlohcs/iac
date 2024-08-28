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
  region  = "us-east-1"
}

resource "aws_instance" "app_python" {
  ami           = "ami-066784287e358dad1"
  instance_type = "t2.micro"
  # Terram form will destroy the instance 
  # and create again because it's not possible to add keys to existing instance
  key_name      = "aws-ec2-access" # key at EC2 dashboard

  tags = {
    Name = "Terraform Ansible Python Example"
  }
}
