# Based on https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# https://stackoverflow.com/a/55228111/3929980
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
  # shared_credentials_file = "${pathexpand("~/.aws/credentials")}"
  
  # assume_role {
  #   role_arn = var.aws_role_name
  # }
}