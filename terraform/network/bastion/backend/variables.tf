variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars

variable "ssh_service_port" {} # bastion.tfvars
variable "ssh_host_port"    {} # bastion.tfvars
variable "iam_event_port"   {} # bastion.tfvars

variable "allowed_cidr_blocks" {  # allowed-networks.tfvars
  type = list
}
