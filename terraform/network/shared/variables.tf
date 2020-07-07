variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
variable "domain" {} # domain.tfvars

variable "ssh_service_port" {} # bastion.tfvars
variable "ssh_host_port"    {} # bastion.tfvars
variable "iam_event_port"   {} # bastion.tfvars

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
