locals {
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone
  private_hosted_zone = {
    id = data.terraform_remote_state.shared.outputs.private_dns_zone
  }

  vpc_id = data.terraform_remote_state.shared.outputs.vpc_id
  
  public_subnets  = data.terraform_remote_state.shared.outputs.public_subnet_ids
  private_subnets = data.terraform_remote_state.shared.outputs.private_subnet_ids

  ssh_port = 16022
  agent_port = 5000

  ami_owner = data.terraform_remote_state.iam_organizations.outputs.master_account["id"]
  ami       = data.aws_ami.custom_base.id

  key_pair = data.terraform_remote_state.jenkins_shared.outputs.jenkins_key_pair

  security_group = data.terraform_remote_state.jenkins_shared.outputs.server_security_group

  internal_alb = data.terraform_remote_state.jenkins_routing.outputs.internal_alb
  external_alb = data.terraform_remote_state.jenkins_routing.outputs.external_alb
}
