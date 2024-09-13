output "record_fqdns" {
  value = aws_route53_record.this[*].fqdn
}
