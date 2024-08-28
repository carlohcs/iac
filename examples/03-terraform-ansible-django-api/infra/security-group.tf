resource "aws_security_group" "full-dev-access" {
  name = "full-dev-access"
  description = "Full dev access"
  
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

  tags = {
    Name = "full-dev-access"
  }
}