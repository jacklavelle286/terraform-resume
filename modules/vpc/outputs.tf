output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr_bloc" {
  value = aws_vpc.this.cidr_block
}