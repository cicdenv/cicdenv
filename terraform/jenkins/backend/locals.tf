locals {
  main_account = data.terraform_remote_state.accounts.outputs.main_account
  organization = data.terraform_remote_state.accounts.outputs.organization
  
  wildcard_site_cert = data.terraform_remote_state.shared_domains.outputs.wildcard_site_cert
  public_hosted_zone = data.aws_route53_zone.public_hosted_zone
}
