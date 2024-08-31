resource "aws_ecr_repository" "ecr_repository" {
  name = var.ecr_repository_name
}