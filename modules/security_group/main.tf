resource "aws_security_group" "this" {
 name = var.security_group_name
 vpc_id = var.vpc_id
}