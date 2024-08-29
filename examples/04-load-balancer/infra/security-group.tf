resource "aws_security_group" "full-security-access" {
  name = var.security_group_name
  description = "Allow HTTP and HTTPS traffic"
  vpc_id = aws_default_vpc.default_vpc.id

  ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = [ "::/0" ]
      from_port = 0 # all ports
      to_port = 0 # all ports
      protocol = "-1" # all protocols
  }

  egress {
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = [ "::/0" ]
      from_port = 0 # all ports
      to_port = 0 # all ports
      protocol = "-1" # all protocols
  }

  # Strict
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = {
    Name = var.security_group_name
  }
}