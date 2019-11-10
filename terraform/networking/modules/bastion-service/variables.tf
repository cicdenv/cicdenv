variable "vpc_id" {}

variable "zone_id" {}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "instance_type" {
  default = "c5d.large"
}

variable "ami" {}

variable "ssh_key" {
  default = "~/.ssh/kops_rsa.pub"
}

variable "assume_role_arn" {
  description = "Identity resolver role in the master account."
}

variable "security_groups" {
  description = "Security groups to add bastion ingress rules to."
  default = []
}

variable "whitelisted_service_cidr_blocks" {
  type = "list"
}

variable "whitelisted_host_cidr_blocks" {
  type = "list"
}

variable "service_ssh_port" {
  description = "SSH for normal use accessing hosts in the private subnets."
  default = 22
}

variable "host_ssh_port" {
  description = "SSH for admininstering the bastion ec2 instance."
  default = 2222
}
