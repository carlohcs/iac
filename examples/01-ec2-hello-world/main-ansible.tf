terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-066784287e358dad1"
  instance_type = "t2.micro"
  # Terram form will destroy the instance 
  # and create again because it's not possible to add keys to existing instance
  key_name      = "aws-ec2-access" # key at EC2 dashboard
  # user_data     = file("init.sh")
  # user_data = <<-EOF
  #             #!/bin/bash
  #             # Install busybox
  #             wget https://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/b/busybox-1.36.1-8.fc41.x86_64.rpm
  #             yum install -y busybox-1.36.1-8.fc41.x86_64.rpm

  #             # Create index.html
  #             echo '<h1>Hello, World!</h1><h2>Done with Terraform</h2>' > index.html

  #             # Start a web server with busybox
  #             nohup busybox httpd -f -p 8080 &
  #             EOF

  tags = {
    Name = "HelloWorlddAppServerInstance"
  }
}
