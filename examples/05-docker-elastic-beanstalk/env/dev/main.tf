module "development" {
  source = "../../infra"

  application_name = "application-beanstalk-dev"
  application_description = "An beanstalk application for development"
  application_environment = "development"
  application_solution_stack_name = "64bit Amazon Linux 2023 v4.0.12 running ECS"
  aws_profile = "academy"
  aws_region = "us-east-1"
  aws_instance_type = "t2.micro"
  aws_instance_max_size = 2
  ecr_repository_name = "ecr-repository-dev"
  docker_image_name = "carlohcs/basic-app:latest"
  use_aws_defined_role = true
  aws_role_name = "arn:aws:iam::520138362070:role/LabRole"
  aws_instance_profile_arn = "arn:aws:iam::520138362070:instance-profile/LabInstanceProfile"
  ssh_key_name = "aws-ec2-access"
  ssh_key = "~/.ssh/aws-ec2-access"
  # security_group_name = "dev-full-security-group-access"
}