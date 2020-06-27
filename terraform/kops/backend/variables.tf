variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
variable "domain" {} # domain.tfvars

variable "whitelisted_cidr_blocks" {  # whitelisted-networks.tfvars
  type = list
}
