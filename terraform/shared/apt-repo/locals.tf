locals {
  org_account_roots = data.terraform_remote_state.accounts.outputs.org_roots

  vpc_endpoints = split(",", data.external.vpc-endpoints.result.items)
}
