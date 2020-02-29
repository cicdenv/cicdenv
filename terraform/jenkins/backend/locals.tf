locals {
  all_account_roots = data.terraform_remote_state.iam_organizations.outputs.all_account_roots
  org_account_roots = data.terraform_remote_state.iam_organizations.outputs.org_account_roots

  wildcard_site_cert = data.terraform_remote_state.shared_domains.outputs.wildcard_site_cert
  public_hosted_zone = data.aws_route53_zone.public_hosted_zone
}
