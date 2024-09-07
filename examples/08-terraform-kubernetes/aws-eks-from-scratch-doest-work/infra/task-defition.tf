# From: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition.html

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition.html#example-using-runtime_platform-and-fargate

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/basic-app-deployment"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "basic_app_deployment" {
  family                   = "basic-app-deployment"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  # Prevents: Fargate requires task definition to have execution role ARN to support ECR images.
  execution_role_arn = var.aws_role_name

  # For standard account
  # exectuion_role_arn       = "arn:aws:iam::520138362070:role/LabRole"
#   container_definitions    = <<TASK_DEFINITION
# [
# {
#   "name": "application-beanstalk",
#   "image": "520138362070.dkr.ecr.us-east-1.amazonaws.com/ecr-repository-dev:latest",
#   "command": ["npm", "start"],
#   "environment": [],
#   "essential": true,
#   "memory": 256,
#   "links": [],
#   "mountPoints": [],
#   "portMappings": [
#     {
#       "containerPort": 3000,
#       "hostPort": 80
#     }
#   ]
# }
# ]
# TASK_DEFINITION
  container_definitions = jsonencode([
    {
      "name": "basic-application-docker-ecs",
      "image": "520138362070.dkr.ecr.us-east-1.amazonaws.com/ecr-repository-dev:latest",
      "command": ["npm", "start"],
      "environment": [],
      "essential": true,
      "memory": 512,
      "memory": 256,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/basic-app-deployment",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])

  # Fargate will automatically handle
  # runtime_platform {
  #   operating_system_family = "WINDOWS_SERVER_2019_CORE"
  #   cpu_architecture        = "X86_64"
  # }
}