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

variable "folders" {
  type = object({
    working_dir = string  # terraform/kops/clusters/<cluster>/cluster/<workspace>
    pki_folder  = string  # terraform/kops/backend/pki
  })
  description = "Relative to terraform/kops/clusters/<cluster>/kops"
}

variable "input_files" {
  type = object({
    manifest = string
    ssh_key  = string
    ca_cert  = string
  })
  description = "Existing files."
}

variable "output_files" {
  type = object({
    admin_kubeconfig = string
    user_kubeconfig  = string
  })
  description = "Output path for files generated into terraform/kops/clusters/<name>/cluster/<workspace> component."
}
