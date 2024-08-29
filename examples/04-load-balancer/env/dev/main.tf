module "aws-dev" {
  source = "../../infra"

  aws_profile      = "academy"
  aws_region       = "us-east-1"
  aws_instance_type = "t2.micro"
  aws_ami           = "ami-066784287e358dad1"
  ssh_key_name          = "aws-ec2-access"
  ssh_key          = "~/.ssh/aws-ec2-access"
  instance_description = "app-server-dev"
  security_group_name = "dev-full-security-group-access"
  instance_auto_scaling_group_name = "app-server-asg-dev"
  instance_auto_scaling_group_min_size = 1
  instance_auto_scaling_group_max_size = 1
  instance_availability_zones       = [ "us-east-1a", "us-east-1b" ]
  is_prod = false
}
