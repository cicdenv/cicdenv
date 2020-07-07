variable "region"              {} # backend-config.tfvars
variable "bucket"              {} # backend-config.tfvars
variable "allowed_cidr_blocks" {  # allowed-networks.tfvars
  type = list
}

variable "ssh_service_port" {} # bastion.tfvars
variable "ssh_host_port"    {} # bastion.tfvars

variable "target_region" {
  default = "us-west-2"
}

variable "base_ami_id" {} # amis.tfvars
