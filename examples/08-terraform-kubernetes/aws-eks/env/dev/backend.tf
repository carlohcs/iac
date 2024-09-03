terraform {
  backend "s3" {
    bucket = "terraform-remote-state-eks-repository-dev"
    key    = "development/backend.tfstate"
    # region = var.aws_region
    # Variables doesn't work here :(
    region = "us-east-1"
  }
}