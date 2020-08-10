locals {
  subnets = data.terraform_remote_state.network_backend.outputs.subnets

  security_groups = [
    data.terraform_remote_state.wireguard_backend.outputs.wireguard.security_group,
  ]

  ami_id = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_amis["ext4-none"].id
  
  instance_type = "c5n.large"

  instance_profile = data.terraform_remote_state.wireguard_backend.outputs.iam.wireguard.instance_profile

  assume_role = data.terraform_remote_state.iam_assumed_roles.outputs.iam.identity_resolver.role
  
  host_name = "wireguard"

  target_group_arns = data.terraform_remote_state.wireguard_routing.outputs.nlb.target_groups.*.arn

  wireguard_keys = data.terraform_remote_state.wireguard_backend.outputs.secrets.wireguard_keys
}
