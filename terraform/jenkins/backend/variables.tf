variable "region" {} # backend-config.tfvars
variable "bucket" {} # backend-config.tfvars
variable "domain" {} # domain.tfvars

variable "ecr_repos" {
  default = [
    "jenkins-server",
    "jenkins-agent"
  ]
}
