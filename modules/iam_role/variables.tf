variable "role_name" {
  type        = string
  description = "The name of the IAM role"
}

variable "assume_role_policy" {
  type        = string
  description = "The assume role policy document"
}

variable "policy_name" {
  type        = string
  description = "The name of the IAM policy"
}

variable "policy_description" {
  type        = string
  description = "A description of the IAM policy"
  default     = ""
}

variable "policy_document" {
  type        = string
  description = "The JSON policy document"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the IAM resources"
  default     = {}
}
