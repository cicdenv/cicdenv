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
