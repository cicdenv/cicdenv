variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars

variable "whitelisted_cidr_blocks" {  # whitelisted-networks.tfvars
  type = list
}

variable "target_region" {
  default = "us-west-2"
}

variable "cluster_short_name" {
  default = "1-18a"
}
