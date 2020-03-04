variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
variable "domain" {} # domain.tfvars

variable "cluster_names" { # dynamodb[kops-clusters][FQDN]
  type = list(string)
  default = []
}

variable "whitelisted_cidr_blocks" {  # whitelisted-networks.tfvars
  type = list
}

variable "target_region" {
  default = "us-west-2"
}
