locals {
  host_name = "bastion-${terraform.workspace}"

  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.apt_repo_policy
  
  ecr_bastion_sshd_worker   = data.terraform_remote_state.ecr_bastion_sshd_worker.outputs.bastion_sshd_worker_image_repo
  ecr_bastion_events_worker = data.terraform_remote_state.ecr_bastion_events_worker.outputs.bastion_events_worker_image_repo
}
