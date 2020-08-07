locals {
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone
  private_hosted_zone = data.terraform_remote_state.domains.outputs.private_dns_zone

  vpc = data.terraform_remote_state.network_shared.outputs.vpc
  
  subnets = data.terraform_remote_state.network_shared.outputs.subnets

  internal_alb = data.terraform_remote_state.jenkins_routing.outputs.internal_alb
  external_alb = data.terraform_remote_state.jenkins_routing.outputs.external_alb
}
