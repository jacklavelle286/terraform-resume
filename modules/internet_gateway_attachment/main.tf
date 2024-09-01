resource "aws_internet_gateway_attachment" "this" {
 internet_gateway_id = var.internet_gateway_id
 vpc_id = var.vpc_id
}