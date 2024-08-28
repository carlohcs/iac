module "aws-dev" {
  source = "../../infra"

  aws_profile      = "academy"
  aws_region       = "us-east-1"
  aws_instance_type = "t2.micro"
  aws_ami           = "ami-066784287e358dad1"
  ssh_key_name          = "aws-ec2-access"
  ssh_key          = "~/.ssh/aws-ec2-access"
  instance_description = "app-server-dev"
}

output "IP" {
  #  module.MODULE_NAME.INFRA_OUTPUT NAME
  value       = module.aws-dev.infra_public_ip
  # sensitive   = true
  # description = "description"
  # depends_on  = []
}