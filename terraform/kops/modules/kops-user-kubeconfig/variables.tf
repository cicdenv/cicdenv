variable "cluster_name" {}
variable "state_store"  {}

variable "kops_ca_cert"    {}
variable "user_kubeconfig" {}

variable "authenticator_command" {
  default = "aws-iam-authenticator"
}
