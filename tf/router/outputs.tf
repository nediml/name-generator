output "alb" { value = aws_lb.alb }

output "listener_prod" {value = aws_lb_listener.prod }
output "listener_test" {value = aws_lb_listener.test }