resource "aws_lb" "ecs_load_balancer" {
  name               = "ecs-load-balancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false
}

# Listener from Load Balancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.ecs_load_balancer.arn
  # port = "80" // Doesn't work with port 80
  port = 3000
  protocol = "HTTP"

  # depends_on = [
  #   aws_lb.ecs_load_balancer, 
  #   aws_lb_target_group.load_balancer_target
  # ]

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_target.arn
  }

  tags = {
    Name = "http-listener"
  }
}

# Target Group from Load Balancer
# We need to create a target group to associate with the load balancer
resource "aws_lb_target_group" "load_balancer_target" {
  name = "load-balancer-target"
  port = 3000 // Port that the container is listening
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = module.vpc.vpc_id
}

output "load_balancer_dns" {
  value = aws_lb.ecs_load_balancer.dns_name
}