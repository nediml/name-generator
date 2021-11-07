resource "aws_lb" "alb" {
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"

  subnets         = var.subnets
  security_groups = [ aws_security_group.lb.id ]

  tags = merge(var.common_tags,{
    Name = "${var.proj_name}-${var.env}-${var.module_name}"
  })

  lifecycle { create_before_destroy = true }
}




