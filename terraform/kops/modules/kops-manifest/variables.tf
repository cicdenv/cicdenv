variable "cluster_short_name" {}
variable "cluster_name" {}
variable "state_store" {}

variable "kubernetes_version" {}

variable "vpc_id" {}
variable "network_cidr" {}

variable "private_dns_zone" {}

variable "private_subnets" {
  type = list
}

variable "public_subnets" {
  type = list
}

variable "availability_zones" {
  type = list
}

# IGs
variable "ami_id" {}

variable "node_count" {}
variable "node_instance_type" {}
variable "node_volume_size" {}
variable "master_instance_type" {}
variable "master_volume_size" {}

# Advanced
variable "networking" {
  default = "canal"
}

variable "kops_manifest" {
  description = "Output path of KOPS yaml manifest file."
}

variable "cloud_labels" {
  type        = map
  description = "ASG propagated labels for master/worker nodes"
  default     = {}
}

variable "master_iam_profile" {
  description = "Master EC2 IAM Instance (Role) Profile ARN"
}

variable "node_iam_profile" {
  description = "Node EC2 IAM Instance (Role) Profile ARN"
}

variable "master_security_groups" {
  description = "Pre-created Master SGs"
  default     = []
}

variable "node_security_groups" {
  description = "Pre-created Node SGs"
  default     = []
}

variable "internal_apiserver_security_groups" {
  description = "Pre-created internal api-server loadbalancer SGs"
  default     = []
}

variable "etcd_key_arn" {
  description = "For encrypting etcd EBS volumes"
}
