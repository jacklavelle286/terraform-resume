variable "domain_validation_options" {
  description = "The domain validation options provided by ACM"
  type        = list(object({
    domain_name             = string
    resource_record_name    = string
    resource_record_value   = string
    resource_record_type    = string
  }))
}

variable "zones" {
  description = "Map of domain names to their Route53 hosted zone IDs"
  type        = map(string)
}
