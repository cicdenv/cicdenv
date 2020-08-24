variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
variable "domain" {} # domain.tfvars

variable "allowed_cidr_blocks" {  # allowed-networks.tfvars
  type = list
}
