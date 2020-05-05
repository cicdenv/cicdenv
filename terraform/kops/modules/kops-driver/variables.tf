variable "region"      {} # backend-config.tfvars
variable "bucket"      {} # backend-config.tfvars
variable "domain"      {} # domain.tfvars

variable "cluster_short_name" {}
variable "kubernetes_version" {}
variable "cluster_home" {
  description = "Parent folder of cluster states.  (kops/clusters/<cluster>)"
}
variable "pki_folder" {
  description = "Folder with kubernetes CA cert and private key."
}

variable "node_count" {}
variable "node_instance_type" {}
variable "node_volume_size" {
  default = 100
}

variable "master_instance_type" {}
variable "master_volume_size" {
  default = 100
}

variable "cloud_labels" {
  type = map
  default = {}
}
