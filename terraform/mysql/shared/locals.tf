locals {
  vpc_id = data.terraform_remote_state.network.outputs.vpc.id

  bastion_security_group = data.terraform_remote_state.network.outputs.bastion_service.security_group
}
