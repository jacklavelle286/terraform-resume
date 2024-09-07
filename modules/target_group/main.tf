resource "aws_lb_target_group" "this" {
  name = var.aws_lb_tg_name
  port = var.port
  protocol = var.protocol
  vpc_id = var.vpc_id
}