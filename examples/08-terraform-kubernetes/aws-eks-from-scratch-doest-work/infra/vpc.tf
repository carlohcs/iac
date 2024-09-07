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
# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "basic-app-vpc"
#   cidr = "10.0.0.0/16" # 65536 IPs

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"] # Availability Zones
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway = true # Enable NAT Gateway to connect to the internet
#   single_nat_gateway = true # Use only one NAT Gateway
#   enable_vpn_gateway = false # Enable VPN Gateway to connect to the internet

#   tags = {
#     Terraform = "true"
#     Environment = "dev"
#   }
# }

resource "aws_vpc" "basic_app_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "basic-app-vpc"
  }
}

resource "aws_subnet" "basic_app_private_subnet_1" {
  vpc_id            = aws_vpc.basic_app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.aws_availability_zones[0]

  tags = {
    Name = "basic-app-private-subnet-1"
  }
}

resource "aws_subnet" "basic_app_private_subnet_2" {
  vpc_id            = aws_vpc.basic_app_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.aws_availability_zones[1]

  tags = {
    Name = "basic-app-private-subnet-2"
  }
}

resource "aws_subnet" "basic_app_public_subnet_1" {
  vpc_id            = aws_vpc.basic_app_vpc.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = var.aws_availability_zones[0]

  tags = {
    Name = "basic-app-public-subnet-1"
  }
}

resource "aws_subnet" "basic_app_public_subnet_2" {
  vpc_id            = aws_vpc.basic_app_vpc.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = var.aws_availability_zones[1]

  tags = {
    Name = "basic-app-public-subnet-2"
  }
}

resource "aws_internet_gateway" "basic_app_internet_gateway" {
  vpc_id = aws_vpc.basic_app_vpc.id

  tags = {
    Name = "basic-app-gateway"
  }
}

# Provides an Elastic IP resource.
resource "aws_eip" "basic_app_eip" {}

resource "aws_nat_gateway" "basic_app_nat_gateway" {
  allocation_id = aws_eip.basic_app_eip.id
  subnet_id     = aws_subnet.basic_app_private_subnet_1.id

  tags = {
    Name = "basic-app-nat-gateway"
  }
}

resource "aws_route_table" "basic_app_public_route_table" {
  vpc_id = aws_vpc.basic_app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.basic_app_internet_gateway.id
  }

  tags = {
    Name = "basic-app-public-route-table"
  }

  depends_on = [
    aws_internet_gateway.basic_app_internet_gateway
  ]
}

resource "aws_route_table" "basic_app_private_route_table" {
  vpc_id = aws_vpc.basic_app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.basic_app_nat_gateway.id
  }

  tags = {
    Name = "basic-app-private-route-table"
  }

  depends_on = [
    aws_nat_gateway.basic_app_nat_gateway
  ]
}

resource "aws_route_table_association" "basic_app_public_route_table_association" {
  subnet_id      = aws_subnet.basic_app_public_subnet_1.id
  route_table_id = aws_route_table.basic_app_public_route_table.id

  depends_on = [
    aws_subnet.basic_app_public_subnet_1
  ]
}

resource "aws_route_table_association" "basic_app_private_route_table_association" {
  subnet_id      = aws_subnet.basic_app_private_subnet_1.id
  route_table_id = aws_route_table.basic_app_private_route_table.id

  depends_on = [
    aws_subnet.basic_app_private_subnet_1
  ]
}
