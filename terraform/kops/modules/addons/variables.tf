variable "terraform_state" {
  type = object({
    region = string  # tf s3 backend region
    bucket = string  # tf s3 backend bucket name
  })
  description = "For importing terraform states."
}

variable "cluster_fqdn" {
  type = string
  description = "Cluster fully qualified domain name: <cluser>-kops.<workspace>.cicdenv.com."
}

variable "admin_roles" {
  type = list(string)
  description = "List of admin role ARNs"
}

variable "input_files" {
  type = object({
    ca_cert = string
  })
  description = "Existing files."
}

variable "output_files" {
  type = object({
    authenticator_config = string
  })
  description = "Output path for files generated into terraform/kops/clusters/<name>/cluster/<workspace> component."
}
