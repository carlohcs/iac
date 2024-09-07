resource "aws_eks_cluster" "basic_app_cluster" {
  name     = var.cluster_name
  version  = "1.30"
  role_arn = var.aws_role_name

  vpc_config {
    # Prevents error:
    # │ Can't configure a value for "vpc_config.0.vpc_id": its value will be decided automatically based on the
    # vpc_id = module.vpc.vpc_id
    # subnet_ids = module.vpc.private_subnets
    subnet_ids = [
      aws_subnet.basic_app_private_subnet_1.id,
      aws_subnet.basic_app_private_subnet_2.id
    ]

    endpoint_public_access = true
    # cluster_endpoint_public_access = true
    # cluster_security_group_id = aws_security_group.private_access_eks.id
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = var.ssh_key_name
  public_key = file("${var.ssh_key}.pub") 
}

resource "aws_eks_node_group" "basic_app_node_group" {
  cluster_name    = aws_eks_cluster.basic_app_cluster.name
  node_group_name = "basic-app-node-group"
  node_role_arn   = var.aws_role_name
  # subnet_ids      = module.vpc.private_subnets
  
  subnet_ids = [
    aws_subnet.basic_app_private_subnet_1.id,
    aws_subnet.basic_app_private_subnet_2.id
  ]

  # ami_type       = "AL2_x86_64"
  instance_types = [var.aws_instance_type]
  # capacity_type  = "ON_DEMAND"
  disk_size      = 20

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = [aws_security_group.ssh_cluster.id]
  }

  tags = {
    Name = "basic-app-node-group"
  }

  labels = {
    Environment = "dev"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_subnet.basic_app_private_subnet_1,
    aws_subnet.basic_app_private_subnet_2
  ]
}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster_auth" "basic_app_cluster_auth" {
  name = aws_eks_cluster.basic_app_cluster.name
}
