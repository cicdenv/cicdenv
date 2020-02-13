variable "name" {
  description = "VPC name for use in tagging."
}

variable "availability_zones" {
  type = list
}

variable "public_subnets" {
  type = list
}

variable "private_route_tables" {
  type = list
}
