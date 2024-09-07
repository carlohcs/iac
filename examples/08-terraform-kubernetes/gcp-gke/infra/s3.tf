resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-basic-app-terraform-state"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "basic-app-terraform-state"
    Environment = "dev"
  }
}