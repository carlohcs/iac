module "aws-prod" {
  source = "../../infra"

  aws_profile      = "academy"
  aws_region       = "us-east-1"
  aws_instance_type = "t2.micro"
  aws_ami           = "ami-066784287e358dad1"
  ssh_key_name          = "aws-ec2-access-prod"
  ssh_key          = "~/.ssh/aws-ec2-access-prod"
  instance_description = "app-server-prod"
  security_group_name = "prod-full-security-group-access"
  instance_auto_scaling_group_name = "app-server-asg-prod"
  instance_auto_scaling_group_min_size = 1
  instance_auto_scaling_group_max_size = 4
  instance_availability_zones       = [ "us-east-1a", "us-east-1b" ]
  is_prod = true
}
