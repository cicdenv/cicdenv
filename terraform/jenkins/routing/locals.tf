locals {
  domain = var.domain
  
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone
  private_hosted_zone = data.terraform_remote_state.domains.outputs.private_dns_zone
  
  subnets = data.terraform_remote_state.network_shared.outputs.subnets

  security_groups = data.terraform_remote_state.jenkins_shared.outputs.security_groups

  acm_certificate = data.terraform_remote_state.jenkins_shared.outputs.acm_certificate

  jenkins_builds_s3_bucket = data.terraform_remote_state.jenkins_shared.outputs.jenkins_builds_s3_bucket
}
