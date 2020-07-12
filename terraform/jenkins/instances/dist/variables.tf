variable "region"      {} # backend-config.tfvars
variable "bucket"      {} # backend-config.tfvars
variable "base_ami_id" {} # amis.tfvars

variable "target_region" {
  default = "us-west-2"
}

variable "server_instance_type" {
  default = "m5dn.large"
}
variable "agent_instance_type" {
  default = "z1d.large"
}
variable "agent_count" {
  default = 3
}
variable "executors" {
  default = 2
}
