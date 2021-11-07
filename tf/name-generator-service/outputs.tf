output "tg_blue" { value = aws_lb_target_group.blue }
output "tg_green" { value = aws_lb_target_group.green }
output "ecs_service" { value = aws_ecs_service.service }

