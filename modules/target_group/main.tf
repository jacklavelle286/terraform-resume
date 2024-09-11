resource "aws_lb_target_group" "this" {
  name = var.aws_lb_tg_name
  port = var.port
  protocol = var.protocol
  vpc_id = var.vpc_id
  health_check{
    path                = "/"   # Change this if your health check path is different (e.g., /health)
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5    # Timeout in seconds
    interval            = 30   # Interval in seconds
    matcher             = "200" # HTTP status code to expect
  }
 
}