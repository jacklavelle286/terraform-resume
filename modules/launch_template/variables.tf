variable "app_image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "launch_template_name" {
  type = string
}