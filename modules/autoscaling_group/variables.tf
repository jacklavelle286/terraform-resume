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

variable "availability_zones" {
  type = list(string)
}