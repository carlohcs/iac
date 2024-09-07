variable "application_name" {
  description = "The name of the application"
  type        = string
  default     = "application-beanstalk"
}

variable "application_description" {
  description = "The description of the application"
  type        = string
  default     = "An beanstalk application"
}

variable "application_environment" {
  description = "The environment of the application"
  type        = string
  # Environments are often things such as development, integration, or production.
  default     = "development"
}

variable "application_solution_stack_name" {
  description = "The solution stack of the application"
  type        = string
  default     = "64bit Amazon Linux 2023 v4.3.6 running Docker"
}

variable "aws_profile" {
  description = "The AWS profile to use for authentication"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "The AWS region where the resources will be provisioned"
  type        = string
  default     = "us-east-1"
}

variable "aws_availability_zones" {
  description = "The availability zones where the instances will be provisioned"
  type        = list(string)
  default     = [ "us-east-1a", "us-east-1b" ]
}

variable "aws_instance_profile_arn" {
  description = "The ARN of the instance profile"
  type        = string
}

variable "aws_instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "aws_instance_min_size" {
  description = "The minimum size of the auto scaling group"
  type        = number
  default     = 1
}

variable "aws_instance_max_size" {
  description = "The maximum size of the auto scaling group"
  type        = number
  default     = 2
}

variable "ecr_repository_name" { 
  description = "The name of the ECR repository"
  type        = string
  default     = "ecr-repository"
}

variable "docker_image_name" {
  description = "The name of the Docker image"
  type        = string
  default     = "carlohcs/kubernetes-ci-cd-github-actions"
}

variable use_aws_defined_role {
  description = "Whether to use an AWS academy role or not"
  type        = bool
  default     = true
}

variable aws_role_name {
  description = "The name of the academy role"
  type        = string
  default     = "aws-academy-role"
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

variable "cluster_name" {
  description = "The cluster's name of the application"
  type        = string
  default     = "application-cluster"
}

# variable "security_group_name" {
#   description = "The security group name"
#   type        = string
#   default     = "full-dev-access"
# }

# variable "aws_ami" {
#   description = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instance"
#   type        = string
#   default     = "ami-066784287e358dad1"
# }

# variable "instance_description" {
#   description = "The instance description"
#   type        = string
#   default     = "app-server-instance"
# }

# variable "instance_auto_scaling_group_name" {
#   description = "The name of the auto scaling group"
#   type        = string
#   default     = "app-server-asg"
# }

# variable "instance_auto_scaling_group_min_size" {
#   description = "The minimum size of the auto scaling group"
#   type        = number
#   default     = 1
# }

# variable "is_prod" {
#   description = "Whether the environment is production or not"
#   type        = bool
#   default     = false
# }