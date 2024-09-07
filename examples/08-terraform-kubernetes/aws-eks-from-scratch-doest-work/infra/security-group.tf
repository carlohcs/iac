# # https://cursos.alura.com.br/course/infraestrutura-codigo-terraform-docker-elastic-container-service-aws/task/101873
# # Public access to the load balancer is allowed by creating a security group that allows HTTP traffic on port 80.
# resource "aws_security_group" "allow_load_balancer" {
#   name = "allow_load_balancer"
#   description = "Allow HTTP and HTTPS traffic"
#   vpc_id = module.vpc.vpc_id

#   ingress {
#       cidr_blocks = [ "0.0.0.0/0" ]
#       ipv6_cidr_blocks = [ "::/0" ]
#       from_port = 80
#       to_port = 80      
#       protocol = "tcp"
#   }

#   egress {
#       cidr_blocks = [ "0.0.0.0/0" ]
#       ipv6_cidr_blocks = [ "::/0" ]
#       from_port = 0 # all ports
#       to_port = 0 # all ports
#       protocol = "-1" # all protocols
#   }
# }

# # Allow private access to the load balancer
# resource "aws_security_group" "allow_private_ecs_access" {
#   name = "allow_private_ecs_access"
#   description = "Allow HTTP and HTTPS traffic"
#   vpc_id = module.vpc.vpc_id

#   # Let's only allow the load balancer to access the ECS instances by using the security group of the load balancer
#   # security_groups = [ aws_security_group.allow_load_balancer.id ]
#   # source_security_group_id = aws_security_group.allow_load_balancer.id

#   ingress {
#       # Since the load balancer will be accessing, any port can be used
#       from_port = 0
#       to_port = 0     
#       protocol = "tcp"
#   }

#   egress {
#       cidr_blocks = [ "0.0.0.0/0" ]
#       ipv6_cidr_blocks = [ "::/0" ]
#       from_port = 0 # all ports
#       to_port = 0 # all ports
#       protocol = "-1" # all protocols
#   }
# }

resource "aws_security_group" "ssh_cluster" {
  name        = "ssh-cluster"
  # vpc_id      = module.vpc.vpc_id
  vpc_id      = aws_vpc.basic_app_vpc.id
}

resource "aws_security_group_rule" "ssh_cluster_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #0.0.0.0 - 255.255.255.255
  security_group_id = aws_security_group.ssh_cluster.id
}

resource "aws_security_group_rule" "ssh_cluster_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #0.0.0.0 - 255.255.255.255
  security_group_id = aws_security_group.ssh_cluster.id
}

resource "aws_security_group" "private_access_eks" {
  name        = "private_access_eks"
  # vpc_id      = module.vpc.vpc_id
  vpc_id      = aws_vpc.basic_app_vpc.id
}

resource "aws_security_group_rule" "ingress_access_eks" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.ssh_cluster.id
  security_group_id = aws_security_group.private_access_eks.id
}

resource "aws_security_group_rule" "egress_access_eks" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #0.0.0.0 - 255.255.255.255
  security_group_id = aws_security_group.private_access_eks.id
}