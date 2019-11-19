variable "name" {
  description = "VPC name for use in tagging."
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC supernet.  NOTE: must not conflict with peer VPC cidr blocks."
}

variable "public_cidr_prefix_extension" {
  default     = 6  # Example: (*/16 cidr) - /22 desired, calculation: (/22 - /16 = 6)
  description = "The additional bits from the supernet for public subnet cidr blocks."
}

variable "private_cidr_offset" {
  default = 1  # Example: (*/16 cidr) - Skip over all the /22s
  description = "Private subnets offset to start at, (skip over all the public subnets)."
}

variable "private_cidr_prefix_extension" {
  default     = 3  # Example: (*/16 cidr) - /19 desired, calculation: (/19 - /16 = 3)
  description = "The additional bits from the supernet for private subnet cidr blocks."
}

variable "public_subnet_tags" {
  type = map
  description = "Additional public subnet tags.  Some use cases require this (kops)"
  default = {}
}

variable "private_subnet_tags" {
  type = map
  description = "Additional private subnet tags.  Some use cases require this (kops)"
  default = {}
}

variable "availability_zones" {
  type = list
  description = "Restrict AZs to just those listed."
  default = []
}
