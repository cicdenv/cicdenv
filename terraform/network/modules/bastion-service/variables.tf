variable "region" {}
variable "bucket" {}

variable "vpc_id" {}

variable "zone_id" {}

variable "public_subnets" {
  type = list
}

variable "private_subnets" {
  type = list
}

variable "instance_type" {
  default = "c5d.large"
}

variable "ami_id" {}

variable "ssh_key" {
  default = "~/.ssh/kops_rsa.pub"
}

variable "assume_role" {
  description = "Identity resolver role in the master account."
}

variable "security_group" {
  description = "Security group for bastion nlb/instances."
}

variable "ssh_service_port" {
  description = "SSH for normal use accessing hosts in the private subnets."
}

variable "ssh_host_port" {
  description = "SSH for admininstering the bastion ec2 instance."
}
