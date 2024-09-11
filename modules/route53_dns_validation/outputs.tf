output "record_fqdns" {
  description = "The fully qualified domain names (FQDNs) of the DNS validation records"
  value       = aws_route53_record.this.fqdn
}
