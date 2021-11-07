# CloudWatch Log Group for ECS console logs
resource "aws_cloudwatch_log_group" "svc_console" {
  tags = var.common_tags

  lifecycle { create_before_destroy = true }
}

data "aws_ecs_task_definition" "service" {
  task_definition = aws_ecs_task_definition.service.family
}

# ECS Task Definition
resource "aws_ecs_task_definition" "service" {
  family                   = "${var.namespace}-${var.env}-${var.module_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  # TODO: create specific task role and assign it here
  # task_role_arn             = "${aws_iam_role.task_execution.arn}"
  execution_role_arn = aws_iam_role.task_execution.arn

  cpu    = var.svc_cpu
  memory = var.svc_memory

  container_definitions = <<DEFINITION
[
    {
        "name": "service",
        "image": "${aws_ecr_repository.ecr.repository_url}:latest",
        "portMappings": [
            {
                "protocol": "tcp",
                "containerPort": ${var.svc_port}
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${aws_cloudwatch_log_group.svc_console.name}",
                "awslogs-region": "${var.region}",
                "awslogs-stream-prefix": "ecs"
            }
        },
        "environment": [ ],
        "secrets": [ ]
    }
]
DEFINITION

  tags = var.common_tags
}
