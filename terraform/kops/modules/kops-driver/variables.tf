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

variable "node_count" {
  default = -1 # Will default to 1 per AZ
}
variable "node_instance_type" {
  default = "r5dn.xlarge"	
}
variable "node_volume_size" {
  default = 100
}

variable "master_instance_type" {
  default = "c5d.large"
}
variable "master_volume_size" {
  default = "100"
}

variable "cloud_labels" {
  type = map
  default = {}
}
