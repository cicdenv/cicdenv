variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
variable "domain" {} # domain.tfvars

variable "ipam" {} # ipam.tfvars

variable "cluster_names" { # dynamodb[kops-clusters][FQDN]
  type = list(string)
  default = []
}

variable "allowed_cidr_blocks" {  # allowed-networks.tfvars
  type = list
}

variable "target_region" {
  default = "us-west-2"
}
