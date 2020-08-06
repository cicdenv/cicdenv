locals {
  vpc_id = data.terraform_remote_state.network_shared.outputs.vpc.id

  bastion_security_group = data.terraform_remote_state.bastion_backend.outputs.bastion_service.security_group
}
