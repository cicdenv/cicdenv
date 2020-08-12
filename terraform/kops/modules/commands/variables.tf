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

variable "files" {
  type = object({
    manifest         = string
    ssh_key          = string
    admin_kubeconfig = string
  })
  description = "File locations."
}

variable "folders" {
  type = object({
    pki_folder  = string  # terraform/kops/backend/pki
  })
  description = "Relative to terraform/kops/clusters/<cluster>/kops"
}
