resource "aws_launch_template" "this" {
 image_id = var.app_image_id
 vpc_security_group_ids = var.security_group_ids
 instance_type = var.instance_type
 name = var.launch_template_name
 update_default_version = true
 }