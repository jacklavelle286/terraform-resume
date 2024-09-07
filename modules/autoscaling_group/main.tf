resource "aws_autoscaling_group" "this" {
  max_size = var.min
  min_size = var.max
  desired_capacity = var.desired
  vpc_zone_identifier = var.vpc_zone_identifier
  launch_template {
    id = var.launch_template_id
    version = "$Latest"
  }
}