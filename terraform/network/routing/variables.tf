variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars

variable "ssh_service_port" {} # bastion.tfvars
variable "ssh_host_port"    {} # bastion.tfvars

variable "target_region" {
  default = "us-west-2"
}
