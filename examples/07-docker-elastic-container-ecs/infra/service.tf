# From: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service

resource "aws_ecs_service" "basic_app_ecs_service" {
  name            = "basic-app-ecs-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.basic_app_deployment.arn
  desired_count   = 1

  # Not needed
  # For standard account
  # iam_role        = aws_iam_role.foo.arn
  # depends_on      = [aws_iam_role_policy.foo]

  # Not needed
  # ordered_placement_strategy {
  #   type  = "binpack"
  #   field = "cpu"
  # }

  load_balancer {
    target_group_arn = aws_lb_target_group.load_balancer_target.arn
    container_name   = "basic-application-docker-ecs" # from task definition
    container_port   = 3000
  }

  # Not needed
  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }

  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#network_configuration
  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.private_access_ecs.id]
    assign_public_ip = false
  }

  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#capacity_provider_strategy
  # Avoid other capacity providers
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1 # 100% of the capacity for FARGATE
  }
}
