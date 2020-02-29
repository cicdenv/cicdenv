locals {
  account_id = data.aws_caller_identity.current.account_id
  
  wildcard_site_cert = data.terraform_remote_state.shared_domains.outputs.wildcard_site_cert
  public_hosted_zone = data.aws_route53_zone.public_hosted_zone
}
