locals {
  cluster_fqdn = var.cluster_fqdn

  # input files
  manifest         = var.files.manifest
  public_key       = var.files.public_key
  admin_kubeconfig = var.files.admin_kubeconfig

  # folders
  pki_folder  = var.folders.pki_folder

  env_vars = "KOPS_STATE_S3_ACL=bucket-owner-full-control"

  # https://github.com/kubernetes/kops/blob/master/upup/pkg/fi/lifecycle.go
  iam_overrides = [
    "IAMRole=ExistsAndWarnIfChanges",
    "IAMRolePolicy=ExistsAndWarnIfChanges",
    "IAMInstanceProfileRole=ExistsAndWarnIfChanges",
  ]
  lifecycle_overrides = "--lifecycle-overrides ${join(",", iam_overrides)}"

  # kops/backend
  state_store = data.terraform_remote_state.backend.outputs.state_store
}
