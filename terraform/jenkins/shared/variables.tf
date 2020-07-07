variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
variable "domain" {} # domain.tfvars

variable "allowed_cidr_blocks" {  # allowed-networks.tfvars
  type = list
}

variable "github_hooks_cidr_blocks" {  # allowed-networks.tfvars
  type = list
}

variable "target_region" {
  default = "us-west-2"
}
