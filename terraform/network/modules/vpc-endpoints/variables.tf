variable "name" {
  description = "VPC name for use in tagging."
}

variable "vpc_id" {}

variable "private_subnets" {
  type = list
}

variable "private_dns_enabled" {
  type = bool
  
  default = true
}
