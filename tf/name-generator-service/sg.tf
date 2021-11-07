# Security Group for ECS service allowing the traffic only from LB
resource "aws_security_group" "svc" {
  description = "${var.namespace}-${var.env}-${var.module_name}"
  vpc_id = var.vpc

  ingress {
    from_port       = var.svc_port
    to_port         = var.svc_port
    protocol        = "tcp"
    security_groups = var.alb_sgs
    description     = "from LB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all egress traffic"
  }

  tags = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

