variable "env_map" {
  type = map(string)
  default = {}
}

variable "role" {
  type = string
}

variable "function_name" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "source_dir" {
  type        = string
  description = "The directory containing your Lambda function code"
}

variable "create_function_url" {
  type        = bool
  description = "Whether to create a Lambda function URL"
  default     = true
}
