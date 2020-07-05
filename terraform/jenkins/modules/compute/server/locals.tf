locals {
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone
  private_hosted_zone = data.terraform_remote_state.network.outputs.private_dns_zone

  vpc_id = data.terraform_remote_state.network.outputs.vpc.id
  
  subnets = data.terraform_remote_state.network.outputs.subnets

  internal_alb = data.terraform_remote_state.jenkins_routing.outputs.internal_alb
  external_alb = data.terraform_remote_state.jenkins_routing.outputs.external_alb
}
