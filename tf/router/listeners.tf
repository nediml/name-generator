resource "aws_lb_listener" "prod" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.tg_blue.arn
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ default_action ]
  }
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 81
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.tg_green.arn
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ default_action ]
  }
}