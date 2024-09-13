resource "aws_lb_listener" "this" {
  load_balancer_arn = var.lb_arn
  port = 80
  protocol = "HTTP"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn



  default_action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }
}