# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#private-bucket-with-tags
resource "aws_s3_bucket" "beanstalk_deploys" {
  bucket = "${var.application_environment}-beanstalk-deploys"

  tags = {
    Name        = "${var.application_environment}-beanstalk-deploys"
    Environment = var.application_environment
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object#uploading-a-file-to-a-bucket
# TIP: the two resources will be created in parallel, so it can run a race condition
# To avoid, let's use `depends_on` to make sure the bucket is created before the object
# Deprecated
# resource "aws_s3_bucket_object" "docker" {
#   bucket = aws_s3_bucket.beanstalk_deploys.bucket
#   key    = "aws-dockerrun.zip"
#   source = "aws-dockerrun.zip"

#   depends_on = [aws_s3_bucket.beanstalk_deploys]

#   # The filemd5() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
#   # etag = "${md5(file("path/to/file"))}"
#   etag = filemd5("aws-dockerrun.zip")
# }

resource "random_id" "rng" {
  keepers = {
    first = "${timestamp()}"
  }     
  byte_length = 8
}

data "archive_file" "deploy_file" {
  type        = "zip"
  # source_dir  = "${path.module}/./deploy"
  source_dir  = "./deploy"
  # output_path = "deployment.zip"
  output_path = "deployment-${random_id.rng.hex}.zip"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object#uploading-a-file-to-a-bucket
resource "aws_s3_object" "upload_object" {
  bucket = aws_s3_bucket.beanstalk_deploys.bucket
  # key    = "deployment.zip"
  key    = "deployment-${random_id.rng.hex}.zip"
  source = "${data.archive_file.deploy_file.output_path}"

  depends_on = [aws_s3_bucket.beanstalk_deploys]

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  # etag = filemd5("aws-dockerrun.zip")
}