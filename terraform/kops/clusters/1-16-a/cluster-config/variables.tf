variable "region"      {} # backend-config.tfvars
variable "bucket"      {} # backend-config.tfvars
variable "domain"      {} # domain.tfvars

variable "target_region" {
  default = "us-west-2"
}
