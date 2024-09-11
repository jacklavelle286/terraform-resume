variable "alb_name" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "alb_security_groups" {
  type = list(string)
}

variable "alb_subnets" {
  type = list(string)
}