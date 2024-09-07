variable "lb_arn" {
  type = string
}

variable "port" {
 type = string
 default = "443"
}

variable "protocol" {
  type = string
  default = "HTTPS"
}

variable "cert_arn" {
  type = string
}

variable "tg_arn" {
  type = string
}