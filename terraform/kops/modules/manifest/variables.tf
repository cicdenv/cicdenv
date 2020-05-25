variable "terraform_state" {
  type = object({
    region = string  # tf s3 backend region
    bucket = string  # tf s3 backend bucket name
  })
  description = "For importing terraform states."
}

variable "cluster_fqdn" {
  type = string
  description = "Cluster fully qualified domain name: <cluser>-<workspace>.kops.cicdenv.com."
}

# From kops-driver
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

variable "output_files" {
  type = object({
    manifest = string
  })
  description = "Output path for the generated 'kops cluster create' input yaml file."
}
