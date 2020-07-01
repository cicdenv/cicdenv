variable "terraform_state" {
  type = object({
    region = string  # tf s3 backend region
    bucket = string  # tf s3 backend bucket name
  })
  description = "For importing terraform states."
}

variable "cluster_name" {
  type = string
  description = "Cluster name without workspace and domain, example: '1-18a3'."
}

# Defaults in terraform/kops/bin/kops.inc
variable "cluster_settings" {
  type = object({
    kubernetes_version   = string
    master_instance_type = string
    master_volume_size   = string
    node_instance_type   = string
    node_volume_size     = string
    nodes_per_az         = string
  })
  description = "Overrideable cluster defaults."
}

variable "ami_id" {
  type = string
  description = "AWS EC2 Machine Image (AMI) id."
}

variable "folders" {
  type = object({
    home_folder = string  # terraform/kops/clusters/<cluster>/
    pki_folder  = string  # terraform/kops/backend/pki/<workspace>/
  })
  description = "Relative to terraform/kops/clusters/<cluster>/kops"
}
