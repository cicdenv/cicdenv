locals {
  subnets = data.terraform_remote_state.shared.outputs.subnets

  security_groups = [
    data.terraform_remote_state.shared.outputs.bastion_service.security_group,
  ]

  ami_id = var.base_ami_id != "" ? var.base_ami_id : data.terraform_remote_state.amis.outputs.base_ami.id

  ssh_key = "~/.ssh/kops_rsa.pub"
  
  instance_type = "c5d.large"

  instance_profile = data.terraform_remote_state.shared.outputs.iam.bastion.instance_profile

  assume_role = data.terraform_remote_state.iam_assumed_roles.outputs.iam.identity_resolver.role
  
  ecr_bastion_sshd_worker   = data.terraform_remote_state.ecr_bastion_sshd_worker.outputs.ecr.bastion_sshd_worker
  ecr_bastion_events_worker = data.terraform_remote_state.ecr_bastion_events_worker.outputs.ecr.bastion_events_worker

  host_name = "bastion-${terraform.workspace}"

  target_group_arns = data.terraform_remote_state.routing.outputs.bastion.nlb.target_groups.*.arn
}
