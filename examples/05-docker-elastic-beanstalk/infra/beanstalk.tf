resource "aws_elastic_beanstalk_application" "application_beanstalk" {
  name        = var.application_name
  description = var.application_description

  # appversion_lifecycle {
  #   service_role          = aws_iam_role.beanstalk_service.arn
  #   max_count             = 128
  #   delete_source_from_s3 = true
  # }
}

resource "aws_elastic_beanstalk_environment" "application_beanstalk_environment" {
  name                = var.application_environment
  application         = aws_elastic_beanstalk_application.application_beanstalk.name
  solution_stack_name = var.application_solution_stack_name

  setting {
    namespace = "aws:autoscaling:launchconfiguration" # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options.html#configuration-options-recommendedvalues
    name      = "InstanceType"
    value     = var.aws_instance_type # t2.micro / t2.small / t2.medium / t2.large / t2.xlarge / t2.2xlarge...
  }

  # Enable EC2 connection: https://stackoverflow.com/a/54570569/3929980
  setting {
    namespace = "aws:autoscaling:launchconfiguration" # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options.html#configuration-options-recommendedvalues
    name      = "EC2KeyName"
    value      = "${var.ssh_key_name}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    # value     = var.use_aws_defined_role ? var.aws_role_name : ""
    # value = aws_iam_instance_profile.beanstalk_ec2_profile.name
    value = var.aws_instance_profile_arn
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.aws_instance_max_size
  }
}

# TIP: the two resources will be created in parallel, so it can run a race condition
resource "aws_elastic_beanstalk_application_version" "default" {
  name        = var.application_environment
  application = var.application_name
  description = var.application_description
  bucket      = aws_s3_bucket.beanstalk_deploys.id
  key         = aws_s3_object.upload_object.id

  depends_on = [
    aws_elastic_beanstalk_environment.application_beanstalk_environment, 
    aws_elastic_beanstalk_application.application_beanstalk
    # aws_s3_object.upload_object
  ]
}

resource "aws_key_pair" "ssh-key" {
  key_name = var.ssh_key_name
  public_key = file("${var.ssh_key}.pub") 
}