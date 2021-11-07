# Application Load Balancer Security Group
# Allowing access only on lister ports (80, 443)
resource "aws_security_group" "lb" {
  vpc_id = var.vpc

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow PROD traffic"
  }

  ingress {
    from_port = 81
    to_port   = 81
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow TEST traffic"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all egress traffic"
  }

  tags = merge(var.common_tags,{
    Name = "${var.proj_name}-${var.env}-${var.module_name}"
  })

  lifecycle { create_before_destroy = true }
}