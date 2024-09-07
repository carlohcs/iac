variable "aws_profile" {
  description = "Profile from AWS"
  type        = string
  default     = "academy"
}

variable "aws_region" {
  description = "The AWS region where the resources will be provisioned"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment of the application"
  type        = string
  # Environments are often things such as development, integration, or production.
  default = "development"
}

variable "kubernetes_namespace" {
  description = "The Kubernetes namespace where the resources will be provisioned"
  type        = string
  default     = "default"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM Role that will be associated with the Node Group"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones where the subnets will be created"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "e2.micro"
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to associate with the EC2 instance"
  type        = string
  default     = "aws-ec2-access"
}

variable "ssh_key" {
  description = "The SSH key to use for connecting to the EC2 instance"
  type        = string
  default     = "~/.ssh/aws-ec2-access"
}
