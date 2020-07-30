locals {
  main_account = data.terraform_remote_state.accounts.outputs.main_account
  organization = data.terraform_remote_state.accounts.outputs.organization

  vpc_endpoints = split(",", data.external.vpc-endpoints.result.items)

  irsa_folder = "${path.module}/irsa"
  irsa_oidc_jwks_file = "${local.irsa_folder}/jwks.json"

  irsa_oidc_s3_bucket = "oidc-irsa-${replace(var.domain, ".", "-")}"
}
