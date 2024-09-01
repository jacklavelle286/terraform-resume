resource "aws_launch_template" "this" {
 image_id = var.app_image_id
 security_group_names = var.security_group_names
 instance_type = var.instance_type
 name = var.launch_template_name
}