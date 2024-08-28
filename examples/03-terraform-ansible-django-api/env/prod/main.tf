module "aws-prod" {
  source = "../../infra"

  aws_profile      = "academy"
  aws_region       = "us-east-1"
  aws_instance_type = "t2.micro"
  aws_ami           = "ami-066784287e358dad1"
  ssh_key_name          = "aws-ec2-access-prod"
  ssh_key          = "~/.ssh/aws-ec2-access-prod"
  instance_description = "app-server-prod"
}

output "IP" {
  #  module.MODULE_NAME.INFRA_OUTPUT NAME
  value       = module.aws-prod.infra_public_ip
  # sensitive   = true
  # description = "description"
  # depends_on  = []
}