locals {
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone
  private_hosted_zone = data.terraform_remote_state.network.outputs.private_dns_zone

  vpc_id = data.terraform_remote_state.network.outputs.vpc.id
  
  subnets = data.terraform_remote_state.network.outputs.subnets

  key_pair = data.terraform_remote_state.jenkins_shared.outputs.jenkins_key_pair

  security_group = data.terraform_remote_state.jenkins_shared.outputs.server_security_group

  internal_alb = data.terraform_remote_state.jenkins_routing.outputs.internal_alb
  external_alb = data.terraform_remote_state.jenkins_routing.outputs.external_alb
}
