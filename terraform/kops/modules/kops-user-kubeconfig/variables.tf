variable "cluster_name" {}

variable "kops_ca_cert"    {}
variable "user_kubeconfig" {}

variable "authenticator_command" {
  default = "aws-iam-authenticator"
}
