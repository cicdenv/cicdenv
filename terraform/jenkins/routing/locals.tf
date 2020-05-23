locals {
  domain = var.domain
  
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone
  private_hosted_zone = data.terraform_remote_state.network.outputs.private_dns_zone
  
  subnets = data.terraform_remote_state.network.outputs.subnets

  internal_alb_security_group = data.terraform_remote_state.jenkins_shared.outputs.internal_alb_security_group
  external_alb_security_group = data.terraform_remote_state.jenkins_shared.outputs.external_alb_security_group

  acm_certificate = data.terraform_remote_state.jenkins_shared.outputs.acm_certificate

  jenkins_builds_s3_bucket = data.terraform_remote_state.jenkins_shared.outputs.jenkins_builds_s3_bucket
}
