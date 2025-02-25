resource "aws_vpc_security_group_ingress_rule" "this" {
  ip_protocol = var.ip_protocol
  security_group_id = var.security_group_id
  cidr_ipv4 = var.cidr_ipv4
  from_port = var.from_port
  to_port = var.to_port
  referenced_security_group_id = var.inbound_sg_id
}