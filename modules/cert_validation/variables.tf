variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "validation_record_fqdns" {
  description = "FQDNs of DNS validation records"
  type        = list(string)
}
