variable "domain_name" {
  description = "The primary domain name for the certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "List of alternative domain names"
  type        = list(string)
  default     = []
}
