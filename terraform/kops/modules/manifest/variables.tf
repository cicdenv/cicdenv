variable "terraform_settings" {
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

# From kops-driver
variable "cluster_settings" {
  type = object({
    kubernetes_version   = string
    master_instance_type = string
    master_volume_size   = string
    node_instance_type   = string
    node_volume_size     = string
    node_count           = string
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
