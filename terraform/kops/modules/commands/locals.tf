data "external" "kops_version" {
  program = ["bash", "-c", "jq -n --arg version \"$(kops version --short)\" '{\"output\":$version}'"]
}

locals {
  # kops/backend
  state_store = data.terraform_remote_state.backend.outputs.state_store
  builds      = data.terraform_remote_state.backend.outputs.builds

  cluster_fqdn = var.cluster_fqdn

  # input files
  manifest         = var.files.manifest
  public_key       = var.files.public_key
  admin_kubeconfig = var.files.admin_kubeconfig

  # folders
  pki_folder  = var.folders.pki_folder

  kops_version = data.external.kops_version.result["output"]

  kops_vars = {
    KOPS_STATE_S3_ACL = "bucket-owner-full-control"

    # KOPS_BASE_URL   = "https://kubeupv2.s3.amazonaws.com/kops/"
    KOPS_BASE_URL     = "https://s3-${var.terraform_state.region}.amazonaws.com/${local.builds.bucket.name}/kops/${urlencode(local.kops_version)}/"
  }
  env_vars = join(" ", [for key in keys(local.kops_vars) : "${key}='${local.kops_vars[key]}'"])

  # https://github.com/kubernetes/kops/blob/master/upup/pkg/fi/lifecycle.go
  iam_overrides = [
    "IAMRole=ExistsAndWarnIfChanges",
    "IAMRolePolicy=ExistsAndWarnIfChanges",
    "IAMInstanceProfileRole=ExistsAndWarnIfChanges",
  ]
  lifecycle_overrides = "--lifecycle-overrides ${join(",", local.iam_overrides)}"
}
