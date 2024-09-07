module "development" {
  source = "../../infra"

  aws_profile = "academy"
  aws_region  = "us-east-1"
  availability_zones = ["us-east-1a", "us-east-1b"]
  cluster_name = "basic-app-cluster"
  node_role_arn = "arn:aws:iam::520138362070:role/LabRole"
  instance_type = "t3.medium" # It should be a larger one due to aws resources
  ssh_key_name = "aws-ec2-access"
  ssh_key = "~/.ssh/aws-ec2-access"
  environment = "dev"
  kubernetes_namespace = "default"
}

