locals {
  organization = data.terraform_remote_state.accounts.outputs.organization

  vpc_endpoints = split(",", data.external.vpc-endpoints.result.items)
}
