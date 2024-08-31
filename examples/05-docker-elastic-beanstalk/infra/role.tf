# WARNING: IT ONLY WORKS FOR STANDARD AWS ACCOUNTS, NOT FOR AWS ACADEMY ACCOUNTS
# resource "aws_iam_role" "beanstalk_ec2_role" {
#   name = "beanstalk-ec2-role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = {
#     tag-key = "beanstalk-ec2-role"
#   }
# }

# resource "aws_iam_role_policy" "beanstalk_ec2_policy" {
#   name = "beanstalk-ec2-role-policy"
#   role = aws_iam_role.beanstalk_ec2_role.id

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         # https://docs.aws.amazon.com/AmazonECR/latest/APIReference/API_Operations.html
#         Action = [
#           # "ec2:Describe*",
#           "ec2:DescribeInstances", # EC2, for describing the instances
#           "cloudwatch:PutMetricData", # CloudWatch, for monitoring the instances
#           "ds:CreateComputer", # Directory Service, for creating the instances
#           "ds:DescribeDirectories", # Directory Service, for describing the instances
#           "logs:*", # Metrics in general for logging the instances
#           "ssm:*", # Systems Manager, for modifying the instances - we cannot access the instances directly to install software, so we need to use SSM
#           "ec2messages:*", # Communication between the instances and the AWS services
#           "ecr:GetAuthorizationToken", # ECR, for getting the authorization
#           "ecr:BatchCheckLayerAvailability", # ECR, for checking the layers
#           "ecr:GetDownloadUrlForLayer", # ECR, for getting the download URL
#           "ect:GetRepositoryPolicy", # ECR, for getting the repository policy
#           "ecr:DescribeRepositories", # ECR, for describing the repositories
#           "ecr:ListImages", # ECR, for listing the images
#           "ecr:DescribeImages", # ECR, for describing the images
#           "ecr:BatchGetImage", # ECR, for getting the images
#           "s3:*", # S3, for storing the images
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

# resource "aws_iam_instance_profile" "beanstalk_ec2_profile" {
#   name = "beanstalk-ec2-profile"
#   role = aws_iam_role.beanstalk_ec2_role.name
# }

# ---- 
# resource "aws_iam_instance_profile" "beanstalk_ec2_profile" {
#   name = "beanstalk-ec2-profile"
#   role = aws_iam_role.beanstalk_ec2_role.name
# }

# # data "aws_caller_identity" "source" {
# #   provider = aws
# # }

# data "aws_iam_policy_document" "assume_role" {
#   # provider = aws.destination
#   provider = aws
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "AWS"
#       # identifiers = ["arn:aws:iam::${data.aws_caller_identity.source.account_id}:root"]
#       identifiers = [var.aws_role_name]
#     }
#   }
# }

# resource "aws_iam_role" "beanstalk_ec2_role" {
#   name = "beanstalk-ec2-role"

#   # provider            = aws.destination
#   provider = aws
#   assume_role_policy  = data.aws_iam_policy_document.assume_role.json
#   managed_policy_arns = [data.aws_iam_policy.assume_role.arn]
# }