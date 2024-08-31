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
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_launch_template" "app_server_template" {
  image_id           = var.aws_ami
  instance_type = var.aws_instance_type
  key_name      = var.ssh_key_name
  
  tags = {
    Name = var.instance_description
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_description
    }
  }

  security_group_names = [ var.security_group_name ]

  # Every time an instance is created, we need to run the user_data script 
  # in order to install the necessary software
  user_data = filebase64("ansible.sh")

  # Conditional user_data
  # user_data = var.user_data ? var.user_data : ""

  # if(condition) {
  #   ...
  # } else {
  #   ...
  # }
}

# How to use the launch template
# resource "aws_instance" "instancia_com_template"{
#     launch_template {
#       id = aws_launch_template.maquina.id
#       version = "$Latest"
#     }
# }

resource "aws_key_pair" "ssh-key" {
  key_name = var.ssh_key_name
  public_key = file("${var.ssh_key}.pub") 
}

resource "aws_autoscaling_group" "app_server_asg" {
  name = var.instance_auto_scaling_group_name
  min_size = var.instance_auto_scaling_group_min_size
  max_size = var.instance_auto_scaling_group_max_size
  availability_zones = var.instance_availability_zones
  # desired_capacity = 2
  # vpc_zone_identifier = [ var.subnet_id ]
  # target_group_arns = [ var.target_group_arn ]

  # Since we are using a load balancer and count is 0, we need to add the target group ARN
  target_group_arns = var.is_prod ? [ aws_lb_target_group.load_balancer_target[0].arn ] : []

  launch_template {
    // Same as before
    id = aws_launch_template.app_server_template.id
    version = "$Latest"
  }
}

# Due to loadbalancer
resource "aws_default_subnet" "subnet_1" {
  availability_zone = var.instance_availability_zones[0]
}

# Due to loadbalancer
resource "aws_default_subnet" "subnet_2" {
  availability_zone = var.instance_availability_zones[1]
}

resource "aws_lb" "load_balancer" {
  name    = "load-balancer"
  internal = false # If true, the load balancer will be internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.full-security-access.id]
  subnets = [ aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id ]

  enable_deletion_protection = false
  # We can define if the resource will be created or not
  count = var.is_prod ? 1 : 0
}

# AWS has a default VPC that we can use
resource "aws_default_vpc" "default_vpc" {}

# Target Group from Load Balancer
# We need to create a target group to associate with the load balancer
resource "aws_lb_target_group" "load_balancer_target" {
  name = "load-balancer-target"
  port = 8000
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default_vpc.id

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  # We can define if the resource will be created or not
  count = var.is_prod ? 1 : 0
}

# Listener from Load Balancer
resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.load_balancer[0].arn
  port = "8000"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_target[0].arn
  }

  # We can define if the resource will be created or not
  count = var.is_prod ? 1 : 0
}

# Autoscaling
resource "aws_autoscaling_policy" "autoscaling" {
  name = "terraform-autoscaling"
  autoscaling_group_name = aws_autoscaling_group.app_server_asg.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }

  # Prevents errors with wrong provision
  depends_on = [aws_autoscaling_group.app_server_asg]

  # We can define if the resource will be created or not
  count = var.is_prod ? 1 : 0
}

# Startup and Shutdown of the instances
resource "aws_autoscaling_schedule" "start_instances" {
  scheduled_action_name = "start_instances"
  autoscaling_group_name = aws_autoscaling_group.app_server_asg.name
  min_size = var.instance_auto_scaling_group_min_size
  max_size = var.instance_auto_scaling_group_max_size
  desired_capacity = var.instance_auto_scaling_group_min_size
  # Cron executes with time + 0, so we need to add 3 hour to the desired time (Brazilian time)
  recurrence = "0 10 * * MON-FRI" # 7am from Monday to Friday

  # We can define if the resource will be created or not
  count = var.is_prod ? 1 : 0
}

resource "aws_autoscaling_schedule" "stop_instances" {
  scheduled_action_name = "stop_instances"
  autoscaling_group_name = aws_autoscaling_group.app_server_asg.name
  min_size = var.instance_auto_scaling_group_min_size
  max_size = var.instance_auto_scaling_group_max_size
  desired_capacity = 1
  # Cron executes with time + 0, so we need to add 3 hour to the desired time (Brazilian time)
  recurrence = "0 21 * * MON-FRI" # 6pm from Monday to Friday

  # We can define if the resource will be created or not
  count = var.is_prod ? 1 : 0
}

# Association from instance to the Target Group
# resource "aws_lb_target_group_attachment" "load_balancer_attacher" {
#   target_group_arn = aws_lb_target_group.load_balancer_target.arn
#   target_id        = aws_launch_template.app_server_template.id
#   port             = 8000
# }

# output "infra_public_ip" {
#   value = aws_instance.app_server.public_ip
# }


# Para configurarmos o load balancer precisamos informar para onde as requisições que chegam devem ser direcionadas, ou seja, quais servidores devem responder as requisições, e também permitir que alterações sejam feitas na infraestrutura, como criar e desligar máquinas.

# No Terraform, essa configuração se dá por meio de um recurso (ou resource, em inglês), nesse caso um recurso chamado aws_lb_target_group. Se dividirmos o nome para entendermos com mais clareza teríamos o grupo alvo do load balancer da AWS.

# Esse recurso precisa de algumas configurações obrigatórias, no nosso caso precisamos informar a porta, o protocolo e o cloud virtual privado (vpc). Também podemos colocar um nome, que não é obrigatório, mas é recomendado.

# O vpc é o local em que nossas máquinas e servidores ficam alocados na AWS, como eles não podem ficar “largados” entre todos os servidores, eles são colocados em grupos chamados vpc e cada usuário tem um vpc padrão e pode criar outros.

# Vamos então criar o código necessário para esse configuração:

# resource "aws_lb_target_group" "alvoLoadBalancer" {
#   name     = "tf-example-lb-tg"
#   port     = "8000"
#   protocol = "HTTP"
#   vpc_id   = aws_default_vpc.default.id
# }

# Lembrando sempre de definir o nome lógico, que foi definido como alvoLoadBalancer e os campos com o nomes em inglês. Além disso, o vpc pede pelo id, então para podermos acessá-lo vamos utilizar o recurso.nomeLogico.id. No caso da nossa configuração ficou aws_default_vpc.default.id com aws_default_vpc como recurso e default como nome lógico.

# Além disso, temos que adicionar mais uma configuração no nosso autoscaling group para permitir a entrada dos dados do load balancer. Essa configuração se chama target_group_arns e temos que fornecer um ou mais ARN (Amazon Resource Names, ou nomes de recursos da Amazon) em forma de strings. Podemos conseguir o ARN do aws_lb_target_group da mesma forma que fizemos com o VPC, então temos que colocar dentro da configuração do autoscaling group a linha:

# target_group_arns = [ aws_lb_target_group.alvoLoadBalancer.arn ]

