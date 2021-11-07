resource "aws_lb_target_group" "blue" {
  protocol    = "HTTP"
  port        = var.svc_port
  target_type = "ip"
  vpc_id      = var.vpc

  deregistration_delay = 60

  health_check {
    protocol = "HTTP"
    path     = var.svc_health_check_path

    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 10

  }

  tags = merge(var.common_tags,{
    Name = "${var.namespace}-${var.env}-${var.module_name}-blue"
  })
}

resource "aws_lb_target_group" "green" {
  protocol    = "HTTP"
  port        = var.svc_port
  target_type = "ip"
  vpc_id      = var.vpc

  deregistration_delay = 60

  health_check {
    protocol = "HTTP"
    path     = var.svc_health_check_path

    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 10
  }

  tags = merge(var.common_tags,{
    Name = "${var.namespace}-${var.env}-${var.module_name}-green"
  })
}
