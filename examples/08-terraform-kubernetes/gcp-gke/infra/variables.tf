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

variable "gcp_id" {
  description = "The id of the gcp application"
  type        = string
}

# variable "gcp_profile" {
#   description = "The gcp profile to use for authentication"
#   type        = string
#   default     = "default"
# }

variable "gcp_region" {
  description = "The gcp region where the resources will be provisioned"
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "The gcp zone where the resources will be provisioned"
  type        = string
  default     = "us-central1-c"
}

# variable "gcp_instance_profile_arn" {
#   description = "The ARN of the instance profile"
#   type        = string
# }

variable "gcp_instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "e2-micro"
}

# If using:
# provider "kubernetes" {
#   load_config_file = "false"
# variable "gke_username" {
#   default     = ""
#   description = "gke username"
# }

# variable "gke_password" {
#   default     = ""
#   description = "gke password"
# }

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location = var.gcp_region
  version_prefix = "1.27."
}

# variable "gcp_instance_max_size" {
#   description = "The maximum size of the auto scaling group"
#   type        = number
#   default     = 2
# }

# variable "ecr_repository_name" { 
#   description = "The name of the ECR repository"
#   type        = string
#   default     = "ecr-repository"
# }

# variable "docker_image_name" {
#   description = "The name of the Docker image"
#   type        = string
#   default     = "carlohcs/kubernetes-ci-cd-github-actions"
# }

# variable use_gcp_defined_role {
#   description = "Whether to use an gcp academy role or not"
#   type        = bool
#   default     = true
# }

# variable gcp_role_name {
#   description = "The name of the academy role"
#   type        = string
#   default     = "gcp-academy-role"
# }

# variable "ssh_key_name" {
#   description = "The name of the SSH key pair to associate with the EC2 instance"
#   type        = string
#   default     = "gcp-ec2-access"
# }

# variable "ssh_key" {
#   description = "The SSH key to use for connecting to the EC2 instance"
#   type        = string
#   default     = "~/.ssh/gcp-ec2-access"
# }

# variable "security_group_name" {
#   description = "The security group name"
#   type        = string
#   default     = "full-dev-access"
# }

# variable "gcp_ami" {
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

# variable "instance_availability_zones" {
#   description = "The availability zones where the instances will be provisioned"
#   type        = list(string)
#   default     = [ "us-east-1a", "us-east-1b" ]
# }

# variable "is_prod" {
#   description = "Whether the environment is production or not"
#   type        = bool
#   default     = false
# }