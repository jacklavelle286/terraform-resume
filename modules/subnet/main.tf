resource "aws_subnet" "this" {
  vpc_id = var.vpc_id
  
  cidr_block = var.subnet_cidr_block
  tags = {
    Name = var.subnet_name
  }
  availability_zone = var.subnet_az
}