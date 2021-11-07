resource "aws_ecs_service" "service" {
  name            = "${var.namespace}-${var.env}-${var.module_name}"
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.service.family
  cluster         = var.ecs_cluster_arn

  # The initial desired count to start with,
  # before Service Auto Scaling begins adjustment.
  desired_count = 1

  network_configuration {
    subnets          = var.subnets
    security_groups  = [ aws_security_group.svc.id ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "service"
    container_port   = var.svc_port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  tags = merge(var.common_tags,{
    Name = "${var.namespace}-${var.env}-${var.module_name}"
  })

  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      task_definition,
    ]
  }

  depends_on = [
    aws_lb_target_group.blue,
    aws_ecs_task_definition.service,
  ]
}
