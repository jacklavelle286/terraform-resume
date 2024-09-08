data "aws_route53_zone" "this" {
  for_each = var.zones

  name         = each.value
  private_zone = false
}

resource "aws_route53_record" "this" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = var.zones[dvo.domain_name]
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

output "record_fqdns" {
  value = aws_route53_record.this[*].fqdn
}
