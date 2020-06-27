locals {
  all_account_roots = data.terraform_remote_state.accounts.outputs.all_roots
  org_account_roots = data.terraform_remote_state.accounts.outputs.org_roots

  vpc_endpoints = split(",", data.external.vpc-endpoints.result.items)

  irsa_folder = "${path.module}/irsa"
  irsa_oidc_jwks_file = "${local.irsa_folder}/jwks.json"

  irsa_oidc_s3_bucket = "oidc-irsa-${replace(var.domain, ".", "-")}"
}
