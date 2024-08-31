resource "aws_ecr_repository" "ecr_repository" {
  name = var.ecr_repository_name
  force_delete = true # will delete the repository even if it's not empty
}