locals {
  domain = var.domain
  
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone
  private_hosted_zone = {
    id = data.terraform_remote_state.shared.outputs.private_dns_zone
  }
  
  public_subnets  = data.terraform_remote_state.shared.outputs.public_subnet_ids
  private_subnets = data.terraform_remote_state.shared.outputs.private_subnet_ids

  internal_alb_security_group = data.terraform_remote_state.jenkins_shared.outputs.internal_alb_security_group
  external_alb_security_group = data.terraform_remote_state.jenkins_shared.outputs.external_alb_security_group

  acm_certificate = data.terraform_remote_state.jenkins_shared.outputs.acm_certificate

  jenkins_builds_s3_bucket = data.terraform_remote_state.jenkins_shared.outputs.jenkins_builds_s3_bucket
}
