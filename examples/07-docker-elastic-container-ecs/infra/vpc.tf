# Example of how to use the vpc module
# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"
  
#   name = "my-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway = true
#   single_nat_gateway = true

#   tags = {
#     Terraform = "true"
#     Environment = "dev"
#   }
# }

# https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master
# https://www.terraform.io/language/modules/sources
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "vpc-ecs"
  cidr = "10.0.0.0/16" # 65536 IPs

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"] # Availability Zones
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true # Enable NAT Gateway to connect to the internet
  single_nat_gateway = true # Use only one NAT Gateway
  enable_vpn_gateway = false # Enable VPN Gateway to connect to the internet

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}