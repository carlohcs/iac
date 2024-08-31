terraform {
  backend "s3" {
    bucket = "terraform-remote-state-docker-elastic-beanstalk"
    key    = "development/backend.tfstate"
    # region = var.aws_region
    # Variables doesn't work here :(
    region = "us-east-1"
  }
}