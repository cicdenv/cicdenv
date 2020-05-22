locals {
  all_account_roots = data.terraform_remote_state.accounts.outputs.all_roots
  org_account_roots = data.terraform_remote_state.accounts.outputs.org_roots

  wildcard_site_cert = data.terraform_remote_state.shared_domains.outputs.wildcard_site_cert
  public_hosted_zone = data.aws_route53_zone.public_hosted_zone
}
