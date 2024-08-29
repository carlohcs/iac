variable "aws_profile" {
  description = "The AWS profile to use for authentication"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "The AWS region where the resources will be provisioned"
  type        = string
  default     = "us-"
}

variable "aws_instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "aws_ami" {
  description = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instance"
  type        = string
  default     = "ami-066784287e358dad1"
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

variable "instance_description" {
  description = "The instance description"
  type        = string
  default     = "app-server-instance"
}

variable "security_group_name" {
  description = "The security group name"
  type        = string
  default     = "full-dev-access"
}

variable "instance_auto_scaling_group_name" {
  description = "The name of the auto scaling group"
  type        = string
  default     = "app-server-asg"
}

variable "instance_auto_scaling_group_min_size" {
  description = "The minimum size of the auto scaling group"
  type        = number
  default     = 1
}

variable "instance_auto_scaling_group_max_size" {
  description = "The maximum size of the auto scaling group"
  type        = number
  default     = 2
}

variable "instance_availability_zones" {
  description = "The availability zones where the instances will be provisioned"
  type        = list(string)
  default     = [ "us-east-1a", "us-east-1b" ]
}

variable "is_prod" {
  description = "Whether the environment is production or not"
  type        = bool
  default     = false
}