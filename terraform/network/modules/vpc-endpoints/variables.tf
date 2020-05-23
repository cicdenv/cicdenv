variable "name" {
  description = "VPC name for use in tagging."
}

variable "vpc_id" {}


variable "public_route_tables" {
  type = list
}

variable "private_route_tables" {
  type = list
}

variable "private_subnets" {
  type = list
}
