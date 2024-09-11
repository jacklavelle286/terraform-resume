output "aws_lb_target_group_id" {
  value = aws_lb_target_group.this.id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}