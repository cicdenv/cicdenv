variable "default_vpc_cidr" {
  type = map
  default = {}
  description = "Create account (workspace) specific overrides with scripts/create-default-vpc-vars.sh"
}

variable "default_vpc_subnet_cidrs" {
  type = map
  default = {}
  description = "Create account (workspace) specific overrides with scripts/create-default-vpc-vars.sh"
}

variable "default_vpc_subnet_azs" {
  type = map
  default = {}
  description = "Create account (workspace) specific overrides with scripts/create-default-vpc-vars.sh"
}
