variable "min" {
  type = number
  default = 1
}

variable "max" {
  type = number
  default = 1
}

variable "desired" {
  type = number
  default = 1
}


variable "launch_template_id" {
  type = string
}

variable "vpc_zone_identifier" {
  type = list(string)
}

variable "tg_arn" {
  type = list(string)
}