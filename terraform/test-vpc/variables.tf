variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
variable "domain" {} # domain.tfvars

variable "allowed_cidr_blocks" {  # allowed-networks.tfvars
  type = list
}

variable "target_region" {
  default = "us-west-2"
}

variable "ssh_key" {
  default = "~/.ssh/manual-testing.pub"
}

variable "network_cidr" {
  default = "10.0.0.0/16"
}
