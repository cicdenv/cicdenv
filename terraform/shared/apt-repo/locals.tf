locals {
    org_account_roots = data.terraform_remote_state.iam_organizations.outputs.org_account_roots

    vpc_endpoints = split(",", data.external.vpc-endpoints.result.items)
}
