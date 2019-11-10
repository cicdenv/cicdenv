variable "region"   {} # backend-config.tfvars
variable "bucket"   {} # backend-config.tfvars
variable "accounts" {} # accounts.tfvars

variable "target_region" {
  default = "us-west-2"
}
