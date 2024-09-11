resource "aws_lb" "alb" {
  name = var.alb_name
  internal = false
  load_balancer_type = "application"
  security_groups = var.alb_security_groups
  subnets = var.alb_subnets
}