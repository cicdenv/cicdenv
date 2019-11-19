variable "default_vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "default_vpc_subnet_cidrs" {
  type = list
  description = "Ordered list of subnet cidrs: [172.31.16.0/20, ...]"
}

variable "default_vpc_subnet_azs" {
  type = list
  description = "Ordered list of subnet names: <region><a-...>"
}
