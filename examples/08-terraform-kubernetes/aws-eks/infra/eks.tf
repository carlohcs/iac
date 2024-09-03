module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name    = "my-cluster"
  cluster_version = "1.30"
  cluster_endpoint_public_access  = true
  create_iam_role = false
  iam_role_arn    = var.aws_role_name
  # iam_role_arn    = var.aws_instance_profile_arn

  # Not needed
  # cluster_addons = {
  #   coredns                = {}
  #   eks-pod-identity-agent = {}
  #   kube-proxy             = {}
  #   vpc-cni                = {}
  # }

  vpc_id                   = module.vpc.vpc_id
  # subnet_ids               = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  subnet_ids               = module.vpc.private_subnets
  # control_plane_subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]

  # EKS Managed Node Group(s)
  # eks_managed_node_group_defaults = {
  #   instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  # }
  # eks_managed_node_group_defaults = {
  #   create_iam_role = false
  #   iam_role_arn    = var.aws_instance_profile_arn
  #   # ami_type               = "AL2_x86_64"
  #   # disk_size              = 30
  #   instance_types = [var.aws_instance_type]
  #   vpc_security_group_ids = [aws_security_group.ssh_cluster.id]
  #   node_instance_role = var.aws_instance_profile_arn
  # }

  eks_managed_node_groups = {
    application = {
      create_iam_role = false
      iam_role_arn    = var.iam_role_arn
      # iam_role_arn	= var.aws_instance_profile_arn

      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      # ami_type       = "AL2023_x86_64_STANDARD"
      # instance_types = ["m5.xlarge"]
      instance_types = [var.aws_instance_type]

      min_size     = var.aws_instance_min_size
      max_size     = var.aws_instance_max_size
      desired_size = var.aws_instance_min_size
      vpc_security_group_ids = [aws_security_group.ssh_cluster.id]
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  # enable_cluster_creator_admin_permissions = true

  # access_entries = {
  #   # One access entry with a policy associated
  #   aws_academy = {
  #     kubernetes_groups = []
  #     principal_arn     = var.aws_iam_role_arn

  #     # policy_associations = {
  #     #   example = {
  #     #     policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  #     #     access_scope = {
  #     #       namespaces = ["default"]
  #     #       type       = "namespace"
  #     #     }
  #     #   }
  #     # }
  #   }
  # }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}